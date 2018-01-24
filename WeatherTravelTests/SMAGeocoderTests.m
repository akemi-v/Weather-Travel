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

- (void)testGetCoordinatesFromCityNameNil
{
    __block NSDictionary *coords = nil;
    __block BOOL isCalled = NO;
    [self.mockGeocoder getCoordinatesFromCityName:nil completion:^(NSDictionary *coordinates) {
        isCalled = YES;
        coords = coordinates;
    }];
    
    expect(isCalled).to.beFalsy();
    expect(coords).to.beNil();
}

- (void)testGetCoordinatesFromCityNameWhenRequestNil
{
    id mockRequestClass = OCMClassMock([SMAGoogleCoordinatesRequest class]);
    OCMStub([mockRequestClass getUrlRequestWithParameters:OCMOCK_ANY]).andReturn(nil);
    
    __block NSDictionary *coords = nil;
    __block BOOL isCalled = NO;
    [self.mockGeocoder getCoordinatesFromCityName:@"" completion:^(NSDictionary *coordinates) {
        isCalled = YES;
        coords = coordinates;
    }];
    
    expect(isCalled).to.beFalsy();
    expect(coords).to.beNil();
}

- (void)testGetCoordinatesFromCityNameWhenReceivedDataNil
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host isEqualToString:@"maps.googleapis.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:400 userInfo:nil];
        return [OHHTTPStubsResponse responseWithError:error];
    }];
    
    __block NSDictionary *coords = nil;
    __block BOOL isCalled = NO;
    
    [self.mockGeocoder getCoordinatesFromCityName:@"" completion:^(NSDictionary *coordinates) {
        isCalled = YES;
        coords = coordinates;
    }];
    
    expect(isCalled).after(5).to.beFalsy();
    expect(coords).after(5).to.beNil();
}

- (void)testGetCoordinatesFromCityNameWhenReceivedWrongData
{
    NSDictionary *expectedResult = @{@"wrong": @"23"};
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host isEqualToString:@"maps.googleapis.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:expectedResult options:0 error:nil];
        return [OHHTTPStubsResponse responseWithData:data statusCode:200 headers:nil];
    }];
    
    __block NSDictionary *coords = nil;
    __block BOOL isCalled = NO;
    
    [self.mockGeocoder getCoordinatesFromCityName:@"" completion:^(NSDictionary *coordinates) {
        isCalled = YES;
        coords = coordinates;
    }];
    
    expect(isCalled).after(5).to.beTruthy();
    expect(coords).after(5).to.beNil();
}

- (void)testGetCoordinatesFromCityNameWhenDataParsedSuccessfully
{
    NSDictionary *expectedResult = @{@"result": @"23"};
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host isEqualToString:@"maps.googleapis.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:expectedResult options:0 error:nil];
        return [OHHTTPStubsResponse responseWithData:data statusCode:200 headers:nil];
    }];
    
    id mockParserClass = OCMClassMock([SMAGoogleCoordinatesParser class]);
    OCMStub([mockParserClass parse:OCMOCK_ANY]).andReturn(expectedResult);
    
    __block NSDictionary *coords = nil;
    __block BOOL isCalled = NO;
    
    [self.mockGeocoder getCoordinatesFromCityName:@"" completion:^(NSDictionary *coordinates) {
        isCalled = YES;
        coords = coordinates;
    }];
    
    expect(isCalled).after(5).to.beTruthy();
    expect(coords).after(5).toNot.beNil();
    expect(coords).after(5).to.equal(expectedResult);
}

@end
