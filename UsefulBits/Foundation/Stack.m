//
//  Stack.m
//  UsefulBits
//
//  Created by Kevin O'Neill on 31/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Stack.h"

#import "NSArray+Access.h"

@interface Stack ()
{
  NSMutableArray *stack_;
}

@end

@implementation Stack

- (id)init;
{
  if ((self = [super init]))
  {
    stack_ = [[NSMutableArray alloc] init];
  }
  
  return self;
}

- (void)dealloc
{
  [stack_ release];
  
  [super dealloc];
}

- (void)push:(id)object;
{
  [stack_ addObject:object];
}

- (id)pop;
{
  if ([self isEmpty])
  {
    @throw [NSException exceptionWithName:NSRangeException reason:@"Stack is empty" userInfo:nil];
  }
  
  NSUInteger index = [stack_ count] - 1;
  
  id result = [stack_ objectAtIndex:index];
  [stack_ removeObjectAtIndex:index];
  
  return result;
}

- (id)peek;
{
  if ([self isEmpty]) return nil;
  
  return [stack_ objectAtIndex:[stack_ count] -1 ];
}

- (BOOL)isEmpty;
{
  return [stack_ count] == 0;
}

@end
