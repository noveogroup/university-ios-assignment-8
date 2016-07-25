#import <UIKit/UIKit.h>

@class ViewController;
@class Repository;

@interface RepositoriesViewController : UIViewController

@property (weak, nonatomic) ViewController *delegate;
@property (nonatomic) NSArray<Repository *> *repositories;

@end
