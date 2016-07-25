#import "ViewController.h"
#import "GithubAPIController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "RepositoriesViewController.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *cover;

@property (nonatomic) GithubAPIController *githubAPIController;
@property (nonatomic) NSArray *data;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.githubAPIController = [[GithubAPIController alloc] init];
}

- (IBAction)search:(id)sender
{
    [self.view endEditing:YES];
    [self.cover setHidden:NO];
    [self.githubAPIController getUserRepositoriesForUserName:self.textField.text
    success:^(NSArray * repositories) {
        [self.cover setHidden:YES];
        self.data = repositories;
        [self performSegueWithIdentifier:@"ShowRepositoriesID" sender:self];
    }
    failure:^(NSString *errorMessage) {
        [self.cover setHidden:YES];
        [self allertWithMessage:errorMessage];
    }];
}

#pragma mark - Allerts

- (void)allertWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Storybord

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowRepositoriesID"]) {
        RepositoriesViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        vc.repositories = self.data;
    }
}

#pragma mark - UITextFieldDelegate implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - RepositoriesViewControllerDelegate implementation

- (void)doneButtonDidTouch:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
