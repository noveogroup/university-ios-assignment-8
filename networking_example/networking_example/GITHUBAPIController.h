#import <Foundation/Foundation.h>

#import "RepositoryModel.h"

#import <AFNetworking/AFNetworking.h>

@interface GITHUBAPIController : NSObject
+ (instancetype)sharedController;

- (void)getAvatarForUser:(NSString *)userName
    success:(void(^)(NSURL *))success
    failure:(void(^)(NSError *))failure;

- (void)getReposForUser:(NSString *)userName
                success:(void (^)(NSArray <RepositoryModel *> *))success
                failure:(void (^)(NSError *))failure;

@end
