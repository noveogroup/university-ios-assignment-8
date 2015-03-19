#import "ViewController.h"
#import "GITHUBAPIController.h"
#import <UIImageView+AFNetworking.h>


@interface ViewController () <UITextFieldDelegate>
@property (strong, nonatomic) GITHUBAPIController *controller;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) NSArray *userRepoArray;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.controller = [GITHUBAPIController sharedController];
    self.userRepoArray = [NSArray array];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self showImage];
    return NO;
}

- (IBAction)buttonTapped:(UIButton *)sender
{
    [self showImage];

    UIView *grayView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:grayView];
    grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    UIActivityIndicatorView *i= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    i.center = grayView.center;
    [i startAnimating];
    [grayView addSubview:i];
    
    [self showUserRepositories];
    
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

- (void)showUserRepositories
{
    NSString *userName = self.textField.text;
    
    typeof(self) __weak wself = self;
    
    [self.controller getRepositories4User:userName
                                  success:^(NSArray *responseArray){
                                     wself.userRepoArray = responseArray;
                                      NSLog([NSString stringWithFormat:@"%@",wself.userRepoArray[0][@"name"]]);
                                 }
                                  failure:^(NSError *error) {
                                    
                                 }];

    
}

@end
