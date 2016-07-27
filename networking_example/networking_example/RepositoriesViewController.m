#import "RepositoriesViewController.h"
#import "RepositoriesTableViewCell.h"
#import "Repository.h"

NSString *RepositoriesTableViewCellIdentifier = @"reposCell";

@interface RepositoriesViewController () <UITableViewDelegate, UITableViewDataSource>


@end

@implementation RepositoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.repositories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepositoriesTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:RepositoriesTableViewCellIdentifier];
    Repository *repository = self.repositories[indexPath.row];
    tableViewCell.labelTitle.text = repository.name;
    if (repository.lastCommiterAuthor) {
        tableViewCell.labelCommit.text = repository.lastCommiterAuthor;
        tableViewCell.labelDate.text = repository.lastCommitDate;
    } else {
        tableViewCell.labelCommit.text = @"There are no commits";
        tableViewCell.labelDate.text = @"-";
    }
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
