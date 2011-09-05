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

#import "ColumnLayout.h"

#import "NSArray+Blocks.h"
#import "UIView+Size.h"

@implementation ColumnLayout

@synthesize columns = columns_;
@synthesize gutter = gutter_;
@synthesize padding = padding_;

+ (id)instance;
{
  return [[[[self class] alloc] init] autorelease];
}

- (NSUInteger)columns;
{
  return columns_ < 2 ? 1 : columns_;
}

- (void)layout:(UIView *)view action:(void (^) (UIView *subview, CGRect subviewFrame))action;
{
  if ([[view subviews] count] == 0) return;
  
  NSUInteger column_count = [self columns];
  CGFloat gutter = [self gutter];
  CGFloat column_width = MAX(ceilf(([view width] - (gutter * (column_count - 1))) / column_count), 0.);
  
  __block CGFloat subview_height = 0.;
  __block CGFloat row_height = 0.;

  [[view subviews] eachWithIndex:^(id subview, NSUInteger idx) {
    NSUInteger column = (idx % column_count);
    if (column == 0)
    {
      subview_height = row_height;
      row_height = 0.;
    }
    
    CGSize subview_size = [subview sizeThatFits:CGSizeMake(column_width, 0.)];
    CGRect subview_frame = CGRectMake((column_width * column) + (gutter * column),
                                      subview_height,
                                      column_width,
                                      subview_size.height);
    action(subview, subview_frame);
    
    CGFloat bottom = ceilf(CGRectGetMaxY(subview_frame) + [self padding]);
    row_height = MAX(row_height, bottom);
  }];      
}

- (CGSize)sizeThatFits:(CGSize)size view:(UIView *)view;
{
  __block CGRect bounds = CGRectZero;
  [self layout:view action:^(UIView *subview, CGRect subviewFrame) {
    bounds = CGRectUnion(bounds, subviewFrame);
  }]; 
  
  return CGRectIntegral(bounds).size; 
}

- (void)layoutSubviews:(UIView *)view
{
  [self layout:view action:^(UIView *subview, CGRect subviewFrame) {
    [subview setFrame:subviewFrame];
  }]; 
}

@end
