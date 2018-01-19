//
//  SMAImageFetcherTests.m
//  WeatherTravelTests
//
//  Created by Maria Semakova on 1/19/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>

#import "SMAImageFetcher.h"


@interface SMAImageFetcher(Tests)

- (void)getImageWithPlaceWeatherGroupRequest:(NSDictionary *)parameters completion:(void (^)(NSDictionary *imageURLs))completionHandler;
- (void)getImageWithPlaceWeatherRequest:(NSDictionary *)parameters completion:(void (^)(NSDictionary *imageURLs))completionHandler;
- (void)getImageWithPlaceRequest:(NSDictionary *)parameters completion:(void (^)(NSDictionary *imageURLs))completionHandler;

@end

@interface SMAImageFetcherTests : XCTestCase

@property (nonatomic, strong) SMAImageFetcher *fetcher;

@end

@implementation SMAImageFetcherTests

- (void)setUp
{
    [super setUp];
    self.fetcher = OCMPartialMock([SMAImageFetcher new]);
}

- (void)tearDown
{
    self.fetcher = nil;
    [super tearDown];
}

- (void)testGetImageURLsWithParametersNil
{
    NSDictionary *parameters = nil;
    
    __block BOOL isCalled = NO;
    __block NSDictionary *urls = nil;
    [self.fetcher getImageURLsWithParameters:parameters completion:^(NSDictionary *imageURLs) {
        isCalled = YES;
        urls = imageURLs;
    }];
    expect(isCalled).after(5).to.beFalsy();
    expect(urls).after(5).to.beNil();
}

- (void)testGetImageURLsWithParametersWrong
{
    NSDictionary *parameters = @{
                                 @"lng": @"139.692",
                                 @"lat": @"35.6895"
                                 };;
    
    __block BOOL isCalled = NO;
    __block NSDictionary *urls = nil;
    [self.fetcher getImageURLsWithParameters:parameters completion:^(NSDictionary *imageURLs) {
        isCalled = YES;
        urls = imageURLs;
    }];
    expect(isCalled).after(5).to.beFalsy();
    expect(urls).after(5).to.beNil();
}

- (void)testGetImageURLsWithParametersReal
{
    NSDictionary *parameters = @{
                                 @"humidity": @"100",
                                 @"temperature": @"100",
                                 @"summary_weather": @"cloudy",
                                 @"city": @"Los Angeles"
                                 };
    NSSet *expectedKeys = [NSSet setWithArray:@[@"url_orig", @"url_square"]];
    
    __block BOOL isCalled = NO;
    __block NSDictionary *urls = nil;
    [self.fetcher getImageURLsWithParameters:parameters completion:^(NSDictionary *imageURLs) {
        isCalled = YES;
        urls = imageURLs;
    }];
    expect(isCalled).after(5).to.beTruthy();
    expect(urls).after(5).toNot.beNil();
    expect([NSSet setWithArray:[urls allKeys]]).equal(expectedKeys);
}

- (void)testGetImageWithPlaceWeatherGroupRequestWithParametersNil
{
    NSDictionary *parameters = nil;
    
    __block BOOL isCalled = NO;
    __block NSDictionary *urls = nil;
    [self.fetcher getImageWithPlaceWeatherGroupRequest:parameters completion:^(NSDictionary *imageURLs) {
        isCalled = YES;
        urls = imageURLs;
    }];
    expect(isCalled).after(5).to.beFalsy();
    expect(urls).after(5).to.beNil();
}

- (void)testGetImageWithPlaceWeatherGroupRequestWithParametersWrong
{
    NSDictionary *parameters = @{
                                 @"wrong": @"wrong"
                                 };;
    
    __block BOOL isCalled = NO;
    __block NSDictionary *urls = nil;
    [self.fetcher getImageWithPlaceWeatherGroupRequest:parameters completion:^(NSDictionary *imageURLs) {
        isCalled = YES;
        urls = imageURLs;
    }];
    expect(isCalled).after(5).to.beFalsy();
    expect(urls).after(5).to.beNil();
}

