//
//  NSDictionary+Types.m
//  UsefulBits
//
//  Created by Kevin O'Neill on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+Types.h"

@implementation NSDictionary (Types)

- (id)objectForKey:(id)key ofType:(Class)type default:(id)defaultValue;
{
  id value = [self objectForKey:key];
  
  return [value isKindOfClass:type] ? value : defaultValue;
}

- (NSString *)stringForKey:(id)key default:(NSString *)defaultValue;
{
  return [self objectForKey:key ofType:[NSString class] default:defaultValue];
}

- (NSString *)stringForKey:(id)key;
{
  return [self stringForKey:key default:@""];
}

- (NSNumber *)numberForKey:(id)key default:(NSNumber *)defaultValue;
{
  return [self objectForKey:key ofType:[NSNumber class] default:defaultValue];
}

- (NSNumber *)numberForKey:(id)key;
{
  return [self numberForKey:key default:nil];
}

@end
