#import "RepoListTableVC.h"
#import "Repository.h"
#import "GITHUBAPIController.h"

@interface RepoListTableVC ()
@property (strong, nonatomic) GITHUBAPIController *controller;

@end

@implementation RepoListTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.title = @"Repo list";
    self.controller =[GITHUBAPIController sharedController];
}



#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.repositories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
    
    Repository *repository = self.repositories[indexPath.row];
    cell.textLabel.text = repository.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Commits: %ld, last commit: %@, %@",
                                 repository.commitsCount, repository.lastCommitAuthor, repository.commitDate];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
