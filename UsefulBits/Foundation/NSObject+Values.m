  //  Copyright (c) 2014, Kevin O'Neill
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

#import "NSObject+Values.h"

@implementation NSObject (Values)

- (id)objectForKeyPath:(id)key ofType:(Class)type default:(id)defaultValue;
{
  id value = [self valueForKeyPath:key];

  return [value isKindOfClass:type] ? value : defaultValue;
}

- (NSString *)stringForKeyPath:(id)key default:(NSString *)defaultValue;
{
  return [self objectForKeyPath:key ofType:[NSString class] default:defaultValue];
}

- (NSString *)stringForKeyPath:(id)key;
{
  return [self stringForKeyPath:key default:@""];
}

- (NSNumber *)numberForKeyPath:(id)key default:(NSNumber *)defaultValue;
{
  return [self objectForKeyPath:key ofType:[NSNumber class] default:defaultValue];
}

- (NSNumber *)numberForKeyPath:(id)key;
{
  return [self numberForKeyPath:key default:nil];
}

- (NSArray *)arrayForKeyPath:(id)key default:(NSArray *)defaultValue;
{
  return [self objectForKeyPath:key ofType:[NSArray class] default:defaultValue];
}

- (NSArray *)arrayForKeyPath:(id)key;
{
  return [self arrayForKeyPath:key default:[NSArray array]];
}

- (NSDictionary *)dictionaryForKeyPath:(id)key default:(NSDictionary *)defaultValue;
{
  return [self objectForKeyPath:key ofType:[NSDictionary class] default:defaultValue];
}

- (NSDictionary *)dictionaryForKeyPath:(id)key;
{
  return [self dictionaryForKeyPath:key default:[NSDictionary dictionary]];
}
@end
