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

#import "NSDictionary+URLParams.h"

#import "NSString+URLEncode.h"
#import "NSArray+Blocks.h"

@implementation NSDictionary (URLParams)

- (NSString *)encodeParameter:(NSString *)parameter value:(id)value
{
  NSString *value_string = ([value isKindOfClass:[NSNumber class]] && (0 == strcmp([value objCType], @encode(BOOL))))
    ? [value boolValue] ? @"true" : @"false"
    : [value description];
  
  return [NSString stringWithFormat:@"%@=%@", [parameter urlEncode], [value_string urlEncode]];
}

- (NSString *)asURLParameters;
{
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
  
  [self enumerateKeysAndObjectsUsingBlock: ^ (id key, id value, BOOL *stop) {
    if ([value isKindOfClass:[NSArray class]])
    {
      [result addObjectsFromArray:[value map: ^ id (id item) {
        return [self encodeParameter:key value:item];
      }]];
    }
    else
    {
      [result addObject:[self encodeParameter:key value:value]];
    }
  }];
  
  return [result componentsJoinedByString:@"&"];
}

@end
