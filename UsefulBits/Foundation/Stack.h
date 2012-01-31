//
//  Stack.h
//  UsefulBits
//
//  Created by Kevin O'Neill on 31/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject

- (void)push:(id)object;
- (id)pop;
- (id)peek;

- (BOOL)isEmpty;

@end
