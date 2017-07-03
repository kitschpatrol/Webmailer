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
#import "NSString+PrototypeExpansionPrivate.h"


@interface TestFieldParsing : XCTestCase
@end


@implementation TestFieldParsing

- (void)testBasic
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"mailto:00?one=11&two=22&three=33"] autorelease];
	
	XCTAssertEqualObjects(@"00", [fields rawValueForHeader:@"to"], @"");
	
	XCTAssertEqualObjects(@"11", [fields rawValueForHeader:@"one"], @"");
	XCTAssertEqualObjects(@"22", [fields rawValueForHeader:@"two"], @"");
	XCTAssertEqualObjects(@"33", [fields rawValueForHeader:@"three"], @"");
	
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"four"], @"");
	
	XCTAssertEqualObjects(@"one=11&two=22&three=33", [fields rawValueForHeader:@"?"], @"");
}

- (void)testNoProtocol
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"00?one=11&two=22&three=33"] autorelease];
	
	XCTAssertEqualObjects(@"00", [fields rawValueForHeader:@"to"], @"");
	
	XCTAssertEqualObjects(@"11", [fields rawValueForHeader:@"one"], @"");
	XCTAssertEqualObjects(@"22", [fields rawValueForHeader:@"two"], @"");
	XCTAssertEqualObjects(@"33", [fields rawValueForHeader:@"three"], @"");
	
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"four"], @"");
	
	XCTAssertEqualObjects(@"one=11&two=22&three=33", [fields rawValueForHeader:@"?"], @"");
}

- (void)testNoRecipient
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"mailto:?one=11&two=22&three=33"] autorelease];
	
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"to"], @"");
	
	XCTAssertEqualObjects(@"11", [fields rawValueForHeader:@"one"], @"");
	XCTAssertEqualObjects(@"22", [fields rawValueForHeader:@"two"], @"");
	XCTAssertEqualObjects(@"33", [fields rawValueForHeader:@"three"], @"");
	
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"four"], @"");
	
	XCTAssertEqualObjects(@"one=11&two=22&three=33", [fields rawValueForHeader:@"?"], @"");
}

- (void)testQueryRecipient
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"mailto:?one=11&two=22&three=33&to=00"] autorelease];
	
	XCTAssertEqualObjects(@"00", [fields rawValueForHeader:@"to"], @"");
	
	XCTAssertEqualObjects(@"11", [fields rawValueForHeader:@"one"], @"");
	XCTAssertEqualObjects(@"22", [fields rawValueForHeader:@"two"], @"");
	XCTAssertEqualObjects(@"33", [fields rawValueForHeader:@"three"], @"");
	
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"four"], @"");
	
	XCTAssertEqualObjects(@"one=11&two=22&three=33&to=00", [fields rawValueForHeader:@"?"], @"");
}

- (void)testNoQuery
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"mailto:00"] autorelease];
	
	XCTAssertEqualObjects(@"00", [fields rawValueForHeader:@"to"], @"");
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"four"], @"");
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"?"], @"");
}

- (void)testEmptyQuery
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"mailto:00?"] autorelease];
	
	XCTAssertEqualObjects(@"00", [fields rawValueForHeader:@"to"], @"");
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"four"], @"");
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"?"], @"");
}

- (void)testProtocolOnly
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"mailto:"] autorelease];
	
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"to"], @"");
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"four"], @"");
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"?"], @"");
}

- (void)testCompletelyEmpty
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@""] autorelease];
	
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"to"], @"");
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"four"], @"");
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"?"], @"");
}

- (void)testEmptyParams
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"mailto:00?one=&two=22&three=&four=44&five="] autorelease];
	
	XCTAssertEqualObjects(@"00", [fields rawValueForHeader:@"to"], @"");
	
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"one"], @"");
	XCTAssertEqualObjects(@"22", [fields rawValueForHeader:@"two"], @"");
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"three"], @"");
	XCTAssertEqualObjects(@"44", [fields rawValueForHeader:@"four"], @"");
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"five"], @"");
	
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"six"], @"");
	
	XCTAssertEqualObjects(@"one=&two=22&three=&four=44&five=", [fields rawValueForHeader:@"?"], @"");
}

