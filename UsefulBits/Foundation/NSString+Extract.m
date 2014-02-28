#import "NSString+Extract.h"


@implementation NSString (Extract)

- (NSString *)stringByTrimmingWhiteSpace;
{
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
