#import "GITHUBAPIController.h"
#import <AFNetworking/AFNetworking.h>


static NSString *const kBaseAPIURL = @"https://api.github.com";


@interface GITHUBAPIController ()
@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager;
@end


@implementation GITHUBAPIController

#pragma mark - Object lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *apiURL = [NSURL URLWithString:kBaseAPIURL];
        self.requestManager = [[AFHTTPRequestOperationManager alloc]
            initWithBaseURL:apiURL];
    }
    return self;
}

+ (instancetype)sharedController
{
    static GITHUBAPIController *_instance = nil;
    if (_instance == nil) {
        _instance = [[self alloc] init];
    }

    return _instance;
}

#pragma mark - Inner requests

- (void)getInfoForUser:(NSString *)userName
    success:(void (^)(NSDictionary *))success
    failure:(void (^)(NSError *))failure
{
    NSString *requestString = [NSString
        stringWithFormat:@"users/%@", userName];
    
    [self.requestManager
        GET:requestString
        parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(responseObject);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
    
}

#pragma mark - Public methods

- (void)getAvatarForUser:(NSString *)userName
    success:(void (^)(NSURL *))success
    failure:(void (^)(NSError *))failure
{
    [self getInfoForUser:userName
        success:^(NSDictionary *userInfo) {
            NSString *avatarURLString = userInfo[@"avatar_url"];
            NSURL *avatarURL = [NSURL URLWithString:avatarURLString];
            success(avatarURL);
        }
        failure:^(NSError *error) {
            failure(error);
        }];
}

- (void)getRepositoriesForUser:(NSString *)userName
                       success:(void (^)(NSArray *))success
                       failure:(void (^)(NSError *))failure
{
    
    NSString *requestString = [NSString
                               stringWithFormat:@"users/%@/repos", userName];
    [self.requestManager
     GET:requestString
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if ([responseObject isKindOfClass:[NSArray class]]) {
             NSArray *repos = responseObject;
             success(repos);
         }
         else success(nil);
         
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failure(error);
     }];
}


-(void)getCommitsforRepository:(NSString *)repositoryName user:(NSString *)userName
                                           success:(void (^)(NSArray *))success
                                           failure:(void (^)(NSError *))failure
{
    NSString *requestString = [NSString
                               stringWithFormat:@"repos/%@/%@/commits", userName, repositoryName];
    
    [self.requestManager
        GET:requestString
        parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSArray* commits = responseObject;
                    success(commits);
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                failure(error);
            }];
    
}

-(void)checkServerReachabilityWithSuccess:(void (^)(void))success
                       failure:(void (^)(NSError *))failure
{
    [self.requestManager
        HEAD:@""
        parameters:nil
        success:^(AFHTTPRequestOperation *operation){
                success();
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failure(error);
     }];
}





@end
