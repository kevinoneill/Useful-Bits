//
//  UILabel+Skin.m
//  UsefulBits
//
//  Created by Kevin O'Neill on 27/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+Skin.h"

@implementation UILabel (Skin)

- (void)styleWithSkin:(Skin *)skin;
{
  [super styleWithSkin:skin];
  
  [skin withFontNamed:@"label-font" do:^(UIFont *font) {
    [self setFont:font];
  }];
  
  [skin withColorNamed:@"label-text" do:^(UIColor *color) {
    [self setTextColor:color];
  }];
}

@end
