//
//  SMAGoogleCoordinatesParserTests.m
//  WeatherTravelTests
//
//  Created by Maria Semakova on 1/19/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>

#import "SMAGoogleCoordinatesParser.h"


@interface SMAGoogleCoordinatesParserTests : XCTestCase

@property (nonatomic, strong) SMAGoogleCoordinatesParser *parser;

@end

@implementation SMAGoogleCoordinatesParserTests

- (void)setUp
{
    [super setUp];
    self.parser = OCMPartialMock([SMAGoogleCoordinatesParser new]);
}

- (void)tearDown
{
    self.parser = nil;
    [super tearDown];
}

- (void)testParseNil
{
    NSData *data = nil;
    id classMock = OCMClassMock([SMAGoogleCoordinatesParser class]);
    OCMStub(ClassMethod([classMock parse:[OCMArg any]])).andReturn(nil);
    
    id result = [SMAGoogleCoordinatesParser parse:data];
    expect(result).to.beNil();
}

- (void)testParseWrong
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"wrong": @"wrong"} options:0 error:nil];
    id classMock = OCMClassMock([SMAGoogleCoordinatesParser class]);
    OCMStub(ClassMethod([classMock parse:[OCMArg any]])).andReturn(nil);
    
    id result = [SMAGoogleCoordinatesParser parse:data];
    expect(result).to.beNil();
}

- (void)testParseReal
{
    NSDictionary *dataToParse = @{
                                  @"results": @[@{
                                                    @"geometry": @{
                                                            @"location": @{
                                                                    @"lat": @"37.9838096",
                                                                    @"lng": @"23.7275388"
                                                                    }
                                                            },
                                                    @"address_components": @[@{
                                                                                 @"short_name": @"Athens"
                                                                                 },
                                                                             @{
                                                                                 @"long_name": @"Greece"
                                                                                 }]
                                                    }],
                                  @"status": @"OK"
                                  };
    NSDictionary *expectedResult = @{
                                     @"city": @"Athens",
                                     @"country": @"Greece",
                                     @"lat": @"37.9838096",
                                     @"lng": @"23.7275388"
                                     };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataToParse options:0 error:nil];
    id classMock = OCMClassMock([SMAGoogleCoordinatesParser class]);
    OCMStub(ClassMethod([classMock parse:[OCMArg any]])).andReturn(expectedResult);
    
    id result = [SMAGoogleCoordinatesParser parse:data];
    expect(result).toNot.beNil();
    expect(result).to.equal(expectedResult);
}

@end