- (void)testGetImageWithPlaceWeatherGroupRequestWithParametersReal
{
    NSDictionary *parameters = @{
                                 @"humidity": @"100",
                                 @"temperature": @"100",
                                 @"summary_weather": @"cloudy",
                                 @"city": @"Los Angeles",
                                 @"mode": @0
                                 };
    NSSet *expectedKeys = [NSSet setWithArray:@[@"url_orig", @"url_square"]];
    
    __block BOOL isCalled = NO;
    __block NSDictionary *urls = nil;
    [self.fetcher getImageWithPlaceWeatherGroupRequest:parameters completion:^(NSDictionary *imageURLs) {
        isCalled = YES;
        urls = imageURLs;
    }];
    expect(isCalled).after(5).to.beTruthy();
    expect(urls).after(5).toNot.beNil();
    expect([NSSet setWithArray:[urls allKeys]]).equal(expectedKeys);
}

- (void)testGetImageWithPlaceWeatherRequestWithParametersNil
{
    NSDictionary *parameters = nil;
    
    __block BOOL isCalled = NO;
    __block NSDictionary *urls = nil;
    [self.fetcher getImageWithPlaceWeatherRequest:parameters completion:^(NSDictionary *imageURLs) {
        isCalled = YES;
        urls = imageURLs;
    }];
    expect(isCalled).after(5).to.beFalsy();
    expect(urls).after(5).to.beNil();
}

- (void)testGetImageWithPlaceWeatherRequestWithParametersWrong
{
    NSDictionary *parameters = @{
                                 @"wrong": @"wrong"
                                 };;
    
    __block BOOL isCalled = NO;
    __block NSDictionary *urls = nil;
    [self.fetcher getImageWithPlaceWeatherRequest:parameters completion:^(NSDictionary *imageURLs) {
        isCalled = YES;
        urls = imageURLs;
    }];
    expect(isCalled).after(5).to.beFalsy();
    expect(urls).after(5).to.beNil();
}

- (void)testGetImageWithPlaceWeatherRequestWithParametersReal
{
    NSDictionary *parameters = @{
                                 @"humidity": @"100",
                                 @"temperature": @"100",
                                 @"summary_weather": @"cloudy",
                                 @"city": @"Los Angeles",
                                 @"mode": @0
                                 };
    NSSet *expectedKeys = [NSSet setWithArray:@[@"url_orig", @"url_square"]];
    
    __block BOOL isCalled = NO;
    __block NSDictionary *urls = nil;
    [self.fetcher getImageWithPlaceWeatherGroupRequest:parameters completion:^(NSDictionary *imageURLs) {
        isCalled = YES;
        urls = imageURLs;
    }];
    expect(isCalled).after(5).to.beTruthy();
    expect(urls).after(5).toNot.beNil();
    expect([NSSet setWithArray:[urls allKeys]]).equal(expectedKeys);
}

- (void)testGetImageWithPlaceRequestWithParametersNil
{
    NSDictionary *parameters = nil;
    
    __block BOOL isCalled = NO;
    __block NSDictionary *urls = nil;
    [self.fetcher getImageWithPlaceRequest:parameters completion:^(NSDictionary *imageURLs) {
        isCalled = YES;
        urls = imageURLs;
    }];
    expect(isCalled).after(5).to.beFalsy();
    expect(urls).after(5).to.beNil();
}

- (void)testGetImageWithPlaceRequestWithParametersWrong
{
    NSDictionary *parameters = @{
                                 @"wrong": @"wrong"
                                 };;
    
    __block BOOL isCalled = NO;
    __block NSDictionary *urls = nil;
    [self.fetcher getImageWithPlaceRequest:parameters completion:^(NSDictionary *imageURLs) {
        isCalled = YES;
        urls = imageURLs;
    }];
    expect(isCalled).after(5).to.beFalsy();
    expect(urls).after(5).to.beNil();
}

- (void)testGetImageWithPlaceRequestWithParametersReal
{
    NSDictionary *parameters = @{
                                 @"humidity": @"100",
                                 @"temperature": @"100",
                                 @"summary_weather": @"cloudy",
                                 @"city": @"Los Angeles",
                                 @"mode": @0
                                 };
    NSSet *expectedKeys = [NSSet setWithArray:@[@"url_orig", @"url_square"]];
    
    __block BOOL isCalled = NO;
    __block NSDictionary *urls = nil;
    [self.fetcher getImageWithPlaceWeatherRequest:parameters completion:^(NSDictionary *imageURLs) {
        isCalled = YES;
        urls = imageURLs;
    }];
    expect(isCalled).after(5).to.beTruthy();
    expect(urls).after(5).toNot.beNil();
    expect([NSSet setWithArray:[urls allKeys]]).equal(expectedKeys);
}

@end
