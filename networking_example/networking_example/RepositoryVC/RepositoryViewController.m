
#import "RepositoryViewController.h"

#import "RepositoryModel.h"

@interface RepositoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray <RepositoryModel *> *repos;

@end

@implementation RepositoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
}

- (instancetype)initWithRepos:(NSArray <RepositoryModel *> *)objects
{
    self = [super initWithNibName:nil bundle:[NSBundle mainBundle]];
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
    
    RepositoryModel* reposytory = [self.repos objectAtIndex:indexPath.row];
    tableViewCell.textLabel.text = reposytory.name;
    tableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"Updated at %@", reposytory.updated_at];

    return tableViewCell;

#undef REUSABLE_CELL_ID
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
