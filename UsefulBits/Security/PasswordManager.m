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

@interface PasswordManager ()

@property (nonatomic, assign) BOOL synchronized;

@end

@implementation PasswordManager

static NSString *kServiceName = @"ub-password-manager";

+ (PasswordManager *)synchronized;
{
  static dispatch_once_t shared_initialized;
  static PasswordManager *shared_instance = nil;

  dispatch_once(&shared_initialized, ^ {
    shared_instance = [[PasswordManager alloc] initWithSynchronization:YES];
  });

  return shared_instance;
}

+ (PasswordManager *)local;
{
  static dispatch_once_t shared_initialized;
  static PasswordManager *shared_instance = nil;

  dispatch_once(&shared_initialized, ^ {
    shared_instance = [[PasswordManager alloc] initWithSynchronization:NO];
  });

  return shared_instance;
}

- (instancetype)init;
{
  return [self initWithSynchronization:NO];
}

- (instancetype)initWithSynchronization:(BOOL)synchronized;
{
  if ((self = [super init]))
  {
    _synchronized = synchronized;
  }

  return self;
}

- (NSMutableDictionary *)queryAccount:(NSString *)account {
  return [NSMutableDictionary passwordQueryForService:kServiceName account:account synchronize:_synchronized];
}

- (BOOL)storePassword:(NSString *)password forAccount:(NSString *)account;
{
  return [self storeToken:[password dataUsingEncoding:NSUTF8StringEncoding] forAccount:account];
}

- (BOOL)storeToken:(NSData *)token forAccount:(NSString *)account
{
  NSParameterAssert([account length] > 0);
  NSParameterAssert(nil != token);

  NSMutableDictionary *query = [self queryAccount:account];

  switch (SecItemCopyMatching((CFDictionaryRef)query, NULL))
  {
    case errSecItemNotFound:
    {
      [query setObject:token
                forKey:kSecValueData];

      return SecItemAdd((CFDictionaryRef)query, NULL) == errSecSuccess;
    }
    case errSecSuccess:
    {
      NSDictionary *update = [NSDictionary dictionaryWithObject:token
                                                         forKey:(id)kSecValueData];

      return SecItemUpdate((CFDictionaryRef)query, (CFDictionaryRef)update) == errSecSuccess;
    }
    default:
      break;
  }

  return NO;
}

- (NSString *)passwordForAccount:(NSString *)account;
{
  NSData *token = [self tokenForAccount:account];
  return token != nil ? [[[NSString alloc] initWithData:token encoding:NSUTF8StringEncoding] autorelease] : nil;
}

- (NSData *)tokenForAccount:(NSString *)account;
{
  NSParameterAssert([account length] > 0);

  NSMutableDictionary *query = [self queryAccount:account];
  [query setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];

  NSData *data = nil;
  OSStatus result = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&data);

  if (result == errSecSuccess)
  {
    return [data autorelease];
  }

  return nil;
}

- (BOOL)removeTokenForAccount:(NSString *)account;
{
  NSParameterAssert([account length] > 0);

  NSMutableDictionary *query = [self queryAccount:account];

  return SecItemDelete((CFDictionaryRef)query) == errSecSuccess;
}

- (BOOL)removePasswordForAccount:(NSString *)account;
{
  return [self removeTokenForAccount:account];
}

@end
