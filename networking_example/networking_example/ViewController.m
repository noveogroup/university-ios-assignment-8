#import "ViewController.h"
#import "GITHUBAPIController.h"
#import <UIImageView+AFNetworking.h>


@interface ViewController () <UITextFieldDelegate>
@property (strong, nonatomic) GITHUBAPIController *controller;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) NSArray *repositories;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.controller = [GITHUBAPIController sharedController];
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
    [self.textField resignFirstResponder];
    
    typeof(self) __weak wself = self;

    
    [self.controller getRepositoriesForUser:self.textField.text success:^(NSArray *repositories){
        
        wself.repositories = repositories;
        [grayView removeFromSuperview];
        
    }failure:^(NSError *error) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                       message:[NSString stringWithFormat:@"Incorrect user name: %@",self.textField.text]
                                                      delegate:nil cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil, nil];
        [alert show];
        [grayView removeFromSuperview];
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
     }
     failure:^(NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

@end