#pragma mark -

- (void)testRegularHeaderValues
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"mailto:00?one=11&two=22&three=33"] autorelease];
	
	XCTAssertEqualObjects(@"00", [fields valueForHeader:@"to" escapeQuotes:NO], @"");
	
	XCTAssertEqualObjects(@"11", [fields valueForHeader:@"one" escapeQuotes:NO], @"");
	XCTAssertEqualObjects(@"22", [fields valueForHeader:@"two" escapeQuotes:NO], @"");
	XCTAssertEqualObjects(@"33", [fields valueForHeader:@"three" escapeQuotes:NO], @"");
	
	XCTAssertEqualObjects(@"", [fields valueForHeader:@"four" escapeQuotes:NO], @"");
	
	XCTAssertEqualObjects(@"one=11&two=22&three=33", [fields valueForHeader:@"?" escapeQuotes:NO], @"");
}

- (void)testNeedlessQuoteEscaping
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"mailto:00?one=11&two=22&three=33"] autorelease];
	
	XCTAssertEqualObjects(@"00", [fields valueForHeader:@"to" escapeQuotes:YES], @"");
	
	XCTAssertEqualObjects(@"11", [fields valueForHeader:@"one" escapeQuotes:YES], @"");
	XCTAssertEqualObjects(@"22", [fields valueForHeader:@"two" escapeQuotes:YES], @"");
	XCTAssertEqualObjects(@"33", [fields valueForHeader:@"three" escapeQuotes:YES], @"");
	
	XCTAssertEqualObjects(@"", [fields valueForHeader:@"four" escapeQuotes:YES], @"");
	
	XCTAssertEqualObjects(@"one=11&two=22&three=33", [fields valueForHeader:@"?" escapeQuotes:YES], @"");
}

- (void)testCharCounting
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"mailto:00?one=111&two=2222&three=33333"] autorelease];
	
	XCTAssertEqualObjects(@"2", [fields valueForHeader:@"#to" escapeQuotes:NO], @"");
	
	XCTAssertEqualObjects(@"3", [fields valueForHeader:@"#one" escapeQuotes:NO], @"");
	XCTAssertEqualObjects(@"4", [fields valueForHeader:@"#two" escapeQuotes:NO], @"");
	XCTAssertEqualObjects(@"5", [fields valueForHeader:@"#three" escapeQuotes:NO], @"");
	
	XCTAssertEqualObjects(@"0", [fields valueForHeader:@"#four" escapeQuotes:NO], @"");
	
	XCTAssertEqualObjects(@"28", [fields valueForHeader:@"#?" escapeQuotes:NO], @"");
}

- (void)testCharCountingWithNeedlessQuoteEscaping
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"mailto:00?one=111&two=2222&three=33333"] autorelease];
	
	XCTAssertEqualObjects(@"2", [fields valueForHeader:@"#to" escapeQuotes:YES], @"");
	
	XCTAssertEqualObjects(@"3", [fields valueForHeader:@"#one" escapeQuotes:YES], @"");
	XCTAssertEqualObjects(@"4", [fields valueForHeader:@"#two" escapeQuotes:YES], @"");
	XCTAssertEqualObjects(@"5", [fields valueForHeader:@"#three" escapeQuotes:YES], @"");
	
	XCTAssertEqualObjects(@"0", [fields valueForHeader:@"#four" escapeQuotes:YES], @"");
	
	XCTAssertEqualObjects(@"28", [fields valueForHeader:@"#?" escapeQuotes:YES], @"");
}

