#import "RepositoriesViewController.h"
#import "ViewController.h"
#import "Cell.h"
#import "Repository.h"

@interface RepositoriesViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSDateFormatter *dateFormater;

@end

@implementation RepositoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateFormater = [[NSDateFormatter alloc] init];
    [self.dateFormater setDateFormat:@"d/M/yy HH:mm"];
}

#pragma mark - Action

- (IBAction)doneButtonTapped:(id)sender
{
    [self.delegate doneButtonDidTouch:self];
}

#pragma mark - UITableViewDataSource implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.repositories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    Repository *repository = self.repositories[indexPath.row];
    cell.repoName.text =repository.name;
    cell.info.text = [NSString stringWithFormat:@"Last commit: %@ at %@",
                      repository.lastCommiterName,
                      [self.dateFormater stringFromDate:repository.lastCommitDate]];
    return cell;
}

#pragma mark - UITableViewDelegate implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
