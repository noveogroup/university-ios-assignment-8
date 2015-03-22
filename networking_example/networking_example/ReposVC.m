
#import "ReposVC.h"

@interface ReposVC () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ReposVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                               reuseIdentifier:REUSABLE_CELL_ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.repositories[indexPath.row][@"name"]];
    return cell;
    
}

@end
