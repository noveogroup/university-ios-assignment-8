#import <Foundation/Foundation.h>


@interface Repository : NSObject
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *fullName;
@property (assign, nonatomic) NSInteger commitsCount;
@end
