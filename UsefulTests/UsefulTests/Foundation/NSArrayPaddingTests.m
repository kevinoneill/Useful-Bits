//
//  NSArrayFillTests.m
//  UsefulTests
//
//  Created by Luke Cunningham on 7/08/12.
//
//

#import <GHUnitIOS/GHUnit.h>

#import <UsefulBits/NSArray+Blocks.h>

@interface NSArrayPaddingTests : GHTestCase
@end

@implementation NSArrayPaddingTests

- (void)testPadsEmptyArrayToSize;
{
  NSArray *array = [[NSArray array] pad:10];
  
  GHAssertTrue(10 == [array count], @"array has incorrect count");
  GHAssertEqualObjects([array objectAtIndex:5], [NSNull null], @"array was not filled correctly with return value of block");
}

- (void)testPadsArrayWithLessValuesToSize;
{
  NSArray *array = [[NSArray arrayWithObjects:@"first", @"second", nil] pad:10];
  
  GHAssertEqualObjects([NSNumber numberWithUnsignedInteger:[array count]], [NSNumber numberWithInt:10], @"array has incorrect count");
}

- (void)testIgnoresArrayWithMoreValues;
{
  NSArray *array = [[NSArray arrayWithObjects:@"first", @"second", @"third", nil] pad:2];
  
  GHAssertEqualObjects([NSNumber numberWithUnsignedInteger:[array count]], [NSNumber numberWithInt:3], @"array has incorrect count");
}

- (void)testAddsReturnValueOfBlockToArrayWithMoreValues;
{
  NSArray *array = [[NSArray array] pad:10 with:^id{
    return @"some string";
  }];
  
  GHAssertEqualObjects([array objectAtIndex:1], @"some string", @"array has incorrect value");
  GHAssertEqualObjects([array objectAtIndex:8], @"some string", @"array has incorrect value");
}

- (void)testAddsReturnValueOfBlockToArrayWithLessValues;
{
  NSArray *array = [[NSArray arrayWithObjects:@"first", @"second", nil] pad:10 with:^ id {
    return @"some string";
  }];
  
  GHAssertEqualObjects([array objectAtIndex:1], @"second", @"array has incorrect value");
  GHAssertEqualObjects([array objectAtIndex:8], @"some string", @"array has incorrect value");
}

@end