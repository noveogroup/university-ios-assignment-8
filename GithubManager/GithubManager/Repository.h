#import <Foundation/Foundation.h>

@interface Repository : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSDate *lastCommitDate;
@property (nonatomic) NSString *lastCommiterName;

@end
