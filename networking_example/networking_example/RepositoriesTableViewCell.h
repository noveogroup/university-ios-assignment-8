#import <UIKit/UIKit.h>

@interface RepositoriesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelCommit;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;

@end
