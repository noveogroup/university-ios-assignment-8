
#import "RepositoryModel.h"

#import "ResponseValueCorrector.h"

static NSString* const kReposName = @"name";
static NSString* const kReposCreatedDate = @"created_at";
static NSString* const kReposUpdatedDate = @"updated_at";

@interface RepositoryModel ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *updated_at;

@end

@implementation RepositoryModel

- (instancetype)initWithResponseDict:(NSDictionary *)response
{
    if (![ResponseValueCorrector isCorrectObject:response]) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _name = [ResponseValueCorrector correctStringValue:response[kReposName]];
        _created_at = [ResponseValueCorrector correctStringValue:response[kReposCreatedDate]];
        _updated_at = [ResponseValueCorrector correctStringValue:response[kReposUpdatedDate]];
    }
    return self;
}

@end
