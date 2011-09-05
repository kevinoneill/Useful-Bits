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
- (NSArray *)flatten;

@end
