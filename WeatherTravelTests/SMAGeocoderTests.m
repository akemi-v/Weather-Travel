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
    id mockSession = OCMPartialMock([NSURLSession new]);
    OCMStub([mockSession dataTaskWithRequest:OCMOCK_ANY completionHandler:OCMOCK_ANY]);
    
    __block NSDictionary *coords = nil;
    __block BOOL isCalled = NO;
    [self.mockGeocoder getCoordinatesFromCityName:nil completion:^(NSDictionary *coordinates) {
        isCalled = YES;
        coords = coordinates;
    }];
    
    OCMReject([mockSession dataTaskWithRequest:OCMOCK_ANY completionHandler:OCMOCK_ANY]);
    expect(isCalled).to.beFalsy();
    expect(coords).to.beNil();
}

- (void)testGetCoordinatesFromCityNameRequestNil
{
    id mockRequestClass = OCMClassMock([SMAGoogleCoordinatesRequest class]);
    OCMStub([mockRequestClass getUrlRequestWithParameters:OCMOCK_ANY]).andReturn(nil);
    
    id mockSession = OCMPartialMock([NSURLSession new]);
    OCMStub([mockSession dataTaskWithRequest:OCMOCK_ANY completionHandler:OCMOCK_ANY]);
    
    __block NSDictionary *coords = nil;
    __block BOOL isCalled = NO;
    [self.mockGeocoder getCoordinatesFromCityName:@"" completion:^(NSDictionary *coordinates) {
        isCalled = YES;
        coords = coordinates;
    }];
    
    OCMReject([mockSession dataTaskWithRequest:OCMOCK_ANY completionHandler:OCMOCK_ANY]);
    expect(isCalled).to.beFalsy();
    expect(coords).to.beNil();
}



- (void)testGetCoordinatesFromCityNameReal
{
    NSString *cityName = @"Лондон";
    
    __block BOOL isCalled = NO;
    __block NSDictionary *coords = nil;
    [self.mockGeocoder getCoordinatesFromCityName:cityName completion:^(NSDictionary *coordinates) {
        isCalled = YES;
        coords = coordinates;
    }];
    expect(isCalled).after(2).to.beTruthy();
    expect(coords).toNot.beNil();
}

@end
