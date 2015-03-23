#import "ViewController.h"
#import "GITHUBAPIController.h"
#import <UIImageView+AFNetworking.h>


@interface ViewController () <UITextFieldDelegate>
@property (strong, nonatomic) GITHUBAPIController *controller;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) UIView *grayView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.controller = [GITHUBAPIController sharedController];
    self.grayView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.grayView.center;
    [self.grayView addSubview:self.activityIndicator];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self getRepositoriesAndShow];
    return NO;
}

- (IBAction)buttonTapped:(UIButton *)sender
{
    [self getRepositoriesAndShow];
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
        }
        failure:^(NSError *error) {
            NSLog(@"Error: %@", error);
        }];
}

- (void)getRepositoriesAndShow
{
    [self showActivityModalView];
    
    NSString *userName = self.textField.text;
    
    [self.textField resignFirstResponder];
    
    typeof(self) __weak wself = self;
    
    [self.controller
     getRepositoriesForUser:userName
     success:^(NSArray *repositories) {
         NSLog(@"Repositories: %@", repositories);
         [wself hideActivityModalView];
     }
     failure:^(NSError *error) {
         NSLog(@"Error: %@", error);
         [wself hideActivityModalView];
     }];

}

- (void)showActivityModalView
{
    [self.view addSubview:self.grayView];
    [self.activityIndicator startAnimating];
}

- (void)hideActivityModalView
{
    [self.grayView removeFromSuperview];
    [self.activityIndicator stopAnimating];
}

@end
