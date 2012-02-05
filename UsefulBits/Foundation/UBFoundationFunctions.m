//
//  UBFoundationFunctions.m
//  UsefulBits
//
//  Created by Kevin O'Neill on 5/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UBFoundationFunctions.h"

#import <UIKit/UIKit.h>

NSArray *indexPathsForRange(NSRange range)
{
  NSMutableArray *index_paths = [NSMutableArray arrayWithCapacity:range.length];
  for (NSUInteger index = 0; index < range.length; index++)
  {
    [index_paths addObject:[NSIndexPath indexPathForRow:index + range.location inSection:0]];
  }
  
  return index_paths;
}