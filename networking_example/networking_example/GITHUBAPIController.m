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

-(AFHTTPRequestOperation *)getCommitsforRepository:(NSString *)repositoryName
                          user:(NSString *)userName
                      success:(void (^)(NSArray *))success
                      failure:(void (^)(NSError *))failure
{
    NSString *requestString = [NSString
                               stringWithFormat:@"repos/%@/%@/commits", userName, repositoryName];
    
    return [self.requestManager
     GET:requestString
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSArray* responseArray = responseObject;
         success(responseArray);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failure(error);
     }];
    
}

#pragma mark - Public methods

- (void)getRepositoriesForUser:(NSString *)userName
    success:(void (^)(NSArray *))success
    failure:(void (^)(NSError *))failure
{
    typeof(self) __weak wself = self;
    
    NSString *requestString = [NSString
                               stringWithFormat:@"users/%@/repos", userName];
    
    [self.requestManager
     GET:requestString
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         NSArray* responseArray = responseObject;
         NSMutableArray* mutableRepositories = [[NSMutableArray alloc]init];
         for(NSDictionary* repository in responseArray){
             NSMutableDictionary* mutableRepository = [repository mutableCopy];
             NSString* repositoryName = repository[@"name"];
             
             [wself getCommitsforRepository:repositoryName
                                       user:userName
                                    success:^(NSArray * commits) {
                 [mutableRepository setObject:[NSNumber numberWithInt:[commits count]] forKey:@"CommitsCount"];
                 [mutableRepositories addObject:mutableRepository];
             } failure:^(NSError * error) {
                 failure(error);
             }];
         }
         success(mutableRepositories);
         
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failure(error);
     }];
}

@end




