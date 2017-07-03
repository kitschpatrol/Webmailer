/*******************************************************************************
 Copyright (c) 2011 Jordy Rose
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 Except as contained in this notice, the name(s) of the above copyright holders
 shall not be used in advertising or otherwise to promote the sale, use or other
 dealings in this Software without prior authorization.
 *******************************************************************************/

#import <XCTest/XCTest.h>
#import "NSString+PrototypeExpansion.h"

@interface TestPrototypeExpansion : XCTestCase
@end

static NSString * const testingURL = @"mailto:x@y.com?one=11&two=22";

@implementation TestPrototypeExpansion

- (void)testNoPlaceholders
{
	NSString *str = @"this is a string with %no placeholders%";
	XCTAssertEqualObjects(str, [str replaceWebmailerPlaceholdersUsingMailtoURLString:testingURL alwaysEscapeQuotes:NO], @"");
}

- (void)testEndsWithOpenBracket
{
	NSString *str = @"this ends with a [";
	XCTAssertEqualObjects(str, [str replaceWebmailerPlaceholdersUsingMailtoURLString:testingURL alwaysEscapeQuotes:NO], @"");
}

- (void)testIncompletePlaceholder
{
	NSString *str = @"this ends with an incomplete [placeholder";
	XCTAssertEqualObjects(str, [str replaceWebmailerPlaceholdersUsingMailtoURLString:testingURL alwaysEscapeQuotes:NO], @"");
}

- (void)testValidPlaceholders
{
	NSString *str = @"this has a [to] placeholder";
	NSString *expected = @"this has a x@y.com placeholder";
	XCTAssertEqualObjects(expected, [str replaceWebmailerPlaceholdersUsingMailtoURLString:testingURL alwaysEscapeQuotes:NO], @"");
	
	str = @"this has a [two] placeholder";
	expected = @"this has a 22 placeholder";
	XCTAssertEqualObjects(expected, [str replaceWebmailerPlaceholdersUsingMailtoURLString:testingURL alwaysEscapeQuotes:NO], @"");

	str = @"this ends with [one]";
	expected = @"this ends with 11";
	XCTAssertEqualObjects(expected, [str replaceWebmailerPlaceholdersUsingMailtoURLString:testingURL alwaysEscapeQuotes:NO], @"");

	str = @"[to] starts this one";
	expected = @"x@y.com starts this one";
	XCTAssertEqualObjects(expected, [str replaceWebmailerPlaceholdersUsingMailtoURLString:testingURL alwaysEscapeQuotes:NO], @"");
}

- (void)testInvalidPlaceholders
{
	NSString *str = @"this has a [random] placeholder";
	NSString *expected = @"this has a  placeholder";
	XCTAssertEqualObjects(expected, [str replaceWebmailerPlaceholdersUsingMailtoURLString:testingURL alwaysEscapeQuotes:NO], @"");
}

- (void)testEmpty
{
	NSString *str = @"";
	XCTAssertEqualObjects(str, [str replaceWebmailerPlaceholdersUsingMailtoURLString:testingURL alwaysEscapeQuotes:NO], @"");
}

- (void)testEmptyPlaceholder
{
	NSString *str = @"this has an empty [] placeholder";
	XCTAssertEqualObjects(str, [str replaceWebmailerPlaceholdersUsingMailtoURLString:testingURL alwaysEscapeQuotes:NO], @"");
}

- (void)testMultiplePlaceholders
{
	NSString *str = @"this has [one], [two], [three] placeholders";
	NSString *expected = @"this has 11, 22,  placeholders";
	XCTAssertEqualObjects(expected, [str replaceWebmailerPlaceholdersUsingMailtoURLString:testingURL alwaysEscapeQuotes:NO], @"");
}

