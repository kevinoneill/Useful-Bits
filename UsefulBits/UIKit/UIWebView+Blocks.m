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

#import "UIWebView+Blocks.h"

#import <objc/runtime.h>

@interface UIWebView_Blocks_Delegate : NSObject <UIWebViewDelegate>

@property (nonatomic, copy) BOOL(^onShouldStartLoad)(UIWebView *webView, NSURLRequest *request, UIWebViewNavigationType navigation);
@property (nonatomic, copy) void(^onDidStartLoad)(UIWebView *webView);
@property (nonatomic, copy) void(^onDidFinishLoad)(UIWebView *webView);
@property (nonatomic, copy) void(^onDidFinishWithError)(UIWebView *webView, NSError *error);

@end

@implementation UIWebView (Blocks)

static char kBlockDelegateKey;

- (UIWebView_Blocks_Delegate *)blockDelegateCreateIfNil:(BOOL)create;
{
  UIWebView_Blocks_Delegate *delegate = objc_getAssociatedObject(self, &kBlockDelegateKey);
  
  if (delegate == nil && create)
  {
    delegate = [[[UIWebView_Blocks_Delegate alloc] init] autorelease];
    objc_setAssociatedObject(self, &kBlockDelegateKey, delegate, OBJC_ASSOCIATION_RETAIN);
    
    [self setDelegate:delegate];
  }
  
  return delegate;
}

- (BOOL (^)(UIWebView *, NSURLRequest *, UIWebViewNavigationType))onShouldStartLoad;
{
  return [[self blockDelegateCreateIfNil:NO] onShouldStartLoad];
}

- (void)setOnShouldStartLoad:(BOOL (^)(UIWebView *, NSURLRequest *, UIWebViewNavigationType))onShouldStartLoad;
{
  [[self blockDelegateCreateIfNil:YES] setOnShouldStartLoad:onShouldStartLoad];
}

- (void (^)(UIWebView *))onDidStartLoad;
{
  return [[self blockDelegateCreateIfNil:NO] onDidStartLoad];
}

- (void)setOnDidStartLoad:(void (^)(UIWebView *))onDidStartLoad;
{
  [[self blockDelegateCreateIfNil:YES] setOnDidStartLoad:onDidStartLoad];
}

- (void (^)(UIWebView *))onDidFinishLoad;
{
  return [[self blockDelegateCreateIfNil:NO] onDidFinishLoad];
}

- (void)setOnDidFinishLoad:(void (^)(UIWebView *))onDidFinishLoad;
{
  [[self blockDelegateCreateIfNil:YES] setOnDidFinishLoad:onDidFinishLoad];
}

- (void (^)(UIWebView *, NSError *))onDidFinishWithError;
{
  return [[self blockDelegateCreateIfNil:NO] onDidFinishWithError];
}

-(void)setOnDidFinishWithError:(void (^)(UIWebView *, NSError *))onDidFinishWithError;
{
  [[self blockDelegateCreateIfNil:YES] setOnDidFinishWithError:onDidFinishWithError];
}

@end

@implementation UIWebView_Blocks_Delegate

@synthesize onShouldStartLoad = onShouldStartLoad_;
@synthesize onDidStartLoad = onDidStartLoad_;
@synthesize onDidFinishLoad = onDidFinishLoad_;
@synthesize onDidFinishWithError = onDidFinishWithError_;

-(void)dealloc
{
  [onShouldStartLoad_ release];
  [onDidStartLoad_ release];
  [onDidFinishLoad_ release];
  [onDidFinishWithError_ release];
  
  [super dealloc];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  if ([self onShouldStartLoad])
  {
    return [self onShouldStartLoad](webView, request, navigationType);
  }
  
  return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView;
{
  if ([self onDidStartLoad])
  {
    [self onDidStartLoad](webView);
  }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
  if ([self onDidFinishLoad])
  {
    [self onDidFinishLoad](webView);
  }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
  if ([self onDidFinishWithError])
  {
    [self onDidFinishWithError](webView, error);
  }
}

@end
