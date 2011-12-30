//
//  PasswordManager.h
//  UsefulBits
//
//  Created by Kevin O'Neill on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PasswordManager : NSObject

+ (BOOL)storePassword:(NSString *)password forAccount:(NSString *)account;
+ (NSString *)passwordForAccount:(NSString *)account;
+ (BOOL)removePasswordForAccount:(NSString *)account;

@end
