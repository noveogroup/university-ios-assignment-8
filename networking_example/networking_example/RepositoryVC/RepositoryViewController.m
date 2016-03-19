
#import "RepositoryViewController.h"

#import "Repos.h"

@interface RepositoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray* repos;

@end

@implementation RepositoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
}

- (instancetype)initWithRepos:(NSArray *)objects
{
    self = [super init];
    if (self) {
        self.repos = objects;
    }
    return self;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.repos) {
        return [self.repos count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#define REUSABLE_CELL_ID @"CellID"
    
    UITableViewCell *tableViewCell =
    [tableView dequeueReusableCellWithIdentifier:REUSABLE_CELL_ID];
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                               reuseIdentifier:REUSABLE_CELL_ID];
    }
    
    NSDictionary* repos = [self.repos objectAtIndex:indexPath.row];
    tableViewCell.textLabel.text = repos[kReposName];
    tableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"Updated at %@", repos[kReposUpdatedDate]];

    return tableViewCell;

#undef REUSABLE_CELL_ID
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