- (void)testNeedlesslyEscapedFields
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"mailto:00?one=11&two=22&three=33"] autorelease];
	
	XCTAssertEqualObjects(@"00", [fields valueForHeader:@"%to" escapeQuotes:NO], @"");
	
	XCTAssertEqualObjects(@"11", [fields valueForHeader:@"%one" escapeQuotes:NO], @"");
	XCTAssertEqualObjects(@"22", [fields valueForHeader:@"%two" escapeQuotes:NO], @"");
	XCTAssertEqualObjects(@"33", [fields valueForHeader:@"%three" escapeQuotes:NO], @"");
	
	XCTAssertEqualObjects(@"", [fields valueForHeader:@"%four" escapeQuotes:NO], @"");
	
	XCTAssertEqualObjects(@"one=11%26two=22%26three=33", [fields valueForHeader:@"%?" escapeQuotes:NO], @"");
}

- (void)testNeedlesslyEscapedFieldsWithQuoteEscaping
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"mailto:00?one=11&two=22&three=33"] autorelease];
	
	XCTAssertEqualObjects(@"00", [fields valueForHeader:@"%to" escapeQuotes:YES], @"");
	
	XCTAssertEqualObjects(@"11", [fields valueForHeader:@"%one" escapeQuotes:YES], @"");
	XCTAssertEqualObjects(@"22", [fields valueForHeader:@"%two" escapeQuotes:YES], @"");
	XCTAssertEqualObjects(@"33", [fields valueForHeader:@"%three" escapeQuotes:YES], @"");
	
	XCTAssertEqualObjects(@"", [fields valueForHeader:@"%four" escapeQuotes:YES], @"");
	
	XCTAssertEqualObjects(@"one=11%26two=22%26three=33", [fields valueForHeader:@"%?" escapeQuotes:YES], @"");
}

- (void)testQuoteEscaping
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"mailto:0'^0?one=1\"%2B1&two=2/2"] autorelease];
	
	XCTAssertEqualObjects(@"0%27^0", [fields valueForHeader:@"to" escapeQuotes:YES], @"");
	
	XCTAssertEqualObjects(@"1%22%2B1", [fields valueForHeader:@"one" escapeQuotes:YES], @"");
	XCTAssertEqualObjects(@"2/2", [fields valueForHeader:@"two" escapeQuotes:YES], @"");

	XCTAssertEqualObjects(@"", [fields valueForHeader:@"three" escapeQuotes:YES], @"");
	
	XCTAssertEqualObjects(@"one=1%22%2B1&two=2/2", [fields valueForHeader:@"?" escapeQuotes:YES], @"");
}

- (void)testCountingQuoteEscaping
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"mailto:0'^0?one=1\"%2B1&two=2/2"] autorelease];
	
	XCTAssertEqualObjects(@"6", [fields valueForHeader:@"#to" escapeQuotes:YES], @"");
	
	XCTAssertEqualObjects(@"8", [fields valueForHeader:@"#one" escapeQuotes:YES], @"");
	XCTAssertEqualObjects(@"3", [fields valueForHeader:@"#two" escapeQuotes:YES], @"");
	
	XCTAssertEqualObjects(@"0", [fields valueForHeader:@"#three" escapeQuotes:YES], @"");
	
	XCTAssertEqualObjects(@"20", [fields valueForHeader:@"#?" escapeQuotes:YES], @"");
}

- (void)testEscapedFields
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"mailto:0'^0?one=1\"%2B1&two=2/2"] autorelease];
	
	XCTAssertEqualObjects(@"0'%5E0", [fields valueForHeader:@"%to" escapeQuotes:NO], @"");
	
	XCTAssertEqualObjects(@"1%22%252B1", [fields valueForHeader:@"%one" escapeQuotes:NO], @"");
	XCTAssertEqualObjects(@"2/2", [fields valueForHeader:@"%two" escapeQuotes:NO], @"");
	
	XCTAssertEqualObjects(@"", [fields valueForHeader:@"%three" escapeQuotes:NO], @"");
	
	XCTAssertEqualObjects(@"one=1%22%252B1%26two=2/2", [fields valueForHeader:@"%?" escapeQuotes:NO], @"");
}

