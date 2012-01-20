//
//  NSDictionary+Blocks.h
//  UsefulBits
//
//  Created by Kevin O'Neill on 25/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Blocks)

- (void)each:(void (^) (id key, id value))action;
              
- (void)withValueForKey:(id)key meetingCondition:(BOOL (^) (id value))condition do:(void (^) (id value))action;
- (void)withValueForKey:(id)key ofClass:(Class)class do:(void (^) (id value))action;
- (void)withValueForKey:(id)key do:(void (^) (id value))action;

@end
