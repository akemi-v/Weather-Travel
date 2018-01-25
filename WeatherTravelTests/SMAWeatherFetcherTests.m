//
//  SMAWeatherFetcherTests.m
//  WeatherTravelTests
//
//  Created by Maria Semakova on 1/19/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>

#import "SMAWeatherFetcher.h"
#import "SMADarkSkyCurrentWeatherRequest.h"
#import "SMADarkSkyCurrentWeatherParser.h"

@interface SMAWeatherFetcherTests : XCTestCase

@property (nonatomic, strong) SMAWeatherFetcher *fetcher;

@end

@implementation SMAWeatherFetcherTests

- (void)setUp
{
    [super setUp];
    self.fetcher = OCMPartialMock([SMAWeatherFetcher new]);
}

- (void)tearDown
{
    self.fetcher = nil;
    [super tearDown];
}

- (void)testGetWeatherFromCoordinatesRequestNil
{
    NSDictionary *coordinates = @{@"coo": @"rdinates"};
    id request = OCMClassMock([SMADarkSkyCurrentWeatherRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:[OCMArg any]])).andReturn(nil);
    [self.fetcher getWeatherFromCoordinates:coordinates completion:nil];
    OCMVerify(ClassMethod([request getUrlRequestWithParameters:coordinates]));
    
    [request stopMocking];
}

- (void)testGetWeatherFromCoordinates
{
    NSDictionary *coordinates = @{@"coo": @"rdinates"};
    
    id request = OCMClassMock([SMADarkSkyCurrentWeatherRequest class]);
    id urlRequest = OCMClassMock([NSURLRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:[OCMArg any]])).andReturn(urlRequest);
    
    id configuration = OCMClassMock([NSURLSessionConfiguration class]);
    OCMStub(ClassMethod([configuration defaultSessionConfiguration])).andReturn(configuration);
    
    id session = OCMClassMock([NSURLSession class]);
    OCMStub(ClassMethod([session sessionWithConfiguration:configuration])).andReturn(session);
    
    id sessionDataTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([session dataTaskWithRequest:urlRequest completionHandler:[OCMArg any]]).andReturn(sessionDataTask);
    
    [self.fetcher getWeatherFromCoordinates:coordinates completion:nil];
    
    OCMVerify([sessionDataTask resume]);
    
    [request stopMocking];
    [urlRequest stopMocking];
    [configuration stopMocking];
    [session stopMocking];
    [sessionDataTask stopMocking];
}

- (void)testGetWeatherFromCoordinatesReceivedDataNil
{
    NSDictionary *coordinates = @{@"coo": @"rdinates"};
    
    id request = OCMClassMock([SMADarkSkyCurrentWeatherRequest class]);
    id urlRequest = OCMClassMock([NSURLRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:[OCMArg any]])).andReturn(urlRequest);
    
    id configuration = OCMClassMock([NSURLSessionConfiguration class]);
    OCMStub(ClassMethod([configuration defaultSessionConfiguration])).andReturn(configuration);
    
    id session = OCMClassMock([NSURLSession class]);
    OCMStub(ClassMethod([session sessionWithConfiguration:configuration])).andReturn(session);
    
    id error = OCMPartialMock([NSError new]);
    OCMStub([error localizedDescription]).andReturn(nil);
    
    id sessionDataTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([session dataTaskWithRequest:urlRequest completionHandler:([OCMArg invokeBlockWithArgs:[NSNull null], [OCMArg any], error, nil])]).andReturn(sessionDataTask);
    
    id parser = OCMClassMock([SMADarkSkyCurrentWeatherParser class]);
    OCMStub(ClassMethod([parser parse:[OCMArg any]]));
    
    __block BOOL isCalled = NO;
    __block NSDictionary *weatherInfo = nil;
    [self.fetcher getWeatherFromCoordinates:coordinates completion:^(NSDictionary *weatherData) {
        isCalled = YES;
        weatherInfo = weatherData;
    }];
    
    OCMVerify([sessionDataTask resume]);
    OCMVerify([error localizedDescription]);
    OCMReject([parser parse:[OCMArg any]]);
    expect(weatherInfo).to.beNil();
    expect(isCalled).to.beFalsy();
    
    [request stopMocking];
    [urlRequest stopMocking];
    [configuration stopMocking];
    [session stopMocking];
    [error stopMocking];
    [sessionDataTask stopMocking];
    [parser stopMocking];
}

