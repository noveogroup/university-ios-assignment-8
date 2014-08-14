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
         if ([responseObject isKindOfClass:[NSArray class]]) {
             NSArray* responseArray = responseObject;
             success(responseArray);
         } else {
             UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                            message:@"Unexpected response"
                                                           delegate:nil cancelButtonTitle:@"YEEEAH"
                                                  otherButtonTitles:nil, nil];
             [alert show];
             success(nil);
         }
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
    
    NSString *requestString = [NSString
                               stringWithFormat:@"users/%@/repos", userName];    
    [self.requestManager
     GET:requestString
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if ([responseObject isKindOfClass:[NSArray class]]) {
             NSArray* responseArray = responseObject;
             success(responseArray);
         } else {
             UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                            message:@"Unexpected response"
                                                           delegate:nil cancelButtonTitle:@"YEEEAH"
                                                  otherButtonTitles:nil, nil];
             [alert show];
             success(nil);
         }
         
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failure(error);
     }];
}


@end




