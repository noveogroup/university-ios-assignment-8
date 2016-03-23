
#import <UIKit/UIKit.h>

@class RepositoryModel;

@interface RepositoryViewController : UIViewController

- (instancetype)initWithRepos:(NSArray <RepositoryModel*> *)objects;

@end
