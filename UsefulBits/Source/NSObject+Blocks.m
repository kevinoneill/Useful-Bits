//
//  NSObject+Blocks.m
//  UsefulBits
//
//  Created by Kevin O'Neill on 17/05/11.
//  Copyright 2011 Kevin O'Neill. All rights reserved.
//

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

static const char blocks_key;

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

- (void)addObserverAction:(void (^)(NSString *keyPath, id object, NSDictionary *change))action forKeyPath:(NSString *)path options:(NSKeyValueObservingOptions)options;
{
  UBBlockObserver_ *observer = [UBBlockObserver_ instanceWithAction:action keyPath:path];
  
  [[self actionBlocks] addObject:observer];
  [self addObserver:observer forKeyPath:path options:options context:NULL];
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