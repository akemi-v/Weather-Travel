//
//  SMADarkSkyCurrentWeatherParserTests.m
//  WeatherTravelTests
//
//  Created by Maria Semakova on 1/19/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>

#import "SMADarkSkyCurrentWeatherParser.h"


@interface SMADarkSkyCurrentWeatherParserTests : XCTestCase

@property (nonatomic, strong) SMADarkSkyCurrentWeatherParser *parser;

@end

@implementation SMADarkSkyCurrentWeatherParserTests

- (void)setUp
{
    [super setUp];
    self.parser = OCMPartialMock([SMADarkSkyCurrentWeatherParser new]);
}

- (void)tearDown
{
    self.parser = nil;
    [super tearDown];
}

- (void)testParseNil
{
    NSData *data = nil;
    id classMock = OCMClassMock([SMADarkSkyCurrentWeatherParser class]);
    OCMStub(ClassMethod([classMock parse:[OCMArg any]])).andReturn(nil);

    id result = [SMADarkSkyCurrentWeatherParser parse:data];
    expect(result).to.beNil();
}

- (void)testParseWrong
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"wrong": @"wrong"} options:0 error:nil];
    id classMock = OCMClassMock([SMADarkSkyCurrentWeatherParser class]);
    OCMStub(ClassMethod([classMock parse:[OCMArg any]])).andReturn(nil);
    
    id result = [SMADarkSkyCurrentWeatherParser parse:data];
    expect(result).to.beNil();
}

- (void)testParseReal
{
    NSDictionary *dataToParse = @{
                                     @"currently": @{
                                             @"icon": @"partly-cloudy-night",
                                             @"temperature": @"5.26",
                                             @"humidity": @"0.56"
                                             }
                                     };
    NSDictionary *expectedResult = @{
                                     @"temperature": @"5.3",
                                     @"humidity": @"56",
                                     @"summary_weather": @"partly,cloudy,night"
                                     };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataToParse options:0 error:nil];
    id classMock = OCMClassMock([SMADarkSkyCurrentWeatherParser class]);
    OCMStub(ClassMethod([classMock parse:[OCMArg any]])).andReturn(expectedResult);
    
    id result = [SMADarkSkyCurrentWeatherParser parse:data];
    expect(result).toNot.beNil();
    expect(result).to.equal(expectedResult);
}

@end
