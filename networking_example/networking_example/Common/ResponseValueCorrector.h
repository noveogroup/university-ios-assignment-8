
#import <Foundation/Foundation.h>

@interface ResponseValueCorrector : NSObject

+ (float) correctFloatValue:(id)value;
+ (NSInteger) correctIntValue:(id)value;
+ (NSString *) correctStringValue:(id)value;

+ (BOOL) isCorrectObject:(id)object;

@end
