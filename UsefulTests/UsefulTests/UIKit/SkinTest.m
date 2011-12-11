//
//  SkinTest.m
//  UsefulTests
//
//  Created by Kevin O'Neill on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import <UsefulBits/Skin.h>
#import <UsefulBits/UIColor+Hex.h>


@interface SkinTest : GHTestCase
@end

@implementation SkinTest

- (void)testLoadSkin
{
  Skin *skin = [Skin skin];
  
  GHAssertNotNil(skin, @"failed to create skin");
}

#pragma mark - Properties

- (void)testLoadsStringProperty
{
  Skin *skin = [Skin skin];
  id value = [skin propertyNamed:@"string"];
  
  GHAssertNotNil(value, @"should have provided a value");
  GHAssertTrue([value isKindOfClass:[NSString class]], @"expected an instance of NSString");
  GHAssertEqualStrings(@"a string", value, nil);
}

- (void)testLoadsNumberProperty
{
  Skin *skin = [Skin skin];
  id value = [skin propertyNamed:@"number"];
  
  GHAssertNotNil(value, @"should have provided a value");
  GHAssertTrue([value isKindOfClass:[NSNumber class]], @"expected an instance of NSNumber");
  GHAssertEqualObjects([NSNumber numberWithInteger:42], value, nil);
}

- (void)testLoadsNilForMissingProperty
{
  Skin *skin = [Skin skin];
  id value = [skin propertyNamed:@"missing"];
  
  GHAssertNil(value, @"should not have provided a value");
}

#pragma mark - Colors

- (void)testResolvesMissingColor
{
  Skin *skin = [Skin skin];
  UIColor *missing = [skin colorNamed:@"missing"];
  
  GHAssertNotNil(missing, @"should have provided default color");
  GHAssertEqualObjects([UIColor cyanColor], missing, @"missing should be cyan");
}

- (void)testResolvesHexColor
{
  Skin *skin = [Skin skin];
  UIColor *grey = [skin colorNamed:@"grey"];
  
  GHAssertNotNil(grey, @"should have provided grey");
  GHAssertEqualObjects([UIColor colorWithHex:0x7f7f7f], grey, @"should be grey");
}

- (void)testResolvesPatternColor
{
  Skin *skin = [Skin skin];
  UIColor *pattern = [skin colorNamed:@"pattern"];
  
  GHAssertNotNil(pattern, @"should created pattern color");
  GHAssertNotEqualObjects([UIColor cyanColor], pattern, @"pattern should not be cyan");
}

- (void)testResolvesReferenceColor
{
  Skin *skin = [Skin skin];
  UIColor *grey = [skin colorNamed:@"default-color"];
  
  GHAssertNotNil(grey, @"should have resolved to grey");
  GHAssertEqualObjects([UIColor colorWithHex:0x7f7f7f], grey, @"should be grey");
}

- (void)testResolvesMultiReferenceColor
{
  Skin *skin = [Skin skin];
  UIColor *grey = [skin colorNamed:@"reference-to-reference"];
  
  GHAssertNotNil(grey, @"should have resolved to grey");
  GHAssertEqualObjects([UIColor colorWithHex:0x7f7f7f], grey, @"should be grey");
}

#pragma mark - Images

- (void)testResolvesImages
{
  Skin *skin = [Skin skin];
  UIImage *image = [skin imageNamed:@"background"];
  
  GHAssertNotNil(image, @"should have provided image");
}

- (void)testResolvesNilForMissingImages
{
  Skin *skin = [Skin skin];
  UIImage *image = [skin imageNamed:@"missing"];
  
  GHAssertNil(image, @"should not have provided image");
}

#pragma mark - Fonts

- (void)testResolvesSystemFont
{
  Skin *skin = [Skin skin];
  UIFont *font = [skin fontNamed:@"base-font"];
  
  GHAssertNotNil(font, @"base-font not loaded");
  GHAssertEquals(14.f, [font pointSize], @"expected the font to be 14pt");
}

- (void)testResolvesBoldFont
{
  Skin *skin = [Skin skin];
  UIFont *font = [skin fontNamed:@"bold-font"];
  
  GHAssertNotNil(font, @"bold-font not loaded");
  GHAssertEquals(14.f, [font pointSize], @"expected the font to be 14pt");
  GHAssertEqualStrings(@"Helvetica-Bold", [font fontName], @"expected helvetica bold");
}

- (void)testResolvesConfiguredFont
{
  Skin *skin = [Skin skin];
  UIFont *font = [skin fontNamed:@"system-font-italic"];
  
  GHAssertNotNil(font, @"system-font-italic not loaded");
  GHAssertEquals(11.f, [font pointSize], @"expected the font to be 11pt");
}



#pragma mark - Broken

- (void)testBrokenThrows
{
  GHAssertThrows([Skin skinForSection:@"broken-section"], @"should have detected recursion");
}

#pragma mark - Inheritence

- (void)testOverridesStringProperty
{
  Skin *skin = [Skin skinForSection:@"subsection"];
  id value = [skin propertyNamed:@"string"];
  
  GHAssertNotNil(value, @"should have provided a value");
  GHAssertTrue([value isKindOfClass:[NSString class]], @"expected an instance of NSString");
  GHAssertEqualStrings(@"a new string", value, nil);
}

- (void)testReferenceParentProperty
{
  Skin *skin = [Skin skinForSection:@"subsection"];
  UIColor *grey = [skin colorNamed:@"parent-reference-color"];
  
  GHAssertNotNil(grey, @"should have provided grey");
  GHAssertEqualObjects([UIColor colorWithHex:0x7f7f7f], grey, @"should be grey");
}

- (void)testResolvesSectionImages
{
  Skin *skin = [Skin skinForSection:@"subsection"];
  UIImage *image = [skin imageNamed:@"sub-image"];
  
  GHAssertNotNil(image, @"should have provided image");
}

@end
