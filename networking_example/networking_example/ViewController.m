#import "ViewController.h"
#import "GITHUBAPIController.h"
#import <UIImageView+AFNetworking.h>


@interface ViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) GITHUBAPIController *controller;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *grayView;
@property (strong, nonatomic) NSMutableArray /*of NSStrings*/ *repoNames;
@end


@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder   
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _repoNames = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.controller = [GITHUBAPIController sharedController];
    self.grayView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self showImage];
    return NO;
}

- (IBAction)buttonTapped:(UIButton *)sender
{
    [self showImage];
    [self.view addSubview:self.grayView];
    
    UIActivityIndicatorView *i= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    i.center = self.grayView.center;
    [i startAnimating];
    [self.grayView addSubview:i];
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
         [wself updateRepos];
     }
     failure:^(NSError *error) {
         [wself.imageView setImage:nil];
         [wself handleError:error];
     }];
}

- (void)updateRepos
{
    NSString *userName = self.textField.text;
    
    [self.textField resignFirstResponder];
    
    typeof(self) __weak wself = self;
    
    [self.controller getDataForUser:userName 
        success:^(NSArray *dataArray) {
            [wself.repoNames removeAllObjects];
            for (NSDictionary *repo in dataArray) {
                [wself.repoNames addObject:repo[@"name"]];
            }
            [wself.tableView reloadData];
        } 
        failure:^(NSError *error) {
            [wself handleError:error];
        }];
}

- (void)handleError:(NSError *)error
{
    [self.repoNames removeAllObjects];
    [self.tableView reloadData];
    [self.grayView removeFromSuperview];
    UIAlertView* alert = [[UIAlertView alloc]
        initWithTitle:@"Something Wrong!" 
        message:[NSString stringWithFormat:@"%@",error.description] 
        delegate:nil cancelButtonTitle:@"Sad :'(" 
        otherButtonTitles: nil];
    [alert show];
}

- (NSInteger)tableView:(UITableView *)tableView 
    numberOfRowsInSection:(NSInteger)section
{
    return [self.repoNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#define REUSABLE_CELL_ID @"ReusableCellID"
    UITableViewCell *tableViewCell =
        [tableView dequeueReusableCellWithIdentifier:REUSABLE_CELL_ID];
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                               reuseIdentifier:REUSABLE_CELL_ID];
    }
    tableViewCell.textLabel.text = self.repoNames[indexPath.row];
    return tableViewCell;
#undef REUSABLE_CELL_ID
}

- (void)tableView:(UITableView *)tableView 
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
