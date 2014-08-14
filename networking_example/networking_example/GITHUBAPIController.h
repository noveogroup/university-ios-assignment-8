#import <Foundation/Foundation.h>
@class AFHTTPRequestOperation;


@interface GITHUBAPIController : NSObject
+ (instancetype)sharedController;

-(AFHTTPRequestOperation *)getCommitsforRepository:(NSString *)repositoryName
                                              user:(NSString *)userName
                                           success:(void (^)(NSArray *))success
                                           failure:(void (^)(NSError *))failure;

- (void)getRepositoriesForUser:(NSString *)userName
    success:(void(^)(NSArray *))success
    failure:(void(^)(NSError *))failure;

@end
