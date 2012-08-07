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
  return [self zip:other padding:NO];
}

- (NSArray *)zip:(NSArray *)other padding:(BOOL)padding;
{
  return [self zip:other combinator:^id(id item1, id item2) {
    return [NSArray arrayWithObjects:item1, item2, nil];
  } padding:padding];
}

- (NSArray *)zip:(NSArray *)other combinator:(id (^)(id item1, id item2))combinator;
{
  return [self zip:other combinator:combinator padding:NO];
}

- (NSArray *)zip:(NSArray *)other combinator:(id (^)(id item1, id item2))combinator padding:(BOOL)padding;
{
  NSInteger size = [other count] > [self count] ? [other count] : [self count];
  
  NSArray *array1 = padding ? [self pad:size] : self;
  NSArray *array2 = padding ? [other pad:size] : other;
  
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:size];
  for (NSUInteger idx = 0; idx < size; idx++)
  {
    id result = combinator([array1 objectAtIndex:idx], [array2 objectAtIndex:idx]);
    [result addObject:result];
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
    }
    else
    {
      [result addObject:item];
    }
  }
  
  return [[result copy] autorelease];
}

@end
