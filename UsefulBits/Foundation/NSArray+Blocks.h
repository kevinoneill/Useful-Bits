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

#import <Foundation/Foundation.h>

@interface NSArray (Blocks)

- (void)each:(void (^)(id item))block;
- (void)eachWithIndex:(void (^)(id item, NSUInteger index))block;
- (void)eachMatching:(BOOL (^)(id item))predicate do:(void (^)(id item))action;

- (NSArray *)filter:(BOOL (^)(id item))block;
- (NSArray *)pick:(BOOL (^)(id item))block;

- (id)first:(BOOL (^)(id item))block;
- (NSUInteger)indexOfFirst:(BOOL (^)(id item))block;

- (id)last:(BOOL (^)(id item))block;
- (NSUInteger)indexOfLast:(BOOL (^)(id item))block;

- (NSArray *)map:(id (^)(id item))block;
- (NSArray *)map:(id (^)(id item))block filterNil:(BOOL)filter_nil;
- (id)reduce:(id (^)(id current, id item))block initial:(id)initial;
- (NSArray *)intersperse:(id (^) (id current, id next))separator;

- (BOOL)any:(BOOL (^)(id))block;
- (BOOL)all:(BOOL (^)(id))block;

@end
