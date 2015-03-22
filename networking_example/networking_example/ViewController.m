#import "ViewController.h"
#import "GITHUBAPIController.h"
#import <UIImageView+AFNetworking.h>


@interface ViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) GITHUBAPIController *controller;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSArray *userRepoArray;
@property (copy, nonatomic) NSDictionary *repoCommitCount;

-(void) loadRepoInfoWithCompletion:(void(^)(NSError*)) completion;
@end


@implementation ViewController

@synthesize userRepoArray = userRepoArray_;
@synthesize repoCommitCount = repoCommitCount_;

-(NSArray*) userRepoArray
{
    if (!userRepoArray_)
        userRepoArray_ = [NSArray array];
    
    return userRepoArray_;
}

-(NSDictionary*) repoCommitCount
{
    if(!repoCommitCount_)
        repoCommitCount_ = [[NSDictionary alloc] init];
    
    return repoCommitCount_;
}

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
    
    [self loadRepoInfoWithCompletion:^(NSError *error) {
        
        [i stopAnimating];
        [grayView removeFromSuperview];
        if (!error)
            [self.tableView reloadData];
    }];
}


-(void) loadRepoInfoWithCompletion:(void (^)(NSError *))completion
{
    NSString *userName = self.textField.text;
    typeof(self) __weak wself = self;
    
    [self.controller getRepositories4User:userName
                                  success:^(NSArray *responseArray){
                                      wself.userRepoArray = responseArray;
                                      /*
                                          for(NSDictionary *repo in wself.userRepoArray){
                                              
                                              [self.controller getCommitsByRepoName:[NSString stringWithFormat:@"%@",repo[@"name"]]
                                                                           userName:userName
                                                                            success:^(NSArray *responseArray) {
                                                                                
                                                                                if ([responseArray count] != 0){
                                                                                    NSLog([NSString stringWithFormat:@"%@ - %lu",repo[@"name"], [responseArray count]]);
                                       
                                                                                     [wself.repoCommitCount setValue:@([responseArray count])
                                                                                     forKey:repo[@"name"]];
                                                                                }
                                                                                
                                                                            }
                                                                            failure:^(NSError *error) {
                                                                            }];
                                          }
                                        */
                                      completion(nil);
                                  }
                                  failure:^(NSError *error) {
                                      
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                      message:[NSString stringWithFormat:@"%@",error]
                                                                                     delegate:nil
                                                                            cancelButtonTitle:@"Cancel"
                                                                            otherButtonTitles:nil, nil];
                                      [alert show];
                                      completion(error);
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

- (void)showUserRepositories
{
    NSString *userName = self.textField.text;
    
    typeof(self) __weak wself = self;
    
    [self.controller getRepositories4User:userName
                                  success:^(NSArray *responseArray){
                                     wself.userRepoArray = responseArray;
                                      
                                      [wself.tableView reloadData];
                                 }
                                  failure:^(NSError *error) {
                                    
                                 }];

    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.userRepoArray count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#define REUSABLE_CELL_ID @"ReusableCellID"
    
    UITableViewCell *tableViewCell =
    [tableView dequeueReusableCellWithIdentifier:REUSABLE_CELL_ID];
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                               reuseIdentifier:REUSABLE_CELL_ID];
    }
    
    tableViewCell.textLabel.text = [NSString stringWithFormat:@"%@",self.userRepoArray[indexPath.row][@"name"]];
    
    return tableViewCell;
    
#undef REUSABLE_CELL_ID
}

@end
