//
//  HorizontalFillLayoutManager.m
//  Quickie
//
//  Created by Kevin O'Neill on 24/04/11.
//
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

#import "HorizontalFillLayoutManager.h"
#import "NSArray+Blocks.h"
#import "UIView+Positioning.h"
#import "UIView+Size.h"


  // Size isn't perfect (remainder is padded to the right hand edge)

@implementation HorizontalFillLayoutManager

@synthesize resizeSubviews = resizeSubviews_;

- (CGSize)sizeThatFits:(CGSize)size;
{
  return size;
}

- (void)layoutSubviews:(UIView *)view;
{
  CGFloat subview_height = CGRectGetHeight([view bounds]);
  CGFloat subview_width = floorf(CGRectGetWidth([view bounds]) / [[view subviews] count]);

  CGSize requested_subview_size = CGSizeMake(subview_width, subview_height);
  
  [[view subviews] eachWithIndex:^ (id subview, int position) {
    if (resizeSubviews_)
    {
      CGSize subview_size = [subview sizeThatFits:requested_subview_size];
      [subview setFrame:CGRectMake(0, 0, subview_size.width, subview_size.height)];
    }
    
    CGRect cell_frame = CGRectMake(subview_width * position, 0, requested_subview_size.width, requested_subview_size.height);
    [subview centerInRect:cell_frame];
  }];
}

@end
