//
//  UsefulWindow.h
//  UsefulBits
//
//  Created by Kevin O'Neill on 29/05/2014.
//
//

#import <UIKit/UIKit.h>

@protocol UsefulEventHook <NSObject>

- (UIEvent *)processEvent:(UIEvent *)event;

@end

@interface UIWindow (Hooks)

- (void)addEventHook:(id <UsefulEventHook>)hook;
- (void)removeEventHook:(id <UsefulEventHook>)hook;

@end
