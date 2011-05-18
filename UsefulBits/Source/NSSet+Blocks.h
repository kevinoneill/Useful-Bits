//
//  NSSet+Blocks.h
//  UsefulBits
//
//  Created by Kevin O'Neill on 18/05/11.
//  Copyright 2011 Kevin O'Neill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (Blocks)

- (void)each:(void (^)(id item))block;

- (NSSet *)filter:(BOOL (^)(id item))block;
- (NSSet *)pick:(BOOL (^)(id item))block;

- (NSSet *)map:(id<NSObject> (^)(id<NSObject> item))block;
- (id)reduce:(id (^)(id current, id item))block initial:(id)initial;

- (BOOL)any:(BOOL (^)(id))block;
- (BOOL)all:(BOOL (^)(id))block;

@end
