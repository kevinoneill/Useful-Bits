//
//  NSNumber+Hex.m
//  UsefulBits
//
//  Created by Kevin O'Neill on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSNumber+Hex.h"

@implementation NSNumber (Hex)

+ (NSNumber *)integerWithHexString:(NSString *)hexString;
{
  NSScanner *scanner = [NSScanner scannerWithString:hexString];
  
  unsigned int value;

  if ([scanner scanHexInt:&value])
  {
    return [NSNumber numberWithUnsignedInt:value]; 
  }
  
  return nil;
}

@end
