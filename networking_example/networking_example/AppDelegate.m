#import "AppDelegate.h"
#import <AFNetworkActivityIndicatorManager.h>


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    return YES;
}
							
@end
