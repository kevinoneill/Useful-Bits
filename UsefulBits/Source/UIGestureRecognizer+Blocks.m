//
//  UIGestureRecogniser+Blocks.m
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

#import "UIGestureRecognizer+Blocks.h"

#import <objc/runtime.h>

@interface UIGestureRecognizer (Blocks_Internal)

@property (nonatomic, copy) GestureActionBlock actionBlock;

- (void)handleAction:(UIGestureRecognizer *)recognizer;

@end

@implementation UIGestureRecognizer (Blocks)

static char block_key; 

+ (id)instanceWithActionBlock:(GestureActionBlock)action;
{
  id instance = [[[self class] alloc] initWithActionBlock:action];
  
  return [instance autorelease];
}

- (id)initWithActionBlock:(GestureActionBlock)action;
{
  if (self == [self initWithTarget:self action:@selector(handleAction:)])
  {
    [self setActionBlock:action];
  }
  
  return self;
}

- (void)handleAction:(UIGestureRecognizer *)recognizer;
{
  GestureActionBlock block = [self actionBlock];
  if(nil != block)
  {
    block(recognizer);
  }
}

- (GestureActionBlock)actionBlock;
{
  return objc_getAssociatedObject(self, &block_key);
}

- (void)setActionBlock:(GestureActionBlock)block;
{
  objc_setAssociatedObject(self, &block_key, block, OBJC_ASSOCIATION_COPY);
}

@end
