#import "RepositoriesListVC.h"


static NSString *const reuseId = @"ReuseId";
static NSString *const kRepositoryName = @"name";

@interface RepositoriesListVC ()
@property (strong, nonatomic) NSArray *repositories;
@end


@implementation RepositoriesListVC

- (instancetype)initWithRepositories:(NSArray *)repositories
{
    self = [self init];
    if (self != nil) {
        _repositories = repositories;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseId];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.repositories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *repository = self.repositories[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId
        forIndexPath:indexPath];
    cell.textLabel.text = repository[kRepositoryName];
    
    return cell;
}

@end
