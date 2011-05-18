//
//  NSObject+Blocks.h
//  UsefulBits
//
//  Created by Kevin O'Neill on 17/05/11.
//  Copyright 2011 Kevin O'Neill. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (Blocks)

- (void)addObserverAction:(void (^)(NSString *keyPath, id object, NSDictionary *change))action forKeyPath:(NSString *)path options:(NSKeyValueObservingOptions)options;
- (void)removeObserverActionsForKeyPath:(NSString *)path;

@end
