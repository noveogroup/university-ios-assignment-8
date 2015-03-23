#import "RepositoriesListVC.h"
#import "Repository.h"


static NSString *const reuseId = @"ReuseId";

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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.repositories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Repository *repository = self.repositories[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
            reuseIdentifier:reuseId];
    }
    cell.textLabel.text = repository.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"commits count = %ld",
        repository.commitsCount];
    return cell;
}

@end
