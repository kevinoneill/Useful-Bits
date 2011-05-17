  //
  //  LayoutView.m
  //  Quickie
  //
  //  Created by Kevin O'Neill on 28/04/11.
  //  Copyright 2011 Kevin O'Neill. All rights reserved.
  //

#import "LayoutView.h"


@implementation LayoutView

- (id)initWithFrame:(CGRect)frame layoutManager:(id<LayoutManager>)layoutManager;
{
  if ((self = [super initWithFrame:frame]))
  {
    [self setLayoutManager:layoutManager];
  }
  
  return self;
}

- (id)initWithFrame:(CGRect)frame;
{
  return [self initWithFrame:frame layoutManager:nil];
}

- (void)dealloc
{
  [layoutManager_ release];
  
  [super dealloc];
}


@synthesize layoutManager = layoutManager_;

- (BOOL)hasLayoutManager;
{
  return layoutManager_ != nil;
}

#pragma mark -
#pragma UIView

- (CGSize) sizeThatFits:(CGSize)size;
{
  return ([self hasLayoutManager])
    ? [layoutManager_ sizeThatFits:size]
    : [super sizeThatFits:size];
}

- (void)layoutSubviews;
{
  if ([self hasLayoutManager])
  {
    [layoutManager_ layoutSubviews:self];
  }
  else
  {
    [super layoutSubviews];
  }
}

@end
