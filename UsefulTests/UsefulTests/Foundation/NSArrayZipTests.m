//
//  NSArrayZipTests.m
//  UsefulTests
//
//  Created by Luke Cunningham on 28/11/12.
//
//

#import <GHUnitIOS/GHUnit.h>

#import <UsefulBits/NSArray+Zip.h>

@interface NSArrayZipTests : GHTestCase
@end

@implementation NSArrayZipTests

- (void)testZipZipsWithoutOptions;
{
  NSArray *result = [@[@9, @10] zip:@[@1, @2, @3]];
  NSArray * expected = @[@[@9, @1], @[@10, @2]];

  GHAssertEqualObjects(result, expected, @"-[NSArray zip:] produced unexpected result", nil);
}

- (void)testZipZipsWithTruncation;
{
  NSArray *result = [@[@9, @10] zip:@[@1, @2, @3] truncate:YES];
  NSArray * expected = @[@[@9, @1], @[@10, @2]];
  
  GHAssertEqualObjects(result, expected, @"-[NSArray zip:truncate:YES] produced unexpected result", nil);
}


- (void)testZipZipsWithoutTruncation;
{
  NSArray *result = [@[@9, @10] zip:@[@1, @2, @3] truncate:NO];
  NSArray * expected = @[@[@9, @1], @[@10, @2], @[[NSNull null], @3]];
  
  GHAssertEqualObjects(result, expected, @"-[NSArray zip:truncate:NO] produced unexpected result", nil);
}

- (void)testZipZipsWithCombinator;
{
  NSArray *result = [@[@9, @10] zip:@[@1, @2, @3] combinator:^ id (id item1, id item2) {
    return [NSString stringWithFormat:@"%@ + %@", item1, item2];
  }];
  
  NSArray * expected = @[@"9 + 1", @"10 + 2"];
  
  GHAssertEqualObjects(result, expected, @"-[NSArray zip:combinator:] produced unexpected result", nil);
}


@end
