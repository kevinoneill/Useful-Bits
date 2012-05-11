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

- (void)withValueForKey:(id)key meetingCondition:(BOOL (^) (id))condition do:(void (^) (id))action;
{
  [self withValueForKey:key meetingCondition:condition do:action default:NULL];
}

- (void)withValueForKey:(id)key meetingCondition:(BOOL (^) (id value))condition do:(void (^) (id value))action default:(void (^) (void))default_action;
{
  id value = [self objectForKey:key];

  if (condition(value))
  {
    action(value);
  }
  else if (NULL != default_action)
  {
    default_action();
  }
}

- (void)withValueForKey:(id)key ofClass:(Class)class do:(void (^) (id value))action;
{
  [self withValueForKey:key ofClass:class do:action default:NULL];
}

- (void)withValueForKey:(id)key ofClass:(Class)class do:(void (^) (id value))action default:(void (^) (void))default_action;
{
  [self withValueForKey:key
       meetingCondition:^BOOL(id value) {
         return [value isKindOfClass:class];
       } do:^(id value) {
    action(value);
  } default:default_action];
}

- (void)withValueForKey:(id)key do:(void (^) (id value))action;
{
  [self withValueForKey:key do:action default:NULL];
}

- (void)withValueForKey:(id)key do:(void (^) (id value))action default:(void (^) (void))default_action;
{
  [self withValueForKey:key
       meetingCondition:^BOOL(id value) {
         return nil != value && [NSNull null] != value;
       } do:^(id value) {
         action(value);
       } default:default_action];
}

- (NSDictionary *)pick:(BOOL (^)(id, id))filter;
{
  NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:[self count]];

  [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    if (filter(key, obj))
    {
      [result setObject:obj forKey:key];
    }
  }];

  return [[result copy] autorelease];
}

- (NSDictionary *)filter:(BOOL (^)(id, id))filter;
{
  return [self pick:^BOOL(id key, id value) {
    return !filter(key, value);
  }];
}


@end
