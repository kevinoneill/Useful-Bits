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
  
  switch (SecItemCopyMatching((CFDictionaryRef)query, NULL))
  {
    case errSecItemNotFound:
    {
      [query setObject:[password dataUsingEncoding:NSUTF8StringEncoding]
                forKey:kSecValueData];
      
			return SecItemAdd((CFDictionaryRef)query, NULL) == errSecSuccess;
      break;
    } 
    case errSecSuccess:
    {
      NSDictionary *update = [NSDictionary dictionaryWithObject:[password dataUsingEncoding:NSUTF8StringEncoding] 
                                                         forKey:(id)kSecValueData];
      
      return SecItemUpdate((CFDictionaryRef)query, (CFDictionaryRef)update) == errSecSuccess;
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
	[query setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
	
	NSData *data = nil;
	OSStatus result = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&data);
  
	if (result == errSecSuccess)
  {
		NSString *password = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [data release];
    
		return [password autorelease];
  }
	
  return nil;
}

+ (BOOL)removePasswordForAccount:(NSString *)account;
{
  NSMutableDictionary *query = [NSMutableDictionary passwordQueryForService:kServiceName account:account];

  return SecItemDelete((CFDictionaryRef)query) == errSecSuccess;
}

@end
