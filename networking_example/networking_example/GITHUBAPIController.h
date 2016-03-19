#import <Foundation/Foundation.h>

#import "Repos.h"

@interface GITHUBAPIController : NSObject
+ (instancetype)sharedController;

- (void)getAvatarForUser:(NSString *)userName
    success:(void(^)(NSURL *))success
    failure:(void(^)(NSError *))failure;

- (void)getReposForUser:(NSString *)userName
                success:(void (^)(NSArray *))success
                failure:(void (^)(NSError *))failure;

@end
