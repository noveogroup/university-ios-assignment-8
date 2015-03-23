#import <Foundation/Foundation.h>


@interface GITHUBAPIController : NSObject
+ (instancetype)sharedController;

- (void)getAvatarForUser:(NSString *)userName
    success:(void(^)(NSURL *))success
    failure:(void(^)(NSError *))failure;

- (void)getRepositoriesForUser:(NSString *)userName
    success:(void (^)(NSArray *))success
    failure:(void (^)(NSError *))failure;

- (void)getCommitsCountForRepositoryWithFullName:(NSString *)repositoryFullName
    success:(void (^)(NSNumber *))success
    failure:(void (^)(NSError *))failure;

@end
