#import "GithubAPIController.h"
#import "AFNetworking.h"
#import "Repository.h"

static NSString *const kGithubURLString = @"https://api.github.com";
static NSString *const kRepositoriyName = @"name";
static NSString *const kCommitsURL = @"commits_url";

@interface GithubAPIController ()

@property (nonatomic) AFHTTPSessionManager *sessionManager;

@property (nonatomic) NSDateFormatter *dateFormater;

@end

@implementation GithubAPIController

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *githabURL = [NSURL URLWithString:kGithubURLString];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:githabURL];
        _sessionManager.requestSerializer.timeoutInterval = 30.0;
        _dateFormater = [[NSDateFormatter alloc] init];
        [_dateFormater setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    }
    return self;
}

- (void)getUserRepositoriesForUserName:(NSString *)name
                               success:(void(^)(NSArray *))success
                               failure:(void(^)(NSString *))failure
{
    NSString *path = [NSString stringWithFormat:@"/users/%@/repos", name];
    [self.sessionManager
     GET:path
     parameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, NSArray *repositories) {
         if (success) {
             [self parseRepositories:repositories success:success failure:failure];
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failure) {
             NSHTTPURLResponse *response =
             error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
             switch (response.statusCode) {
                 case 404:
                     failure(@"User not found");
                     break;
                 case NSURLErrorNotConnectedToInternet:
                     failure(@"No internet connection");
                     break;
                 default:
                     failure(@"Unexpected error");
                     break;
             }
         }
     }];
}

- (void)parseRepositories:(NSArray *)repositories
                  success:(void(^)(NSArray *))success
                  failure:(void(^)(NSString *))failure
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    dispatch_group_t group = dispatch_group_create();
    __block NSString *commitError = nil;
    for (NSDictionary *obj in repositories) {
        dispatch_group_enter(group);
        Repository *repository = [[Repository alloc] init];
        repository.name = obj[kRepositoriyName];
        NSMutableString *str = [NSMutableString stringWithString:obj[kCommitsURL]];
        NSRange range = NSMakeRange([str length]-6, 6);
        [str deleteCharactersInRange:range];
        NSString *commitsURL = [str copy];
        [self
         getLastCommitInfoForURL:commitsURL
         success:^(NSDictionary *commit) {
            repository.lastCommitDate = commit[@"date"];
            repository.lastCommiterName = commit[@"committer"];
            [result addObject:repository];
            dispatch_group_leave(group);
        }
         failure:^(NSString *error) {
            commitError = error;
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (commitError) {
            failure(commitError);
        }
        else {
            success(result);
        }
    });
}

- (void)getLastCommitInfoForURL:(NSString *)commitsURL
                               success:(void(^)(NSDictionary *))success
                               failure:(void(^)(NSString *))failure
{
    [self.sessionManager
     GET:commitsURL
     parameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, NSArray *responseObject) {
        if (success) {
            success([self parseCommit:[responseObject firstObject]]);
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            NSHTTPURLResponse *response =
            error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
            if (response.statusCode == NSURLErrorNotConnectedToInternet) {
                failure(@"No internet connection");
            }
            else {
                failure(@"Unexpected error");
            }
        }
    }];
}

- (NSDictionary *)parseCommit:(NSDictionary *)commit
{
    NSString *stringDate = commit[@"commit"][@"committer"][@"date"];
    NSDate *date = [self.dateFormater dateFromString:stringDate];
    return @{@"committer": commit[@"commit"][@"committer"][@"name"],
             @"date": date};
}

@end
