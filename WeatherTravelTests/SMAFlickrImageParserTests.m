//
//  SMAFlickrImageParserTests.m
//  WeatherTravelTests
//
//  Created by Maria Semakova on 1/19/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>

#import "SMAFlickrImageParser.h"


@interface SMAFlickrImageParserTests : XCTestCase

@property (nonatomic, strong) SMAFlickrImageParser *parser;

@end

@implementation SMAFlickrImageParserTests

- (void)setUp
{
    [super setUp];
    self.parser = OCMPartialMock([SMAFlickrImageParser new]);
}

- (void)tearDown
{
    self.parser = nil;
    [super tearDown];
}

- (void)testParseNil
{
    NSData *data = nil;
    id classMock = OCMClassMock([SMAFlickrImageParser class]);
    OCMStub(ClassMethod([classMock parse:[OCMArg any]])).andReturn(nil);
    
    id result = [SMAFlickrImageParser parse:data];
    expect(result).to.beNil();
}

- (void)testParseWrong
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"wrong": @"wrong"} options:0 error:nil];
    id classMock = OCMClassMock([SMAFlickrImageParser class]);
    OCMStub(ClassMethod([classMock parse:[OCMArg any]])).andReturn(nil);
    
    id result = [SMAFlickrImageParser parse:data];
    expect(result).to.beNil();
}

- (void)testParseReal
{
    NSDictionary *dataToParse = @{
                                  @"stat": @"ok",
                                  @"photos": @{
                                          @"total": @"114",
                                          @"photo": @[
                                                  @{
                                                      @"url_q": @"https://farm1.staticflickr.com/697/21420851873_cd5e2b9477_q.jpg",
                                                      @"url_o": @"https://farm1.staticflickr.com/697/21420851873_8226ee7ebc_o.jpg"
                                                      }
                                                  ]
                                          }
                                  };
    NSDictionary *expectedResult = @{
                                     @"url_orig": @"https://farm1.staticflickr.com/697/21420851873_8226ee7ebc_o.jpg",
                                     @"url_square": @"https://farm1.staticflickr.com/697/21420851873_cd5e2b9477_q.jpg"
                                     };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataToParse options:0 error:nil];
    id classMock = OCMClassMock([SMAFlickrImageParser class]);
    OCMStub(ClassMethod([classMock parse:[OCMArg any]])).andReturn(expectedResult);
    
    id result = [SMAFlickrImageParser parse:data];
    expect(result).toNot.beNil();
    expect(result).to.equal(expectedResult);
}

@end
