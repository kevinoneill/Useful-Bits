//
//  UsefulWindow.m
//  UsefulBits
//
//  Created by Kevin O'Neill on 29/05/2014.
//
//

#import "UIWindow+Hooks.h"

#import <objc/runtime.h>

#import "NSSet+Blocks.h"

@implementation UIWindow (Hooks)

+ (void)load
{
  static dispatch_once_t installed;

  dispatch_once(&installed, ^{
    Class class = [self class];

    SEL originalSelector = @selector(sendEvent:);
    SEL swizzledSelector = @selector(sendEventWithHooks:);

    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

    BOOL didAddMethod =
        class_addMethod(class,
            originalSelector,
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
      class_replaceMethod(class,
          swizzledSelector,
          method_getImplementation(originalMethod),
          method_getTypeEncoding(originalMethod));
    } else {
      method_exchangeImplementations(originalMethod, swizzledMethod);
    }
  });
}

- (void)setHooks:(NSSet *)hooks
{
  objc_setAssociatedObject(self, @selector(hooks), hooks, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id)hooks
{
  return objc_getAssociatedObject(self, @selector(hooks));
}

- (void)addEventHook:(id <UsefulEventHook>)hook
{
  NSMutableSet *update = [NSMutableSet setWithSet:[self hooks]];
  [update addObject:hook];
  [self setHooks:update];
}

- (void)removeEventHook:(id <UsefulEventHook>)hook
{
  NSMutableSet *update = [NSMutableSet setWithSet:[self hooks]];
  [update removeObject:hook];
  [self setHooks:update];
}

- (void)sendEventWithHooks:(UIEvent *)event
{
  NSSet *hooks = [[[self hooks] retain] autorelease];

  if ([hooks count] == 0)
  {
    [self sendEventWithHooks:event];
  }
  else
  {
    UIEvent *result = [hooks reduce:^ UIEvent * (UIEvent * current, id <UsefulEventHook> hook)
    {
      return [hook processEvent:current];
    } initial:event];

    [self sendEventWithHooks:result];
  }
}

@end