- (void)testBasicModifiers
{
	NSString *emailWithPunctuation = @"mailto:0'^0";
	NSString *template = @"[to]: [%to] [#to] [%#to]";
	NSString *expected = @"0'^0: 0'%5E0 4 6";
	NSString *expectedQuotes = @"0%27^0: 0%27%5E0 6 8";
	
	NSString *actual = [template replaceWebmailerPlaceholdersUsingMailtoURLString:emailWithPunctuation alwaysEscapeQuotes:NO];
	NSString *actualQuotes = [template replaceWebmailerPlaceholdersUsingMailtoURLString:emailWithPunctuation alwaysEscapeQuotes:YES];
	XCTAssertEqualObjects(expected, actual, @"");
	XCTAssertEqualObjects(expectedQuotes, actualQuotes, @"");
}

- (void)testQuestionMark
{
	NSString *template = @"?[?]";
	NSString *templateLeading = @"to?[?]";
	NSString *templateLeadingPlaceholder = @"[to]?[?]";
	NSString *templateTrailing = @"?[?]&abc=def";
	NSString *templateLeadingTrailing = @"to?[?]&abc=def";
	NSString *templateLeadingPlaceholderTrailing = @"[to]?[?]&abc=def";

	XCTAssertEqualObjects([template replaceWebmailerPlaceholdersUsingMailtoURLString:testingURL alwaysEscapeQuotes:NO], @"?one=11&two=22", @"");
	XCTAssertEqualObjects([templateLeading replaceWebmailerPlaceholdersUsingMailtoURLString:testingURL alwaysEscapeQuotes:NO], @"to?one=11&two=22", @"");
	XCTAssertEqualObjects([templateLeadingPlaceholder replaceWebmailerPlaceholdersUsingMailtoURLString:testingURL alwaysEscapeQuotes:NO], @"x@y.com?one=11&two=22", @"");
	XCTAssertEqualObjects([templateTrailing replaceWebmailerPlaceholdersUsingMailtoURLString:testingURL alwaysEscapeQuotes:NO], @"?one=11&two=22&abc=def", @"");
	XCTAssertEqualObjects([templateLeadingTrailing replaceWebmailerPlaceholdersUsingMailtoURLString:testingURL alwaysEscapeQuotes:NO], @"to?one=11&two=22&abc=def", @"");
	XCTAssertEqualObjects([templateLeadingPlaceholderTrailing replaceWebmailerPlaceholdersUsingMailtoURLString:testingURL alwaysEscapeQuotes:NO], @"x@y.com?one=11&two=22&abc=def", @"");
}

- (void)testNoExtraQuestionMark
{
	NSString *template = @"?[?]";
	NSString *templateLeading = @"to?[?]";
	NSString *templateLeadingPlaceholder = @"[to]?[?]";
	NSString *templateTrailing = @"?[?]&abc=def";
	NSString *templateLeadingTrailing = @"to?[?]&abc=def";
	NSString *templateLeadingPlaceholderTrailing = @"[to]?[?]&abc=def";

	NSString *simpleURL = @"mailto:x@y.com";
	
	XCTAssertEqualObjects([template replaceWebmailerPlaceholdersUsingMailtoURLString:simpleURL alwaysEscapeQuotes:NO], @"", @"");
	XCTAssertEqualObjects([templateLeading replaceWebmailerPlaceholdersUsingMailtoURLString:simpleURL alwaysEscapeQuotes:NO], @"to?", @"");
	XCTAssertEqualObjects([templateLeadingPlaceholder replaceWebmailerPlaceholdersUsingMailtoURLString:simpleURL alwaysEscapeQuotes:NO], @"x@y.com", @"");
	XCTAssertEqualObjects([templateTrailing replaceWebmailerPlaceholdersUsingMailtoURLString:simpleURL alwaysEscapeQuotes:NO], @"&abc=def", @"");
	XCTAssertEqualObjects([templateLeadingTrailing replaceWebmailerPlaceholdersUsingMailtoURLString:simpleURL alwaysEscapeQuotes:NO], @"to?&abc=def", @"");
	XCTAssertEqualObjects([templateLeadingPlaceholderTrailing replaceWebmailerPlaceholdersUsingMailtoURLString:simpleURL alwaysEscapeQuotes:NO], @"x@y.com&abc=def", @"");
}

@end
