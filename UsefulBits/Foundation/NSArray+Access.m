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

#import "NSArray+Access.h"

#import "NSArray+Blocks.h"

@implementation NSArray (Access)

- (id)first;
{
  return [self count] > 0 ? [self objectAtIndex:0] : nil;
}

- (id)last;
{
  return [self lastObject];
}
          
- (NSArray *)rest;
{
  return [self count] > 1 ? [self subarrayWithRange:NSMakeRange(1, [self count] - 1)] : [NSArray array];
}

- (NSArray *)trunk;
{
  return [self take:([self count] - 1)];
}

- (NSArray *)take:(NSUInteger)count;
{
	return [self subarrayWithRange:NSMakeRange(0, [self count] >= count ? count : [self count])];
}

- (BOOL)isEmpty;
{
  return [self count] == 0;
}

- (BOOL)isNotEmpty;
{
  return ![self isEmpty];
}

- (NSArray *)reverse;
{
  return [[self reverseObjectEnumerator] allObjects];
}

- (NSArray *)flatten;
{
  return [self filter:^BOOL(id item) {
    return item == [NSNull null];
  }];
}

@end
