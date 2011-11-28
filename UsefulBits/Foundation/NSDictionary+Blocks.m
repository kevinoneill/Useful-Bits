//
//  NSDictionary+Blocks.m
//  UsefulBits
//
//  Created by Kevin O'Neill on 25/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+Blocks.h"

@implementation NSDictionary (Blocks)

- (void)each:(void (^) (id key, id value))action;
{
  [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    action(key, obj);
  }];
}

- (NSArray *)map:(id (^) (id key, id value))action;
{
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
  
  [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    [result addObject:action(key, obj)];
  }];
  
  return [[result copy] autorelease];
}

- (void)withValueForKey:(id)key do:(void (^) (id value))action;
{
  id value = [self objectForKey:key];
  
  if (nil != value)
  {
    action(value);
  }
}

@end
