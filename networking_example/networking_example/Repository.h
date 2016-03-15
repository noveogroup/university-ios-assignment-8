static NSString *const kRepoName         = @"name";
static NSString *const kRepoFullName     = @"full_name";



@interface Repository : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *fullName;
@property (assign, nonatomic) NSInteger *commitsCount;
@property (copy, nonatomic) NSString *commitDate;
@property (copy, nonatomic) NSString *lastCommitAuthor;

@end

