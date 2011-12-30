//
//  NSMutableDictionary+PasswordManager.h
//  UsefulBits
//
//  Created by Kevin O'Neill on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (PasswordManager)

+ (id)passwordQueryForService:(NSString *)service account:(NSString *)account;

@end
