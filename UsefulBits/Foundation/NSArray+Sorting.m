//
//  NSArray+Sorting.m
//  UsefulBits
//
//  Created by Kevin O'Neill on 12/05/2014.
//
//

#import "NSArray+Sorting.h"

@implementation NSArray (Sorting)

- (NSArray *)sortedAlphabetically;
{
  return [self sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

@end
