//
//  PasswordManager.m
//  UsefulBits
//
//  Created by Kevin O'Neill on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PasswordManager.h"

#import <Security/Security.h>

#import "NSMutableDictionary+PasswordManager.h"

@implementation PasswordManager

static NSString *kServiceName = @"ub-password-manager";

+ (BOOL)storePassword:(NSString *)password forAccount:(NSString *)account;
{
  NSParameterAssert(nil != account);
  NSParameterAssert(nil != password);
  
	NSMutableDictionary *query = [NSMutableDictionary passwordQueryForService:kServiceName account:account];
  
  switch (SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL))
  {
    case errSecItemNotFound:
    {
      [query setObject:[password dataUsingEncoding:NSUTF8StringEncoding]
                forKey:(__bridge id)(kSecValueData)];
      
			return SecItemAdd((__bridge CFDictionaryRef)query, NULL) == errSecSuccess;
      break;
    } 
    case errSecSuccess:
    {
      NSDictionary *update = [NSDictionary dictionaryWithObject:[password dataUsingEncoding:NSUTF8StringEncoding] 
                                                         forKey:(__bridge id)kSecValueData];
      
      return SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)update) == errSecSuccess;
      break;
    }
    default:
      break;
  }
  
  return NO;
}

+ (NSString *)passwordForAccount:(NSString *)account;
{
	NSMutableDictionary *query = [NSMutableDictionary passwordQueryForService:kServiceName account:account];
	[query setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];

	CFTypeRef result = NULL;
  OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
	NSData *data = (__bridge_transfer NSData *)result;
  
	if (status == errSecSuccess)
  {
		NSString *password = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
		return password;
  }
	
  return nil;
}

+ (BOOL)removePasswordForAccount:(NSString *)account;
{
  NSMutableDictionary *query = [NSMutableDictionary passwordQueryForService:kServiceName account:account];

  return SecItemDelete((__bridge CFDictionaryRef)query) == errSecSuccess;
}

@end
