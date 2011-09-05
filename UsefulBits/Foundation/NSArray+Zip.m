//
//  NSArray+Zip.m
//  UsefulBits
//
//  Created by Kevin O'Neill on 4/09/11.
//  Copyright 2011 Kevin O'Neill. All rights reserved.
//

#import "NSArray+Zip.h"

#import "NSArray+Blocks.h"
#import "NSArray+Access.h"

@implementation NSArray (Zip)

- (NSArray *)zip:(NSArray *)other;
{
  NSInteger size = [other count] > [self count] ? [other count] : [self count];
  
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:size];
  for (NSUInteger idx = 0; idx < size; idx++)
  {
    [result addObject:[NSArray arrayWithObjects:[self objectAtIndex:idx], [other objectAtIndex:idx], nil]];
  }
  
  return [[result copy] autorelease];
}

- (NSArray *)flatten;
{
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
  
  for (id item in self)
  {
    if ([item isKindOfClass:[NSArray class]])
    {
      [result addObjectsFromArray:[item flatten]];
      break;
    }
    
    [result addObject:item];
  }
  
  return [[result copy] autorelease];
}

@end
