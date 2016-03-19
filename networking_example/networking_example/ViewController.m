#import "ViewController.h"
#import "GITHUBAPIController.h"
#import <UIImageView+AFNetworking.h>
#import "RepositoryVC/RepositoryViewController.h"


@interface ViewController () <UITextFieldDelegate>
@property (strong, nonatomic) GITHUBAPIController *controller;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) UIView *grayView;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.controller = [GITHUBAPIController sharedController];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self showGrayView];
    [self loadRepos];
    [self.textField resignFirstResponder];
    return YES;
}

- (IBAction)buttonTapped:(UIButton *)sender
{
    [self showGrayView];
    //[self showImage];
    [self loadRepos];
}

- (void)loadRepos
{
    NSString *userName = self.textField.text;
    
    [self.textField resignFirstResponder];
    
    typeof(self) __weak wself = self;
    
    [self.controller
     getReposForUser:userName
     success:^(NSArray *objects) {
         
         RepositoryViewController* vc = [[RepositoryViewController alloc] initWithRepos:(NSArray *)objects];
         [wself.navigationController pushViewController:vc animated:YES];
         
         [wself.grayView removeFromSuperview];
     } failure:^(NSError *error) {
         if (error.code == -1009) {
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"The Internet connection appears to be offline." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
             [alert show];
         } else if (error.code == -1011) {
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"User with this name didn't exist." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
             [alert show];
         } else {
             NSLog(@"Error: %@", error);
         }
         
         [wself.grayView removeFromSuperview];
     }];
}

- (void)showImage
{
    NSString *userName = self.textField.text;
    
    [self.textField resignFirstResponder];
    
    typeof(self) __weak wself = self;
    
    [self.controller
     getAvatarForUser:userName
     success:^(NSURL *imageURL) {
         [wself.imageView setImageWithURL:imageURL];
         [wself.grayView removeFromSuperview];
     }
     failure:^(NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

- (void)showGrayView
{
    self.grayView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.grayView];
    self.grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    UIActivityIndicatorView *i= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    i.center = self.grayView.center;
    [i startAnimating];
    [self.grayView addSubview:i];
}

@end
