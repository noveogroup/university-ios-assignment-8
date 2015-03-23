
#import "ReposVC.h"
#import "GITHUBAPIController.h"

@interface ReposVC () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ReposVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationItem) {
        self.navigationItem.title = self.userName;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.repositories count];
}

#define REUSABLE_CELL_ID @"ReusableCellID"
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:REUSABLE_CELL_ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                               reuseIdentifier:REUSABLE_CELL_ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.repositories[indexPath.row][@"name"]];
    [[GITHUBAPIController sharedController]getCommitsforRepository:cell.textLabel.text user:self.userName success:^(NSArray *commits) {
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"commits - %lu", (unsigned long)[commits count]];
        
    }failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    return cell;
    
}

@end
