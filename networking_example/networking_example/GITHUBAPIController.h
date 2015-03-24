#import <Foundation/Foundation.h>


@interface GITHUBAPIController : NSObject
+ (instancetype)sharedController;

- (void)getAvatarForUser:(NSString *)userName
    success:(void(^)(NSURL *))success
    failure:(void(^)(NSError *))failure;

-(void)getRepositories4User:(NSString *)userName
                    success:(void(^)(NSArray *)) success
                    failure:(void(^)(NSError *)) failure;

-(void)getCommitsByRepoName:(NSString *) repoName
                   userName:(NSString *) userName
                    success:(void(^)(NSArray*)) success
                    failure:(void(^)(NSError*)) failure;

@end
