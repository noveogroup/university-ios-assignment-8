#import <UIKit/UIKit.h>
@class Repository;

@interface RepoListTableVC : UITableViewController
@property (copy, nonatomic) NSArray <Repository *> *repositories;
@end
