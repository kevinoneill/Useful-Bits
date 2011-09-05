//  Copyright (c) 2011, Kevin O'Neill
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
//
//  * Neither the name UsefulBits nor the names of its contributors may be used
//   to endorse or promote products derived from this software without specific
//   prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "NSArray+Blocks.h"

#import "NSArray+Access.h"

@implementation NSArray (Blocks)

#pragma mark - Enumeration

- (void)each:(void (^)(id))block;
{
  [self enumerateObjectsUsingBlock: ^(id item, NSUInteger i, BOOL *stop) { block(item); }];
}

- (void)eachWithIndex:(void (^)(id, NSUInteger))block;
{
  [self enumerateObjectsUsingBlock: ^(id item, NSUInteger i, BOOL *stop) { block(item, i); }];
}

#pragma mark - Filters

- (NSArray *)filter:(BOOL (^)(id))block;
{
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
  
  for (id obj in self)
  {
    if (!block(obj))
    {
      [result addObject:obj];
    }
  }
  
  return [[result copy] autorelease];
}

- (NSArray *)pick:(BOOL (^)(id))block;
{
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
  
  for (id obj in self)
  {
    if (block(obj))
    {
      [result addObject:obj];
    }
  }
  
  return [[result copy] autorelease];
}

- (id)first:(BOOL (^)(id))block;
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

- (NSUInteger)indexOfFirst:(BOOL (^)(id item))block;
{
  return [self indexOfObjectPassingTest:^ BOOL (id item, NSUInteger idx, BOOL *stop) {
		if (block(item))
    {
      *stop = YES;
      return YES;
    }
    
    return NO;
  }];
}

- (id)last:(BOOL (^)(id))block;
{
	id result = nil;
  
  for (id obj in [self reverseObjectEnumerator])
  {
    if (block(obj))
    {
      result = obj;
      break;
    }
  }
  
  return result;
}

- (NSUInteger)indexOfLast:(BOOL (^)(id item))block;
{
  return [self indexOfObjectWithOptions:NSEnumerationReverse passingTest:^ BOOL (id item, NSUInteger idx, BOOL *stop) {
		if (block(item))
    {
      *stop = YES;
      return YES;
    }
    
    return NO;
  }];
}

#pragma mark - Transformations

- (NSArray *)map:(id (^)(id item))block;
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

- (NSArray *)intersperse:(id (^) (id current, id next))separator;
{
  if ([self count] < 2) return [[self copy] autorelease];
  
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:(([self count] * 2) - 1)];

  id current = [self first];
  for (NSUInteger idx = 1; idx < [self count]; idx++) {
    [result addObject:current];

    id next = [self objectAtIndex:idx];
    [result addObject:separator(current, next)];
    current = next;
  }
  [result addObject:[self last]];
  
  return [[result copy] autorelease];
}

- (BOOL)any:(BOOL (^)(id))block;
{
  return NSNotFound != [self indexOfFirst:block];
}

- (BOOL)all:(BOOL (^)(id))block;
{
  return NSNotFound == [self indexOfFirst:^ BOOL (id item) { return !block(item); }];
}

@end
