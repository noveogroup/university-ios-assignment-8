#import "ViewController.h"
#import "GITHUBAPIController.h"
#import <UIImageView+AFNetworking.h>
#import "RepoListTableVC.h"
#import "Repository.h"





@interface ViewController () <UITextFieldDelegate>
@property (strong, nonatomic) GITHUBAPIController *controller;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) UIActivityIndicatorView *indincator;
@property (strong, nonatomic) UIView *indicatorBGView;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.controller = [GITHUBAPIController sharedController];

}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.textField.text length] > 0) {
        [self getUserRepositories];
        [self startActivityIndicator];
        return YES;
    }
    return NO;
}


#pragma mark - Actions

- (IBAction)buttonTapped:(UIButton *)sender
{
    if ([self.textField.text length] > 0) {
        [self getUserRepositories];
        [self startActivityIndicator];
        

    }
}

#pragma mark - Methods

- (void)startActivityIndicator
{
    self.indicatorBGView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.indicatorBGView];
    self.indicatorBGView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    self.indincator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indincator.center = self.indicatorBGView.center;
    [self.indincator startAnimating];
    [self.indicatorBGView addSubview:self.indincator];
}

- (void)stopActivityIndicator
{
    self.indicatorBGView.hidden = YES;
    [self.indincator stopAnimating];
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
         [self stopActivityIndicator];
         
     }
     failure:^(NSError *error) {
         NSLog(@"Error: %@", error);
         [self stopActivityIndicator];
         [self showAlertUserNotFound];
         
     }];
}

- (NSArray *)repositoriesFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in array) {
        Repository *repository = [[Repository alloc] init];
        repository.name = dict[kRepoName];
        repository.fullName = dict[kRepoFullName];
        [result addObject:repository];
    }
    
    return result;
}

- (void)getUserRepositories
{
    NSString *userName = self.textField.text;
    [self.textField resignFirstResponder];
    [self.controller getRepositoriesForUser:userName withCompletionBlock:^(id result, NSError *error) {
        if (!error) {
            
            NSArray *repositories = [self repositoriesFromArray:result];
            [self.controller getCommitInfoForRepositories:repositories withCompletionBlock:^(id result, NSError *error) {
                RepoListTableVC *repoTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RepoListTableVC"];
                repoTableVC.repositories = result;
                [self stopActivityIndicator];
                [self.navigationController pushViewController:repoTableVC animated:YES];
            }];
        } else {
            [self stopActivityIndicator];
            [self showAlertUserNotFound];
            NSLog(@"%@", error);
        }
        
    }];
}


- (void)showAlertUserNotFound
{
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"Error!"
                                        message:@"User not found."
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

@end
