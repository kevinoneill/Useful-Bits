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

#import "UIView+Actions.h"

#import "UIGestureRecognizer+Blocks.h"
#import "NSArray+Blocks.h"

@implementation UIView (Gestures)

- (void)onTap:(void (^) (id sender))action;
{
  [self onTaps:1 touches:1 action:action];
}

- (void)onDoubleTap:(void (^) (id sender))action;
{
  [self onTaps:2 touches:1 action:action];
}

- (void)onTaps:(NSUInteger)taps touches:(NSUInteger)touches action:(void (^) (id sender))action; 
{
  UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(UIGestureRecognizer* gesture) {
    action([gesture view]);
  }];
  
  [gesture setNumberOfTapsRequired:taps];
  [gesture setNumberOfTouchesRequired:touches];

  [[[self gestureRecognizers] filter:^BOOL(id gesture_recognizer) {
    return [gesture_recognizer isKindOfClass:[UITapGestureRecognizer class]]
            && [gesture_recognizer numberOfTouchesRequired] == touches
            && [gesture_recognizer numberOfTapsRequired] < taps;
  }] each:^(id tap_gesture_recognizer) {
    [gesture requireGestureRecognizerToFail:tap_gesture_recognizer];
  }];

  [self addGestureRecognizer:gesture];
  [gesture release];
}

- (void)onTap:(void (^) (id sender))action touches:(NSUInteger)touches; 
{
  [self onTaps:1 touches:touches action:action];
}

- (void)onDoubleTap:(void (^) (id sender))action touches:(NSUInteger)touches;
{
  [self onTaps:2 touches:touches action:action];
}

@end
