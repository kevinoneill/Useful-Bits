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

+ (NSMutableDictionary *)passwordQueryForService:(NSString *)service account:(NSString *)account synchronize:(BOOL)synchronize;
{
  NSParameterAssert(nil != service);
  NSParameterAssert(nil != account);
  
  return [NSMutableDictionary dictionaryWithObjectsAndKeys:
          service, (id)kSecAttrService,
          account, (id)kSecAttrAccount,
          (id)kSecClassGenericPassword, (id)kSecClass,
          @(synchronize), (id)kSecAttrSynchronizable,
          nil];
}

+ (NSMutableDictionary *)passwordQueryForService:(NSString *)service account:(NSString *)account;
{
  return [self passwordQueryForService:service account:account synchronize:NO];
}

@end
