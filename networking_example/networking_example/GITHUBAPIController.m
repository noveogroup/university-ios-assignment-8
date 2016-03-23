#import "GITHUBAPIController.h"

static NSString *const kBaseAPIURL = @"https://api.github.com";

@interface GITHUBAPIController ()
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
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
    NSString *encidedUserName = [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];

    NSString *requestString = [NSString stringWithFormat:@"users/%@", encidedUserName];

    [self.sessionManager
        GET:requestString
        parameters:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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

- (void)getReposForUser:(NSString *)userName
                success:(void (^)(NSArray <RepositoryModel *> *))success
                failure:(void (^)(NSError *))failure
{
    NSString *encidedUserName = [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];

    [self.sessionManager GET:[NSString stringWithFormat:@"users/%@/repos", encidedUserName]
                parameters:nil
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                    }
                     success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                         if (success) {
                            
                             NSMutableArray <RepositoryModel *> *objects = [NSMutableArray array];
                             NSArray *response = (NSArray *)responseObject;
                             for (NSDictionary *dict in response) {
                                 
                                 RepositoryModel *repository = [[RepositoryModel alloc] initWithResponseDict:dict];
                                 
                                 if (repository) {
                                     [objects addObject:repository];
                                 }
                             }

                             success(objects);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         failure(error);
                     }];
}




@end