- (void)testGetWeatherFromCoordinatesReceivedDataCorrect
{
    NSDictionary *coordinates = @{@"coo": @"rdinates"};
    
    id request = OCMClassMock([SMADarkSkyCurrentWeatherRequest class]);
    id urlRequest = OCMClassMock([NSURLRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:[OCMArg any]])).andReturn(urlRequest);
    
    id configuration = OCMClassMock([NSURLSessionConfiguration class]);
    OCMStub(ClassMethod([configuration defaultSessionConfiguration])).andReturn(configuration);
    
    id session = OCMClassMock([NSURLSession class]);
    OCMStub(ClassMethod([session sessionWithConfiguration:configuration])).andReturn(session);
    
    id sessionDataTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([session dataTaskWithRequest:urlRequest completionHandler:([OCMArg invokeBlockWithArgs:[OCMArg isNotNil], [OCMArg any], [NSNull null], nil])]).andReturn(sessionDataTask);
    
    NSDictionary *expectedResult = @{@"expected": @"result"};
    id parser = OCMClassMock([SMADarkSkyCurrentWeatherParser class]);
    OCMStub(ClassMethod([parser parse:[OCMArg any]])).andReturn(expectedResult);
    
    __block BOOL isCalled = NO;
    __block NSDictionary *result = nil;
    [self.fetcher getWeatherFromCoordinates:coordinates completion:^(NSDictionary *weatherData) {
        isCalled = YES;
        result = weatherData;
    }];
    
    OCMVerify([sessionDataTask resume]);
    expect(result).to.equal(expectedResult);
    expect(isCalled).to.beTruthy();
    
    [request stopMocking];
    [urlRequest stopMocking];
    [configuration stopMocking];
    [session stopMocking];
    [sessionDataTask stopMocking];
    [parser stopMocking];
}


- (void)testGetWeatherFromCoordinatesReceivedDataIncorrect
{
    NSDictionary *coordinates = @{@"coo": @"rdinates"};
    
    id request = OCMClassMock([SMADarkSkyCurrentWeatherRequest class]);
    id urlRequest = OCMClassMock([NSURLRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:[OCMArg any]])).andReturn(urlRequest);
    
    id configuration = OCMClassMock([NSURLSessionConfiguration class]);
    OCMStub(ClassMethod([configuration defaultSessionConfiguration])).andReturn(configuration);
    
    id session = OCMClassMock([NSURLSession class]);
    OCMStub(ClassMethod([session sessionWithConfiguration:configuration])).andReturn(session);
    
    id sessionDataTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([session dataTaskWithRequest:urlRequest completionHandler:([OCMArg invokeBlockWithArgs:[OCMArg isNotNil], [OCMArg any], [NSNull null], nil])]).andReturn(sessionDataTask);
    
    id parser = OCMClassMock([SMADarkSkyCurrentWeatherParser class]);
    OCMStub(ClassMethod([parser parse:[OCMArg any]])).andReturn(nil);
    
    __block BOOL isCalled = NO;
    __block NSDictionary *result = nil;
    [self.fetcher getWeatherFromCoordinates:coordinates completion:^(NSDictionary *weatherData) {
        isCalled = YES;
        result = weatherData;
    }];
    
    OCMVerify([sessionDataTask resume]);
    expect(result).to.beNil();
    expect(isCalled).to.beTruthy();
    
    [request stopMocking];
    [urlRequest stopMocking];
    [configuration stopMocking];
    [session stopMocking];
    [sessionDataTask stopMocking];
    [parser stopMocking];
}

@end
