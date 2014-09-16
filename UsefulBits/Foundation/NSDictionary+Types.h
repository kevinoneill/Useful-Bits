//
//  NSDictionary+Types.h
//  UsefulBits
//
//  Created by Kevin O'Neill on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Types)

- (NSString *)stringForKey:(id)key;

- (id)objectForKey:(id)key default:(id)defaultValue;

- (NSString *)stringForKey:(id)key default:(NSString *)defaultValue;

- (NSNumber *)numberForKey:(id)key default:(NSNumber *)defaultValue;
- (NSNumber *)numberForKey:(id)key;

- (NSArray *)arrayForKey:(id)key default:(NSArray *)defaultValue;
- (NSArray *)arrayForKey:(id)key;

- (NSDictionary *)dictionaryForKey:(id)key default:(NSDictionary *)defaultValue;
- (NSDictionary *)dictionaryForKey:(id)key;

@end
