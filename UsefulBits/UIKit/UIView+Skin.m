//
//  UIView+Skin.m
//  UsefulBits
//
//  Created by Kevin O'Neill on 27/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+Skin.h"

@implementation UIView (Skin)

- (id)initWithFrame:(CGRect)frame skin:(Skin *)skin;
{
  if ((self = [self initWithFrame:frame]))
  {
    [self styleWithSkin:skin];
  }
  
  return self;
}

- (void)styleWithSkin:(Skin *)skin;
{
  [skin withColorNamed:@"background" do:^(UIColor *color) {
    [self setBackgroundColor:color];
  }];
  
  for (UIView *view in [self subviews])
  {
    [view styleWithSkin:skin];
  }
}

@end