- (void)testCountingEscapedFields
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"mailto:0'^0?one=1\"%2B1&two=2/2"] autorelease];
	
	XCTAssertEqualObjects(@"6", [fields valueForHeader:@"#%to" escapeQuotes:NO], @"");
	XCTAssertEqualObjects(@"6", [fields valueForHeader:@"%#to" escapeQuotes:NO], @"");
	
	XCTAssertEqualObjects(@"10", [fields valueForHeader:@"#%one" escapeQuotes:NO], @"");
	XCTAssertEqualObjects(@"10", [fields valueForHeader:@"%#one" escapeQuotes:NO], @"");
	XCTAssertEqualObjects(@"3", [fields valueForHeader:@"#%two" escapeQuotes:NO], @"");
	XCTAssertEqualObjects(@"3", [fields valueForHeader:@"%#two" escapeQuotes:NO], @"");
	
	XCTAssertEqualObjects(@"0", [fields valueForHeader:@"#%three" escapeQuotes:NO], @"");
	XCTAssertEqualObjects(@"0", [fields valueForHeader:@"%#three" escapeQuotes:NO], @"");
	
	XCTAssertEqualObjects(@"24", [fields valueForHeader:@"#%?" escapeQuotes:NO], @"");
	XCTAssertEqualObjects(@"24", [fields valueForHeader:@"%#?" escapeQuotes:NO], @"");
}

- (void)testEscapedFieldsWithQuoteEscaping
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"mailto:0'^0?one=1\"%2B1&two=2/2"] autorelease];
	
	XCTAssertEqualObjects(@"0%27%5E0", [fields valueForHeader:@"%to" escapeQuotes:YES], @"");
	
	XCTAssertEqualObjects(@"1%22%252B1", [fields valueForHeader:@"%one" escapeQuotes:YES], @"");
	XCTAssertEqualObjects(@"2/2", [fields valueForHeader:@"%two" escapeQuotes:YES], @"");
	
	XCTAssertEqualObjects(@"", [fields valueForHeader:@"%three" escapeQuotes:YES], @"");
	
	XCTAssertEqualObjects(@"one=1%22%252B1%26two=2/2", [fields valueForHeader:@"%?" escapeQuotes:YES], @"");
}

- (void)testCountingEscapedFieldsWithQuoteEscaping
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"mailto:0'^0?one=1\"%2B1&two=2/2"] autorelease];
	
	XCTAssertEqualObjects(@"8", [fields valueForHeader:@"#%to" escapeQuotes:YES], @"");
	XCTAssertEqualObjects(@"8", [fields valueForHeader:@"%#to" escapeQuotes:YES], @"");
	
	XCTAssertEqualObjects(@"10", [fields valueForHeader:@"#%one" escapeQuotes:YES], @"");
	XCTAssertEqualObjects(@"10", [fields valueForHeader:@"%#one" escapeQuotes:YES], @"");
	XCTAssertEqualObjects(@"3", [fields valueForHeader:@"#%two" escapeQuotes:YES], @"");
	XCTAssertEqualObjects(@"3", [fields valueForHeader:@"%#two" escapeQuotes:YES], @"");
	
	XCTAssertEqualObjects(@"0", [fields valueForHeader:@"#%three" escapeQuotes:YES], @"");
	XCTAssertEqualObjects(@"0", [fields valueForHeader:@"%#three" escapeQuotes:YES], @"");
	
	XCTAssertEqualObjects(@"24", [fields valueForHeader:@"#%?" escapeQuotes:YES], @"");
	XCTAssertEqualObjects(@"24", [fields valueForHeader:@"%#?" escapeQuotes:YES], @"");
}

#pragma mark -

- (void)testFieldSubstrings
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"mailto:00?one=11&two=22&three=33"] autorelease];
	
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"ne"], @"");
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"wo"], @"");
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"ree"], @"");
}

- (void)testFieldSubstringsContinuing
{
	MailtoFields *fields = [[[MailtoFields alloc] initWithURLString:@"mailto:?abc=1&bc=2"] autorelease];
	
	XCTAssertEqualObjects(@"2", [fields rawValueForHeader:@"bc"], @"");
	XCTAssertEqualObjects(@"", [fields rawValueForHeader:@"c"], @"");
}

@end
