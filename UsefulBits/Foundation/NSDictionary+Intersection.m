//
//  NSDictionary+Intersection.m
//  UsefulBits
//
//  Created by Kevin O'Neill on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+Intersection.h"

@implementation NSDictionary (Intersection)

- (NSDictionary *)merge:(NSDictionary *)other;
{
  NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:self];
  [result addEntriesFromDictionary:other];
  
  return [[result copy] autorelease];
}

@end
