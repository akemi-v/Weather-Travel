//
//  SMAGeocoderTests.m
//  WeatherTravelTests
//
//  Created by Maria Semakova on 1/19/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

#import "SMAGeocoder.h"
#import "SMAGoogleCoordinatesRequest.h"
#import "SMAGoogleCoordinatesParser.h"


@interface SMAGeocoder(Tests)

- (void)getCoordinatesFromCityName:(NSString *)cityName completion:(void (^)(NSDictionary *coordinates))completionHandler;

@end

@interface SMAGeocoderTests : XCTestCase

@property (nonatomic, strong) SMAGeocoder *mockGeocoder;

@end

@implementation SMAGeocoderTests

- (void)setUp
{
    [super setUp];
    self.mockGeocoder = OCMPartialMock([SMAGeocoder new]);
}

- (void)tearDown
{
    self.mockGeocoder = nil;
    [super tearDown];
}

- (void)testGetCoordinatesFromCityNameCityNameNil
{
    id request = OCMClassMock([SMAGoogleCoordinatesRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:[OCMArg any]]));
    OCMReject(ClassMethod([request getUrlRequestWithParameters:[OCMArg any]]));
    [self.mockGeocoder getCoordinatesFromCityName:nil completion:nil];
}

- (void)testGetCoordinatesFromCityNameRequestNil
{
    NSString *cityName = @"";
    id request = OCMClassMock([SMAGoogleCoordinatesRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:@{@"cityName": cityName}])).andReturn(nil);
    
    [self.mockGeocoder getCoordinatesFromCityName:cityName completion:nil];
    
    OCMVerify(ClassMethod([request getUrlRequestWithParameters:@{@"cityName": cityName}]));
}

- (void)testGetCoordinatesFromCityName
{
    NSString *cityName = @"";
    
    id urlRequest = OCMClassMock([NSURLRequest class]);
    id request = OCMClassMock([SMAGoogleCoordinatesRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:@{@"cityName": cityName}])).andReturn(urlRequest);
    
    id configuration = OCMClassMock([NSURLSessionConfiguration class]);
    OCMStub(ClassMethod([configuration defaultSessionConfiguration])).andReturn(configuration);
    
    id session = OCMClassMock([NSURLSession class]);
    OCMStub(ClassMethod([session sessionWithConfiguration:configuration])).andReturn(session);
    
    id sessionDataTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([session dataTaskWithRequest:urlRequest completionHandler:[OCMArg any]]).andReturn(sessionDataTask);
    
    [self.mockGeocoder getCoordinatesFromCityName:cityName completion:nil];
    
    OCMVerify([sessionDataTask resume]);
    [urlRequest stopMocking];
    [configuration stopMocking];
    [session stopMocking];
}

- (void)testGetCoordinatesFromCityNameWithReceivedDataNil
{
    NSString *cityName = @"";
    
    id urlRequest = OCMClassMock([NSURLRequest class]);
    id request = OCMClassMock([SMAGoogleCoordinatesRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:@{@"cityName": cityName}])).andReturn(urlRequest);
    
    id configuration = OCMClassMock([NSURLSessionConfiguration class]);
    OCMStub(ClassMethod([configuration defaultSessionConfiguration])).andReturn(configuration);
    
    id session = OCMClassMock([NSURLSession class]);
    OCMStub(ClassMethod([session sessionWithConfiguration:configuration])).andReturn(session);
    
    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:400 userInfo:nil];
    id sessionDataTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([session dataTaskWithRequest:urlRequest completionHandler:([OCMArg invokeBlockWithArgs:[NSNull null], [OCMArg any], error, nil])]).andReturn(sessionDataTask);

    id parser = OCMClassMock([SMAGoogleCoordinatesParser class]);
    OCMStub(ClassMethod([parser parse:[OCMArg any]]));
    
    __block NSDictionary *coords = nil;
    __block BOOL isCalled = NO;
    [self.mockGeocoder getCoordinatesFromCityName:cityName completion:^(NSDictionary *coordinates) {
        isCalled = YES;
        coords = coordinates;
    }];
    
    OCMVerify([sessionDataTask resume]);
    OCMReject([parser parse:[OCMArg any]]);
    expect(coords).to.beNil();
    expect(isCalled).to.beFalsy();
    [urlRequest stopMocking];
    [configuration stopMocking];
    [session stopMocking];
}

- (void)testGetCoordinatesFromCityNameWithReceivedDataCorrect
{
    NSString *cityName = @"";
    
    id urlRequest = OCMClassMock([NSURLRequest class]);
    id request = OCMClassMock([SMAGoogleCoordinatesRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:@{@"cityName": cityName}])).andReturn(urlRequest);
    
    id configuration = OCMClassMock([NSURLSessionConfiguration class]);
    OCMStub(ClassMethod([configuration defaultSessionConfiguration])).andReturn(configuration);
    
    id session = OCMClassMock([NSURLSession class]);
    OCMStub(ClassMethod([session sessionWithConfiguration:configuration])).andReturn(session);
    
    id sessionDataTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([session dataTaskWithRequest:urlRequest completionHandler:([OCMArg invokeBlockWithArgs:[OCMArg isNotNil], [OCMArg any], [NSNull null], nil])]).andReturn(sessionDataTask);
    
    NSDictionary *expectedResult = @{@"result": @"23"};
    id parser = OCMClassMock([SMAGoogleCoordinatesParser class]);
    OCMStub(ClassMethod([parser parse:[OCMArg any]])).andReturn(expectedResult);
    
    __block NSDictionary *result = nil;
    __block BOOL isCalled = NO;
    [self.mockGeocoder getCoordinatesFromCityName:cityName completion:^(NSDictionary *coordinates) {
        isCalled = YES;
        result = coordinates;
    }];
    
    OCMVerify([sessionDataTask resume]);
    expect(result).to.equal(expectedResult);
    expect(isCalled).to.beTruthy();
    [urlRequest stopMocking];
    [configuration stopMocking];
    [session stopMocking];
}

- (void)testGetCoordinatesFromCityNameWithReceivedDataIncorrect
{
    NSString *cityName = @"";
    
    id urlRequest = OCMClassMock([NSURLRequest class]);
    id request = OCMClassMock([SMAGoogleCoordinatesRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:@{@"cityName": cityName}])).andReturn(urlRequest);
    
    id configuration = OCMClassMock([NSURLSessionConfiguration class]);
    OCMStub(ClassMethod([configuration defaultSessionConfiguration])).andReturn(configuration);
    
    id session = OCMClassMock([NSURLSession class]);
    OCMStub(ClassMethod([session sessionWithConfiguration:configuration])).andReturn(session);
    
    id sessionDataTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([session dataTaskWithRequest:urlRequest completionHandler:([OCMArg invokeBlockWithArgs:[OCMArg isNotNil], [OCMArg any], [NSNull null], nil])]).andReturn(sessionDataTask);
    
    id parser = OCMClassMock([SMAGoogleCoordinatesParser class]);
    OCMStub(ClassMethod([parser parse:[OCMArg any]])).andReturn(nil);
    
    __block NSDictionary *result = nil;
    __block BOOL isCalled = NO;
    [self.mockGeocoder getCoordinatesFromCityName:cityName completion:^(NSDictionary *coordinates) {
        isCalled = YES;
        result = coordinates;
    }];
    
    OCMVerify([sessionDataTask resume]);
    expect(result).to.beNil();
    expect(isCalled).to.beTruthy();
    [urlRequest stopMocking];
    [configuration stopMocking];
    [session stopMocking];
}

@end
