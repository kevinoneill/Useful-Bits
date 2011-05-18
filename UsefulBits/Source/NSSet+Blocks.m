//
//  NSSet+Blocks.m
//  UsefulBits
//
//  Created by Kevin O'Neill on 18/05/11.
//  Copyright 2011 Kevin O'Neill. All rights reserved.
//

#import "NSSet+Blocks.h"

@implementation NSSet (Blocks)

- (void)each:(void (^)(id item))block;
{
  [self enumerateObjectsUsingBlock: ^(id item, BOOL *stop) { block(item); }];
}

- (NSSet *)filter:(BOOL (^)(id item))block;
{
  NSMutableSet *result = [NSMutableSet setWithCapacity:[self count]];
  
  for (id obj in self)
  {
    if (!block(obj))
    {
      [result addObject:obj];
    }
  }
  
  return [NSSet setWithSet:result];
}

- (NSSet *)pick:(BOOL (^)(id item))block;
{
  return [self objectsPassingTest:^ BOOL (id item, BOOL *stop) { return block(item); }];
}

- (NSArray *)map:(id<NSObject> (^)(id<NSObject> item))block;
{
  NSMutableSet *result = [NSMutableSet setWithCapacity:[self count]];
  
  for (id obj in self)
  {
    [result addObject:block(obj)];
  }
  
  return [NSSet setWithSet:result];
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

- (BOOL)any:(BOOL (^)(id))block;
{
  return [[self objectsPassingTest:^ BOOL (id item, BOOL *stop) {
		if (block(item))
    {
      *stop = YES;
      return YES;
    }
    
    return NO;
  }] count] > 0;
}

- (BOOL)all:(BOOL (^)(id))block;
{
  return [[self objectsPassingTest:^ BOOL (id item, BOOL *stop) {
		if (block(item))
    {
      return YES;
    }
    
    *stop = YES;
    return NO;
  }] count] == [self count];
}

@end
