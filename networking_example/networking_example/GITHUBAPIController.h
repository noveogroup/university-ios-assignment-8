#import <Foundation/Foundation.h>


@interface GITHUBAPIController : NSObject
+ (instancetype)sharedController;

- (void)getRepositoriesForUser:(NSString *)userName
    success:(void(^)(NSArray *))success
    failure:(void(^)(NSError *))failure;

@end
