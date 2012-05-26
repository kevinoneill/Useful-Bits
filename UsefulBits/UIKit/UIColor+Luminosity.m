  //  Copyright (c) 2012, Kevin O'Neill
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

#import "UIColor+Luminosity.h"

  // See http://en.wikipedia.org/wiki/Luminance_(relative)

@implementation UIColor (Luminosity)

- (CGFloat)whiteLuminosity;
{
  CGFloat white = 0;
  CGFloat alpha = 0;
  
  [self getWhite:&white alpha:&alpha];
  
  return white;
}

- (CGFloat)rgbLuminosity
{
  /*
     Luminance (standard, objective): (0.2126*R) + (0.7152*G) + (0.0722*B)
     Luminance (perceived option 1): (0.299*R + 0.587*G + 0.114*B)
     Luminance (perceived option 2): sqrt( 0.241*R^2 + 0.691*G^2 + 0.068*B^2 )
   */

  CGFloat red = 0;
  CGFloat green = 0;
  CGFloat blue = 0;
  CGFloat alpha = 0;
  
  [self getRed:&red green:&green blue:&blue alpha:&alpha];
  
  return sqrtf(0.241f * powf(red, 2.f) + 
               0.691f * powf(green, 2.f) + 
               0.068f * powf(blue, 2.f));

    //  return (0.299 * red + 0.587 * green + 0.114 * blue);
}

- (CGFloat)luminosity
{
  CGColorSpaceModel color_model = CGColorSpaceGetModel(CGColorGetColorSpace([self CGColor]));
  
  switch (color_model)
  {
    case kCGColorSpaceModelMonochrome:
      return [self whiteLuminosity];
      break;
      
    case kCGColorSpaceModelRGB:
      return [self rgbLuminosity];
      break;

    default:
      break;
  }
  
  return 0.f;
}

- (CGFloat)luminosityDifference:(UIColor*)other;
{
  CGFloat my_luminosity = [self luminosity];
  CGFloat other_luminosity = [other luminosity];
  
  return fabsf(my_luminosity - other_luminosity);
}

- (UIColor *)contrastWithLight:(UIColor *)light dark:(UIColor *)dark;
{
  float light_diff = [self luminosityDifference:light];
  float dark_diff = [self luminosityDifference:dark];
  
  return (light_diff > dark_diff) ? light : dark;
}

- (UIColor *)contrastWithBlackAndWhite;
{
  return [self contrastWithLight:[UIColor whiteColor] dark:[UIColor blackColor]];
}

@end
