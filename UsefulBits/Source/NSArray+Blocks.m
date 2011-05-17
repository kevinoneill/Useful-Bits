//
//  NSArray+MapReduceSelect.m
//  city-guide-ii
//
//  Created by Kevin O'Neill on 11/05/10.
//  Copyright 2010. All rights reserved.
//

#import "NSArray+Blocks.h"

@implementation NSArray (Blocks)

- (void)each:(void (^)(id))block;
{
  [self enumerateObjectsUsingBlock: ^(id item, uint i, BOOL *stop) { block(item); }];
}

- (void)eachWithIndex:(void (^)(id, int))block;
{
  [self enumerateObjectsUsingBlock: ^(id item, uint i, BOOL *stop) { block(item, i); }];
}


- (NSArray *)filter:(BOOL (^)(id))block;
{
  NSMutableArray *result = [NSMutableArray array];

  for (id obj in self)
  {
    if (!block(obj))
    {
      [result addObject:obj];
    }
  }

  return result;
}

- (NSArray *)pick:(BOOL (^)(id))block;
{
  NSMutableArray *result = [NSMutableArray array];

  for (id obj in self)
  {
    if (block(obj))
    {
      [result addObject:obj];
    }
  }

  return result;
}

- (NSArray *)map:(id<NSObject> (^)(id<NSObject> item))block;
{
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];

  for (id obj in self)
  {
    [result addObject:block(obj)];
  }

  return [NSArray arrayWithArray:result];
}

- (id)reduce:(id (^)(id current, id item))block initial:(id)initial;
{
  id result = initial;

  for (id obj in self)
  {
    result = block(result, obj);
  }

  return result;
}

- (id)first:(BOOL (^)(id item))block;
{
	id result = nil;

  for (id obj in self)
  {
    if (block(obj))
    {
      result = obj;
      break;
    }
  }

  return result;
}

@end
