#import "GITHUBAPIController.h"
#import <AFNetworking/AFNetworking.h>
#import "Repository.h"


static NSString *const kBaseAPIURL = @"https://api.github.com";
static NSString *const kFieldName = @"name";
static NSString *const kFieldAuthor = @"author";
static NSString *const kFieldDate = @"date";
static NSString *const kFieldCommit = @"commit";
static NSString *const kFieldCommitter = @"committer";


@interface GITHUBAPIController ()
@property (nonatomic) AFHTTPSessionManager *sessionManager;
@end


@implementation GITHUBAPIController

#pragma mark - Object lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *apiURL = [NSURL URLWithString:kBaseAPIURL];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:apiURL];
    }

    return self;
}

+ (instancetype)sharedController
{
    static GITHUBAPIController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[GITHUBAPIController alloc] init];
    });

    return sharedController;
}

#pragma mark - Inner requests

- (void)getInfoForUser:(NSString *)userName
    success:(void (^)(NSDictionary *))success
    failure:(void (^)(NSError *))failure
{
    NSString *requestString = [[NSString stringWithFormat:@"users/%@", userName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    [self.sessionManager
        GET:requestString
        parameters:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    
}

- (void)getRepositoriesForUser:(NSString *)userName
                       success:(void (^)(NSArray *))success
                       failure:(void (^)(NSHTTPURLResponse *, NSError *))failure
{
    NSString *requestString = [[NSString stringWithFormat:@"users/%@/repos", userName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self.sessionManager
     GET:requestString
     parameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable responseObject) {
         if (success) {
             success(responseObject);
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failure) {
             NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
             failure(response, error);
         }
     }];
}

- (void)getCommitsForUser:(NSString *)userName
           inRepositories:(NSString *)repositorName
                  success:(void (^)(NSArray *))success
                  failure:(void (^)(NSHTTPURLResponse *, NSError *))failure
{
    NSString *requestString = [[NSString stringWithFormat:@"repos/%@/%@/commits", userName, repositorName]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self.sessionManager
     GET:requestString
     parameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable responseObject) {
         if (success) {
             success(responseObject);
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failure) {
             NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
             failure(response, error);
         }
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

- (void)getRepositoriesInfoForUser:(NSString *)userName
                           success:(void (^)(NSArray *))success
                           failure:(void (^)(NSHTTPURLResponse *, NSError *))failure
{
    NSMutableArray *repositoriesInfo = [NSMutableArray array];
    [self getRepositoriesForUser:userName success:^(NSArray *repositories) {
        if (success) {
            dispatch_group_t group = dispatch_group_create();
            for (NSDictionary *repositor in repositories) {
                dispatch_group_enter(group);
                NSString *repositorName = repositor[kFieldName];
                
                [self getCommitsForUser:userName inRepositories:repositorName success:^(NSArray *commits) {
                    if (commits.count) {
                        NSString *authorLastCommit = commits[0][kFieldCommit][kFieldCommitter][kFieldName];
                        NSString *dateLastCommit = commits[0][kFieldCommit][kFieldCommitter][kFieldDate];
                        [repositoriesInfo addObject:[[Repository alloc]initWithName:repositorName lastCommiterAuthor:authorLastCommit lastCommitDate:dateLastCommit]];
                    }
                    dispatch_group_leave(group);
                    
                } failure:^(NSHTTPURLResponse *response, NSError *error) {
                    if (response.statusCode == 409) {
                        [repositoriesInfo addObject:[[Repository alloc]initWithName:repositorName]];
                    } else {
                        failure(response, error);
                    }
                    dispatch_group_leave(group);
                }];
            }
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                
            success([repositoriesInfo copy]);
            });
        }
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        failure(response, error);
    }];
}



@end
