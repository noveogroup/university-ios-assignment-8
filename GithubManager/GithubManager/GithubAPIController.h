#import <Foundation/Foundation.h>

@interface GithubAPIController : NSObject

- (void)getUserRepositoriesForUserName:(NSString *)name
                               success:(void(^)(NSArray *))success
                               failure:(void(^)(NSString *))failure;

@end
