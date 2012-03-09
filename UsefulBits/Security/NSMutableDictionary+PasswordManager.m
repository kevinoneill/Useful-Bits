//
//  NSMutableDictionary+PasswordManager.m
//  UsefulBits
//
//  Created by Kevin O'Neill on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSMutableDictionary+PasswordManager.h"

#import <Security/Security.h>

@implementation NSMutableDictionary (PasswordManager)

+ (id)passwordQueryForService:(NSString *)service account:(NSString *)account;
{
  NSParameterAssert(nil != service);
  NSParameterAssert(nil != account);
  
  return [NSMutableDictionary dictionaryWithObjectsAndKeys:
          service, (__bridge id)kSecAttrService,
          account, (__bridge id)kSecAttrAccount,
          (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
          nil];
}

@end
