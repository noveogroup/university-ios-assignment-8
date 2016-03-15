#import <Foundation/Foundation.h>
@class Repository;

typedef void(^CompletionBlock)(id result, NSError *error);


@interface GITHUBAPIController : NSObject


+ (instancetype)sharedController;

- (void)getAvatarForUser:(NSString *)userName
    success:(void(^)(NSURL *))success
    failure:(void(^)(NSError *))failure;

- (void)getInfoForUser:(NSString *)userName
               success:(void (^)(NSDictionary *))success
               failure:(void (^)(NSError *))failure;

- (void)getInfoFromURL:(NSString *)urlString
               success:(void (^)(NSArray *))success
               failure:(void (^)(NSError *))failure;


- (void)getRepositoriesForUser:(NSString *)userName
           withCompletionBlock:(CompletionBlock)completionBlock;

- (void)getCommitInfoForRepositories:(NSArray *)repositories
           withCompletionBlock:(CompletionBlock)completionBlock;


@end
