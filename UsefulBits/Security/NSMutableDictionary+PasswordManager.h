//
//  NSMutableDictionary+PasswordManager.h
//  UsefulBits
//
//  Created by Kevin O'Neill on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (PasswordManager)

+ (NSMutableDictionary *)passwordQueryForService:(NSString *)service account:(NSString *)account;
+ (NSMutableDictionary *)passwordQueryForService:(NSString *)service account:(NSString *)account synchronize:(BOOL)synchronize;

@end
