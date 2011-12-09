  //  Copyright (c) 2011, Kevin O'Neill
  //  All rights reserved.
  //
  //  Redistribution and use in source and binary forms, with or without
  //  modification, are permitted provided that the following conditions are met:
  //
  //  * Redistributions of source code must retain the above copyright
  //   notice, this list of conditions and the following disclaimer.
  //
  //  * Redistributions in binary form must reproduce the above copyright
  //   notice, this list of conditions and the following disclaimer in the
  //   documentation and/or other materials provided with the distribution.
  //
  //  * Neither the name UsefulBits nor the names of its contributors may be used
  //   to endorse or promote products derived from this software without specific
  //   prior written permission.
  //
  //  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  //  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  //  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  //  DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
  //  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  //  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  //  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  //  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  //  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  //  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "UIColor+Hex.h"

#import "NSNumber+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHex:(NSInteger)color
{
  return [UIColor colorWithHex:color alpha:1.0];
}

+ (UIColor *)colorWithHex:(NSInteger)color alpha:(float)alpha
{
  return [UIColor colorWithRed:(((color & 0xFF0000) >> 16)) / 255.0f
                         green:(((color & 0xFF00) >> 8)) / 255.0f
                          blue:((color & 0xFF)) / 255.0 alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString;
{
  NSUInteger string_length = [hexString length];
  if (!([hexString hasPrefix:@"0x"] && (10 == string_length || 8 == string_length))) return nil;
  
  NSUInteger color = 0;
  NSUInteger alpha = 0;
  
  if ([hexString length] == 10)
  {
    color = [[NSNumber numberWithHexString:[hexString substringWithRange:NSMakeRange(4, 6)]] unsignedIntegerValue];
    alpha = [[NSNumber numberWithHexString:[hexString substringWithRange:NSMakeRange(2, 2)]] unsignedIntegerValue];
  }
  else
  {
    color = [[NSNumber numberWithHexString:[hexString substringWithRange:NSMakeRange(2, 6)]] unsignedIntegerValue];
  }
  
  return alpha > 0 ? [UIColor colorWithHex:color alpha:(alpha / 255.0f)] : [UIColor colorWithHex:color];
}


@end
