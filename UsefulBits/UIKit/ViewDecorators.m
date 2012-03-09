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

#import "ViewDecorators.h"

#import "UIImage+Size.h"
#import "UIView+Size.h"
#import "UIApplication+Orientation.h"

ViewDecorator TileImageNamedDecorator(NSString *name)
{
  UIImage *image = [UIImage imageNamed:name];

  NSCAssert1(image != nil, @"an image named %@ must be available", name);

  return TileImageDecorator(image);
}

ViewDecorator TileImageDecorator(UIImage *image)
{
  NSCAssert(image != nil, @"an image must be supplied");
  
  return [^ (UIView *view, CGRect dirtyRect, CGContextRef context) {
    CGContextDrawTiledImage(context, [image bounds], [image CGImage]);
  } copy];
}

ViewDecorator ImageForOrintationDecorator(UIImage *portrait, UIImage *landscape)
{
  NSCAssert(portrait != nil && landscape != nil, @"portrait and landscape images must be supplied");
  
  return [^ (UIView *view, CGRect dirtyRect, CGContextRef context) {
    UIImage *image = [[UIApplication sharedApplication] isStatusBarLandscape] ? landscape : portrait;

    CGContextTranslateCTM(context, 0., [image height]);
    CGContextScaleCTM(context, 1., -1.);
    CGContextDrawImage(context, [image bounds], [image CGImage]);
  } copy];
}

ViewDecorator ImageNamedForOrintationDecorator(NSString *name)
{
  NSString *base = [name stringByDeletingPathExtension];
  NSString *extension = [name pathExtension];
  UIImage *portrait = [UIImage imageNamed:[NSString stringWithFormat:@"%@-portrait.%@", base, extension]];
  UIImage *landscape = [UIImage imageNamed:[NSString stringWithFormat:@"%@-landscape.%@", base, extension]];
  
  NSCAssert(portrait != nil && landscape != nil, @"portrait and landscape images must be availble");
  
  return ImageForOrintationDecorator(portrait, landscape);
}

ViewDecorator BottomKeylineDecorator(UIColor *color)
{
  return [^ (UIView *view, CGRect dirtyRect, CGContextRef context) {
    CGContextSetShadowWithColor(context, CGSizeMake(0., 1.), 0., [[UIColor colorWithWhite:1. alpha:.72] CGColor]);
    CGContextSetAllowsAntialiasing(context, NO);
    CGContextSetLineWidth(context, 1.);
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    
    CGFloat bottom = [view height] - 1.5;
    
    CGContextMoveToPoint(context, 3., bottom);
    CGContextAddLineToPoint(context, [view width] -3., bottom);
    CGContextStrokePath(context);

  } copy];
}

ViewDecorator CombineDecorators(ViewDecorator first, ...)
{
  
  NSMutableArray *decorators = [NSMutableArray array];
  
  va_list arguments;
  va_start(arguments, first);
  for (ViewDecorator decorator = first; decorator != nil; decorator = va_arg(arguments, ViewDecorator))
  {
    [decorators addObject:decorator];
  }
  va_end(arguments);
  
  return CombineDecoratorsFromArray(decorators);
}

ViewDecorator CombineDecoratorsFromArray(NSArray *decorators)
{
  NSArray *local_decorators = [decorators copy];
  
  return [^ (UIView *view, CGRect dirtyRect, CGContextRef context) {
    for(ViewDecorator decorator in local_decorators)
    {
      CGContextSaveGState(context);
      decorator(view, dirtyRect, context);
      CGContextRestoreGState(context);
    }
  } copy];
}