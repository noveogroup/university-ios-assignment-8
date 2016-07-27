#import "ViewController.h"
#import "GITHUBAPIController.h"
#import <UIImageView+AFNetworking.h>
#import "RepositoriesViewController.h"

static NSString *const kStoryboardMain = @"Main";
static NSString *const kRepositoriesViewController = @"RepositoriesViewController";
static NSString *const kResponseHTTPEror404 = @"Not found";
static NSString *const kResponseHTTPEror0 = @"No internet";
static NSString *const kResponseHTTPErorElse = @"Try again";
static NSString *const kAllertTitleError = @"ERROR!!!";
static NSString *const kAllertOk = @"Ok";

@interface ViewController () <UITextFieldDelegate>
@property (nonatomic) GITHUBAPIController *controller;
@property (nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) IBOutlet UIButton *button;
@property (nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) UIView *grayView;
@property (nonatomic) UIActivityIndicatorView *indicator;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.controller = [GITHUBAPIController sharedController];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self showRepositories];
    return NO;
}

- (IBAction)buttonTapped:(UIButton *)sender
{
    [self showRepositories];
}

- (void)showRepositories
{
    [self showLoader:YES];
    
    NSString *userName = self.textField.text;
    [self.controller getRepositoriesInfoForUser:userName success:^(NSArray *repositoriesInfo) {
        [self showLoader:NO];
        NSString * storyboardName = kStoryboardMain;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        RepositoriesViewController * vc = [storyboard instantiateViewControllerWithIdentifier:kRepositoriesViewController];
        vc.repositories = repositoriesInfo;
        vc.title = userName;
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        [self showLoader:NO];
        
        NSString *message;
        switch (response.statusCode) {
            case 404:
                message = kResponseHTTPEror404;
                break;
            case 0:
                 message = kResponseHTTPEror0;
                break;
                
            default:
                message = kResponseHTTPErorElse;
                break;
        }
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:kAllertTitleError message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:kAllertOk
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)showLoader:(BOOL)active
{
    static BOOL first = YES;
    if (first) {
        self.grayView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        self.indicator= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.indicator.center = self.grayView.center;
        first = NO;
    }
    
    if (active) {
        [self.view addSubview:self.grayView];
        [self.indicator startAnimating];
        [self.grayView addSubview:self.indicator];
    } else {
        [self.indicator stopAnimating];
        [self.grayView removeFromSuperview];
    }
}

- (void)openRepositoriesViewController
{
    
}

@end
