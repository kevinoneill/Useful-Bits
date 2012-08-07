//
//  NSArray+Zip.h
//  UsefulBits
//
//  Created by Kevin O'Neill on 4/09/11.
//  Copyright 2011 Kevin O'Neill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Zip)

- (NSArray *)zip:(NSArray *)other;
- (NSArray *)zip:(NSArray *)other padding:(BOOL)padding;
- (NSArray *)zip:(NSArray *)other combinator:(id (^)(id item1, id item2))combinator;
- (NSArray *)zip:(NSArray *)other combinator:(id (^)(id item1, id item2))combinator padding:(BOOL)padding;

- (NSArray *)flatten;

@end
