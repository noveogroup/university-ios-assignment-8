
#import <Foundation/Foundation.h>

@interface RepositoryModel : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *created_at;
@property (nonatomic, strong, readonly) NSString *updated_at;

- (instancetype)initWithResponseDict:(NSDictionary *)response;
- (instancetype)init NS_UNAVAILABLE;

@end
