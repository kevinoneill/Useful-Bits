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
