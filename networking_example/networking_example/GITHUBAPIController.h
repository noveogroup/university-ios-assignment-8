#import <Foundation/Foundation.h>


@interface GITHUBAPIController : NSObject
+ (instancetype)sharedController;

- (void)getAvatarForUser:(NSString *)userName
                 success:(void(^)(NSURL *))success
                 failure:(void(^)(NSError *))failure;

- (void)getRepositoriesInfoForUser:(NSString *)userName
                           success:(void (^)(NSArray *))success
                           failure:(void (^)(NSHTTPURLResponse *, NSError *))failure;

@end
