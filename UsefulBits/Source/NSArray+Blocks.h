//
//  NSArray+MapReduceSelect.h
//  city-guide-ii
//
//  Created by Kevin O'Neill on 11/05/10.
//  Copyright 2010. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Blocks)

- (void)each:(void (^)(id item))block;
- (void)eachWithIndex:(void (^)(id item, int index))block;
- (NSArray *)filter:(BOOL (^)(id item))block;
- (NSArray *)pick:(BOOL (^)(id item))block;
- (NSArray *)map:(id<NSObject> (^)(id<NSObject> item))block;
- (id)reduce:(id (^)(id current, id item))block initial:(id)initial;
- (id)first:(BOOL (^)(id item))block;

@end
