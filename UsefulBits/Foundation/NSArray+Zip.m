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
  return [self zip:other truncate:YES];
}

- (NSArray *)zip:(NSArray *)other truncate:(BOOL)truncate;
{
  return [self zip:other combinator:^id(id item1, id item2) {
    return [NSArray arrayWithObjects:item1, item2, nil];
  } truncate:truncate];
}

- (NSArray *)zip:(NSArray *)other combinator:(id (^)(id item1, id item2))combinator;
{
  return [self zip:other combinator:combinator truncate:YES];
}

- (NSArray *)zip:(NSArray *)other combinator:(id (^)(id item1, id item2))combinator truncate:(BOOL)truncate;
{
  NSInteger size = truncate ? MIN([other count], [self count]) : MAX([other count], [self count]);
  
  NSArray *array1 = [self pad:size];
  NSArray *array2 = [other pad:size];
  
  NSMutableArray *results = [NSMutableArray arrayWithCapacity:size];
  
  for (NSUInteger idx = 0; idx < size; idx++)
  {
    id result = combinator([array1 objectAtIndex:idx], [array2 objectAtIndex:idx]);
    [results addObject:result];
  }
  
  return [[results copy] autorelease];
}

- (NSArray *)flatten;
{
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
  
  for (id item in self)
  {
    if ([item isKindOfClass:[NSArray class]])
    {
      [result addObjectsFromArray:[item flatten]];
    }
    else
    {
      [result addObject:item];
    }
  }
  
  return [[result copy] autorelease];
}

@end
