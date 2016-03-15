#import "GITHUBAPIController.h"
#import <AFNetworking/AFNetworking.h>
#import "Repository.h"


static NSString *const kBaseAPIURL = @"https://api.github.com";


@interface GITHUBAPIController ()
@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager;
- (NSString *)shortDateString:(NSString *)dateString;
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
            if (responseObject != nil) {
                success(responseObject);
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (error) {
                failure(error);
            }
        }];
    
}

- (void)getInfoFromURL:(NSString *)urlString
               success:(void (^)(NSArray *))success
               failure:(void (^)(NSError *))failure
{
    [self.requestManager GET:urlString
                  parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         if (responseObject != nil) {
                             success(responseObject);
                         }
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         if (error) {
                             failure(error);
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
            if (error) {
                failure(error);
            }
        }];
}

- (void)getRepositoriesForUser:(NSString *)userName
           withCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"users/%@/repos", userName];
    
    [self.requestManager GET:urlString
                  parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
                         if (responseObject != nil) {
                             completionBlock(responseObject, nil);
                         }
                     }
     
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         if (error) {
                             completionBlock(nil, error);
                         }
                     }];
}


- (void)getCommitInfoForRepositories:(NSArray *)repositories
                 withCompletionBlock:(CompletionBlock)completionBlock
{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_group_t group = dispatch_group_create();
        
        for (Repository *repository in repositories) {
            dispatch_group_enter(group);
            NSString *urlString = [NSString stringWithFormat:@"repos/%@/commits",
                                   repository.fullName];
            
            [self.requestManager GET:urlString
                          parameters:nil
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 if (responseObject != nil) {
                                     repository.commitsCount = [responseObject count];
                                     NSDictionary *dict = [responseObject firstObject];
                                     NSDictionary *commit = dict[@"commit"];
                                     NSDictionary *author = commit[@"author"];
                                     repository.lastCommitAuthor = author[@"name"];
                                     repository.commitDate = [self shortDateString:author[@"date"]];
                                     
                                 }
                                 dispatch_group_leave(group);
                             }
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 if (error) {
                                     completionBlock(nil, error);
                                 }
                                 dispatch_group_leave(group);
                             }];
        }
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(repositories, nil);
        });
    });
    
}

- (NSString *)shortDateString:(NSString *)dateString {
    NSString *tempString = [dateString substringToIndex:[dateString length] - 1];
    NSArray *array = [tempString componentsSeparatedByString:@"T"];
    return [NSString stringWithFormat:@"%@ %@", array[1], array[0]];
}

@end
