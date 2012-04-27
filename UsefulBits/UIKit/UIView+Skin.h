//
//  UIView+Skin.h
//  UsefulBits
//
//  Created by Kevin O'Neill on 27/04/12.
//

#import <UIKit/UIKit.h>

#import "UsefulBits/Skin.h"

@interface UIView (Skin)

- (id)initWithFrame:(CGRect)frame skin:(Skin *)skin;
- (void)styleWithSkin:(Skin *)skin;

@end
