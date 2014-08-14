#import "ViewController.h"
#import "GITHUBAPIController.h"
#import <UIImageView+AFNetworking.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

static NSString *const cellId = @"RepositoriesTableCell";


@interface ViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) GITHUBAPIController *controller;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSString* currentUser;
@property (strong, nonatomic) NSArray* repositories;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.repositories = [[NSArray alloc]init];
    self.controller = [GITHUBAPIController sharedController];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self buttonTapped:self.button];
    return NO;
}

- (IBAction)buttonTapped:(UIButton *)sender
{
    AFNetworkReachabilityManager* rm = [AFNetworkReachabilityManager sharedManager];
    if(![rm isReachable]){
        UIView *grayView = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:grayView];
        grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        UIActivityIndicatorView *i= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        i.center = grayView.center;
        [i startAnimating];
        [grayView addSubview:i];
        
        [self getRepositoriesWithFinally:^{
            [grayView removeFromSuperview];
        }];
    } else {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                       message:@"Network is unreachable"
                                                      delegate:nil cancelButtonTitle:@"YEEEAH"
                                             otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void)getRepositoriesWithFinally:(void (^)(void))finally
{
    self.currentUser = self.textField.text;
    
    [self.textField resignFirstResponder];
    
    typeof(self) __weak wself = self;
    
    [self.controller
     getRepositoriesForUser:self.currentUser
     success:^(NSArray *repositories) {
         wself.repositories = repositories;
         [wself.tableView reloadData];
         finally();
     }
     failure:^(NSError *error) {
         UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                        message:[NSString stringWithFormat:@"%@",error]
                                                       delegate:nil cancelButtonTitle:@"YEEEAH"
                                              otherButtonTitles:nil, nil];
         [alert show];
         finally();
     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.repositories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(tableViewCell == nil){
        tableViewCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        tableViewCell.textLabel.text = [NSString stringWithFormat:@"%@", self.repositories[indexPath.row][@"name"]];
        [self.controller getCommitsforRepository:tableViewCell.textLabel.text
                                            user:self.currentUser
                                         success:^(NSArray * commits) {
                                             tableViewCell.detailTextLabel.text =
                                             [NSString stringWithFormat:@"%d commits",[commits count]];
                                             [tableView reloadData];
                                         } failure:^(NSError *error) {
                                             NSLog(@"%@",error);
                                         }
         ];
    }
    return tableViewCell;
    
}

@end




