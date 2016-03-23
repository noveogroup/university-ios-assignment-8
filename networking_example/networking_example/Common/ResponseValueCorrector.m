
#import "ResponseValueCorrector.h"

@implementation ResponseValueCorrector

+ (float)correctFloatValue:(id)value
{
    if (!value) {
        return 0;
    }
    if ([value isKindOfClass:[NSNull class]]) {
        return 0;
    } else {
        return [value floatValue];
    }
}

+ (NSInteger)correctIntValue:(id)value
{
    if (!value) {
        return 0;
    }
    if ([value isKindOfClass:[NSNull class]]) {
        return 0;
    } else {
        return [value integerValue];
    }
}

+ (NSString *) correctStringValue:(id)value
{
    if (!value) {
        return @"";
    }
    if ([value isKindOfClass:[NSNull class]]) {
        return @"";
    } else {
        return value;
    }
}

+ (BOOL) isCorrectObject:(id)object
{
    if (!object) {
        return NO;
    }
    if ([object isKindOfClass:[NSNull class]]) {
        return NO;
    } else {
        return YES;
    }
}

@end
