//
//  PasswordManager.h
//  UsefulBits
//
//  Created by Kevin O'Neill on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PasswordManager : NSObject

+ (PasswordManager *)synchronized;
+ (PasswordManager *)local;


- (BOOL)storeToken:(NSData *)token forAccount:(NSString *)account;
- (BOOL)storePassword:(NSString *)password forAccount:(NSString *)account;

- (NSData *)tokenForAccount:(NSString *)account;
- (NSString *)passwordForAccount:(NSString *)account;

- (BOOL)removeTokenForAccount:(NSString *)account;
- (BOOL)removePasswordForAccount:(NSString *)account;

@end
