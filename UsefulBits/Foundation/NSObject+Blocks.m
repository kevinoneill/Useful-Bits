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

#import "NSObject+Blocks.h"

#import <objc/runtime.h>
#import "NSArray+Blocks.h"

@interface UBBlockObserver_ : NSObject
{
  NSString *keyPath_;
  void (^action_)(NSString *keyPath, id object, NSDictionary *change);
}

+ (UBBlockObserver_ *)instanceWithAction:(void (^) (NSString *keyPath, id object, NSDictionary *change))action keyPath:(NSString *)keyPath;

@property (nonatomic, copy) void (^action)(NSString *keyPath, id object, NSDictionary *change);
@property (nonatomic, copy) NSString *keyPath;

@end

@interface NSObject (Blocks_Internal)

@property (nonatomic, copy) NSMutableArray *actionBlocks;

@end


@implementation NSObject (Blocks)

static char blocks_key;

- (NSMutableArray *)actionBlocks;
{
  NSMutableArray *blocks = objc_getAssociatedObject(self, &blocks_key);
  if (nil == blocks)
  {
    blocks = [NSMutableArray array];
    [self setActionBlocks:blocks];
  }
  
  return blocks;
}

- (void)setActionBlocks:(NSMutableArray *)blocks;
{
  objc_setAssociatedObject(self, &blocks_key, blocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)addObserverAction:(void (^)(NSString *keyPath, id object, NSDictionary *change))action forKeyPath:(NSString *)path options:(NSKeyValueObservingOptions)options;
{
  __block UBBlockObserver_ *observer = [UBBlockObserver_ instanceWithAction:action keyPath:path];
  
  [[self actionBlocks] addObject:observer];
  [self addObserver:observer forKeyPath:path options:options context:NULL];
  
  return [[^ {
    [self removeObserver:observer forKeyPath:path];
    [[self actionBlocks] removeObject:observer];
  } copy] autorelease];
}

- (void)removeObserverAction:(id)token;
{
  ((void (^) (void))token)();
}

- (void)removeObserverActionsForKeyPath:(NSString *)path;
{
  NSArray *blocks_to_be_removed = [[self actionBlocks] pick:^BOOL(id item) {
    return [[item keyPath] isEqualToString:path];
  }];

  [blocks_to_be_removed each:^(id item) {
    [self removeObserver:item forKeyPath:path];
  }];
  
  [[self actionBlocks] removeObjectsInArray:blocks_to_be_removed];
}

@end

@implementation UBBlockObserver_

+ (UBBlockObserver_ *)instanceWithAction:(void (^) (NSString *keyPath, id object, NSDictionary *change))action keyPath:(NSString *)keyPath;
{
  UBBlockObserver_ *instance = [[self alloc] init];
  
  [instance setAction:action];
  [instance setKeyPath:keyPath];
  
  return [instance autorelease];
}

- (void)dealloc
{
  [action_ release];
  [keyPath_ release];
  
  [super dealloc];
}

@synthesize keyPath = keyPath_;
@synthesize action = action_;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if ([keyPath isEqualToString:[self keyPath]])
  {
    action_(keyPath, object, change);
  }
  else
  {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}


@end