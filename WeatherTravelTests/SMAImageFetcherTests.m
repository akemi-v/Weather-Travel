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
#import "SMAFlickrImageRequest.h"
#import "SMAFlickrImageParser.h"


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

- (void)testGetImageURLsWithParameters
{
    OCMStub([self.fetcher getImageWithPlaceWeatherGroupRequest:[OCMArg any] completion:[OCMArg any]]).andDo(nil);
    [self.fetcher getImageURLsWithParameters:nil completion:nil];
    OCMVerify([self.fetcher getImageWithPlaceWeatherGroupRequest:[OCMArg any] completion:[OCMArg any]]);
}

- (void)testGetImageWithPlaceWeatherGroupRequestNil
{
    NSDictionary *parameters = @{@"para": @"meters"};
    id request = OCMClassMock([SMAFlickrImageRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:[OCMArg any]])).andReturn(nil);
    [self.fetcher getImageWithPlaceWeatherGroupRequest:parameters completion:nil];
    OCMVerify(ClassMethod([request getUrlRequestWithParameters:parameters]));
    
    [request stopMocking];
}

- (void)testGetImageWithPlaceWeatherGroupRequest
{
    NSDictionary *parameters = @{@"para": @"meters"};
    
    id request = OCMClassMock([SMAFlickrImageRequest class]);
    id urlRequest = OCMClassMock([NSURLRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:[OCMArg any]])).andReturn(urlRequest);
    
    id configuration = OCMClassMock([NSURLSessionConfiguration class]);
    OCMStub(ClassMethod([configuration defaultSessionConfiguration])).andReturn(configuration);
    
    id session = OCMClassMock([NSURLSession class]);
    OCMStub(ClassMethod([session sessionWithConfiguration:configuration])).andReturn(session);
    
    id sessionDataTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([session dataTaskWithRequest:urlRequest completionHandler:[OCMArg any]]).andReturn(sessionDataTask);
    
    [self.fetcher getImageWithPlaceWeatherGroupRequest:parameters completion:nil];
    
    OCMVerify([sessionDataTask resume]);
    
    [request stopMocking];
    [urlRequest stopMocking];
    [configuration stopMocking];
    [session stopMocking];
    [sessionDataTask stopMocking];
}

- (void)testGetImageWithPlaceWeatherGroupRequestReceivedDataNil
{
    NSDictionary *parameters = @{@"para": @"meters"};
    
    id request = OCMClassMock([SMAFlickrImageRequest class]);
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
    
    id parser = OCMClassMock([SMAFlickrImageParser class]);
    OCMStub(ClassMethod([parser parse:[OCMArg any]]));
    
    __block BOOL isCalled = NO;
    __block NSDictionary *result = nil;
        [self.fetcher getImageWithPlaceWeatherGroupRequest:parameters completion:^(NSDictionary *imageURLs) {
            isCalled = YES;
            result = imageURLs;
        }];
    
    OCMVerify([sessionDataTask resume]);
    OCMVerify([error localizedDescription]);
    OCMReject([parser parse:[OCMArg any]]);
    expect(result).to.beNil();
    expect(isCalled).to.beFalsy();
    
    [request stopMocking];
    [urlRequest stopMocking];
    [configuration stopMocking];
    [session stopMocking];
    [error stopMocking];
    [sessionDataTask stopMocking];
    [parser stopMocking];
}

- (void)testGetImageWithPlaceWeatherGroupRequestReceivedDataCorrect
{
    NSDictionary *parameters = @{@"para": @"meters"};
    
    id request = OCMClassMock([SMAFlickrImageRequest class]);
    id urlRequest = OCMClassMock([NSURLRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:[OCMArg any]])).andReturn(urlRequest);
    
    id configuration = OCMClassMock([NSURLSessionConfiguration class]);
    OCMStub(ClassMethod([configuration defaultSessionConfiguration])).andReturn(configuration);
    
    id session = OCMClassMock([NSURLSession class]);
    OCMStub(ClassMethod([session sessionWithConfiguration:configuration])).andReturn(session);
    
    id sessionDataTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([session dataTaskWithRequest:urlRequest completionHandler:([OCMArg invokeBlockWithArgs:[OCMArg isNotNil], [OCMArg any], [NSNull null], nil])]).andReturn(sessionDataTask);
    
    NSDictionary *expectedResult = @{@"expected": @"result"};
    id parser = OCMClassMock([SMAFlickrImageParser class]);
    OCMStub(ClassMethod([parser parse:[OCMArg any]])).andReturn(expectedResult);
    
    __block BOOL isCalled = NO;
    __block NSDictionary *result = nil;
    [self.fetcher getImageWithPlaceWeatherGroupRequest:parameters completion:^(NSDictionary *imageUrls) {
        isCalled = YES;
        result = imageUrls;
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

- (void)testGetImageWithPlaceWeatherGroupRequestReceivedDataIncorrect
{
    NSDictionary *parameters = @{@"para": @"meters"};
    
    id request = OCMClassMock([SMAFlickrImageRequest class]);
    id urlRequest = OCMClassMock([NSURLRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:[OCMArg any]])).andReturn(urlRequest);
    
    id configuration = OCMClassMock([NSURLSessionConfiguration class]);
    OCMStub(ClassMethod([configuration defaultSessionConfiguration])).andReturn(configuration);
    
    id session = OCMClassMock([NSURLSession class]);
    OCMStub(ClassMethod([session sessionWithConfiguration:configuration])).andReturn(session);
    
    id sessionDataTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([session dataTaskWithRequest:urlRequest completionHandler:([OCMArg invokeBlockWithArgs:[OCMArg isNotNil], [OCMArg any], [NSNull null], nil])]).andReturn(sessionDataTask);
    
    id parser = OCMClassMock([SMAFlickrImageParser class]);
    OCMStub(ClassMethod([parser parse:[OCMArg any]])).andReturn(nil);
    
    OCMStub([self.fetcher getImageWithPlaceWeatherRequest:[OCMArg any] completion:[OCMArg any]]).andDo(nil);
    
    __block BOOL isCalled = NO;
    __block NSDictionary *result = nil;
    [self.fetcher getImageWithPlaceWeatherGroupRequest:parameters completion:^(NSDictionary *imageUrls) {
        isCalled = YES;
        result = imageUrls;
    }];
    
    OCMVerify([sessionDataTask resume]);
    OCMVerify([self.fetcher getImageWithPlaceWeatherRequest:[OCMArg any] completion:[OCMArg any]]);
    expect(result).to.beNil();
    expect(isCalled).to.beFalsy();
    
    [request stopMocking];
    [urlRequest stopMocking];
    [configuration stopMocking];
    [session stopMocking];
    [sessionDataTask stopMocking];
    [parser stopMocking];
}
/////////////////////////////////
- (void)testGetImageWithPlaceWeatherRequestNil
{
    NSDictionary *parameters = @{@"para": @"meters"};
    id request = OCMClassMock([SMAFlickrImageRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:[OCMArg any]])).andReturn(nil);
    [self.fetcher getImageWithPlaceWeatherRequest:parameters completion:nil];
    OCMVerify(ClassMethod([request getUrlRequestWithParameters:parameters]));
    
    [request stopMocking];
}

- (void)testGetImageWithPlaceWeatherRequest
{
    NSDictionary *parameters = @{@"para": @"meters"};
    
    id request = OCMClassMock([SMAFlickrImageRequest class]);
    id urlRequest = OCMClassMock([NSURLRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:[OCMArg any]])).andReturn(urlRequest);
    
    id configuration = OCMClassMock([NSURLSessionConfiguration class]);
    OCMStub(ClassMethod([configuration defaultSessionConfiguration])).andReturn(configuration);
    
    id session = OCMClassMock([NSURLSession class]);
    OCMStub(ClassMethod([session sessionWithConfiguration:configuration])).andReturn(session);
    
    id sessionDataTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([session dataTaskWithRequest:urlRequest completionHandler:[OCMArg any]]).andReturn(sessionDataTask);
    
    [self.fetcher getImageWithPlaceWeatherRequest:parameters completion:nil];
    
    OCMVerify([sessionDataTask resume]);
    
    [request stopMocking];
    [urlRequest stopMocking];
    [configuration stopMocking];
    [session stopMocking];
    [sessionDataTask stopMocking];
}

- (void)testGetImageWithPlaceWeatherRequestReceivedDataNil
{
    NSDictionary *parameters = @{@"para": @"meters"};
    
    id request = OCMClassMock([SMAFlickrImageRequest class]);
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
    
    id parser = OCMClassMock([SMAFlickrImageParser class]);
    OCMStub(ClassMethod([parser parse:[OCMArg any]]));
    
    __block BOOL isCalled = NO;
    __block NSDictionary *result = nil;
    [self.fetcher getImageWithPlaceWeatherRequest:parameters completion:^(NSDictionary *imageURLs) {
        isCalled = YES;
        result = imageURLs;
    }];
    
    OCMVerify([sessionDataTask resume]);
    OCMVerify([error localizedDescription]);
    OCMReject([parser parse:[OCMArg any]]);
    expect(result).to.beNil();
    expect(isCalled).to.beFalsy();
    
    [request stopMocking];
    [urlRequest stopMocking];
    [configuration stopMocking];
    [session stopMocking];
    [error stopMocking];
    [sessionDataTask stopMocking];
    [parser stopMocking];
}

- (void)testGetImageWithPlaceWeatherRequestReceivedDataCorrect
{
    NSDictionary *parameters = @{@"para": @"meters"};
    
    id request = OCMClassMock([SMAFlickrImageRequest class]);
    id urlRequest = OCMClassMock([NSURLRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:[OCMArg any]])).andReturn(urlRequest);
    
    id configuration = OCMClassMock([NSURLSessionConfiguration class]);
    OCMStub(ClassMethod([configuration defaultSessionConfiguration])).andReturn(configuration);
    
    id session = OCMClassMock([NSURLSession class]);
    OCMStub(ClassMethod([session sessionWithConfiguration:configuration])).andReturn(session);
    
    id sessionDataTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([session dataTaskWithRequest:urlRequest completionHandler:([OCMArg invokeBlockWithArgs:[OCMArg isNotNil], [OCMArg any], [NSNull null], nil])]).andReturn(sessionDataTask);
    
    NSDictionary *expectedResult = @{@"expected": @"result"};
    id parser = OCMClassMock([SMAFlickrImageParser class]);
    OCMStub(ClassMethod([parser parse:[OCMArg any]])).andReturn(expectedResult);
    
    __block BOOL isCalled = NO;
    __block NSDictionary *result = nil;
    [self.fetcher getImageWithPlaceWeatherRequest:parameters completion:^(NSDictionary *imageUrls) {
        isCalled = YES;
        result = imageUrls;
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

- (void)testGetImageWithPlaceWeatherRequestReceivedDataIncorrect
{
    NSDictionary *parameters = @{@"para": @"meters"};
    
    id request = OCMClassMock([SMAFlickrImageRequest class]);
    id urlRequest = OCMClassMock([NSURLRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:[OCMArg any]])).andReturn(urlRequest);
    
    id configuration = OCMClassMock([NSURLSessionConfiguration class]);
    OCMStub(ClassMethod([configuration defaultSessionConfiguration])).andReturn(configuration);
    
    id session = OCMClassMock([NSURLSession class]);
    OCMStub(ClassMethod([session sessionWithConfiguration:configuration])).andReturn(session);
    
    id sessionDataTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([session dataTaskWithRequest:urlRequest completionHandler:([OCMArg invokeBlockWithArgs:[OCMArg isNotNil], [OCMArg any], [NSNull null], nil])]).andReturn(sessionDataTask);
    
    id parser = OCMClassMock([SMAFlickrImageParser class]);
    OCMStub(ClassMethod([parser parse:[OCMArg any]])).andReturn(nil);
    
    OCMStub([self.fetcher getImageWithPlaceRequest:[OCMArg any] completion:[OCMArg any]]).andDo(nil);
    
    __block BOOL isCalled = NO;
    __block NSDictionary *result = nil;
    [self.fetcher getImageWithPlaceWeatherRequest:parameters completion:^(NSDictionary *imageUrls) {
        isCalled = YES;
        result = imageUrls;
    }];
    
    OCMVerify([sessionDataTask resume]);
    OCMVerify([self.fetcher getImageWithPlaceRequest:[OCMArg any] completion:[OCMArg any]]);
    expect(result).to.beNil();
    expect(isCalled).to.beFalsy();
    
    [request stopMocking];
    [urlRequest stopMocking];
    [configuration stopMocking];
    [session stopMocking];
    [sessionDataTask stopMocking];
    [parser stopMocking];
}
///////////////////////////////
- (void)testGetImageWithPlaceRequestNil
{
    NSDictionary *parameters = @{@"para": @"meters"};
    id request = OCMClassMock([SMAFlickrImageRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:[OCMArg any]])).andReturn(nil);
    [self.fetcher getImageWithPlaceRequest:parameters completion:nil];
    OCMVerify(ClassMethod([request getUrlRequestWithParameters:parameters]));
    
    [request stopMocking];
}

- (void)testGetImageWithPlaceRequest
{
    NSDictionary *parameters = @{@"para": @"meters"};
    
    id request = OCMClassMock([SMAFlickrImageRequest class]);
    id urlRequest = OCMClassMock([NSURLRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:[OCMArg any]])).andReturn(urlRequest);
    
    id configuration = OCMClassMock([NSURLSessionConfiguration class]);
    OCMStub(ClassMethod([configuration defaultSessionConfiguration])).andReturn(configuration);
    
    id session = OCMClassMock([NSURLSession class]);
    OCMStub(ClassMethod([session sessionWithConfiguration:configuration])).andReturn(session);
    
    id sessionDataTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([session dataTaskWithRequest:urlRequest completionHandler:[OCMArg any]]).andReturn(sessionDataTask);
    
    [self.fetcher getImageWithPlaceRequest:parameters completion:nil];
    
    OCMVerify([sessionDataTask resume]);
    
    [request stopMocking];
    [urlRequest stopMocking];
    [configuration stopMocking];
    [session stopMocking];
    [sessionDataTask stopMocking];
}

- (void)testGetImageWithPlaceRequestReceivedDataNil
{
    NSDictionary *parameters = @{@"para": @"meters"};
    
    id request = OCMClassMock([SMAFlickrImageRequest class]);
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
    
    id parser = OCMClassMock([SMAFlickrImageParser class]);
    OCMStub(ClassMethod([parser parse:[OCMArg any]]));
    
    __block BOOL isCalled = NO;
    __block NSDictionary *result = nil;
    [self.fetcher getImageWithPlaceRequest:parameters completion:^(NSDictionary *imageURLs) {
        isCalled = YES;
        result = imageURLs;
    }];
    
    OCMVerify([sessionDataTask resume]);
    OCMVerify([error localizedDescription]);
    OCMReject([parser parse:[OCMArg any]]);
    expect(result).to.beNil();
    expect(isCalled).to.beFalsy();
    
    [request stopMocking];
    [urlRequest stopMocking];
    [configuration stopMocking];
    [session stopMocking];
    [error stopMocking];
    [sessionDataTask stopMocking];
    [parser stopMocking];
}

- (void)testGetImageWithPlaceRequestReceivedDataCorrect
{
    NSDictionary *parameters = @{@"para": @"meters"};
    
    id request = OCMClassMock([SMAFlickrImageRequest class]);
    id urlRequest = OCMClassMock([NSURLRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:[OCMArg any]])).andReturn(urlRequest);
    
    id configuration = OCMClassMock([NSURLSessionConfiguration class]);
    OCMStub(ClassMethod([configuration defaultSessionConfiguration])).andReturn(configuration);
    
    id session = OCMClassMock([NSURLSession class]);
    OCMStub(ClassMethod([session sessionWithConfiguration:configuration])).andReturn(session);
    
    id sessionDataTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([session dataTaskWithRequest:urlRequest completionHandler:([OCMArg invokeBlockWithArgs:[OCMArg isNotNil], [OCMArg any], [NSNull null], nil])]).andReturn(sessionDataTask);
    
    NSDictionary *expectedResult = @{@"expected": @"result"};
    id parser = OCMClassMock([SMAFlickrImageParser class]);
    OCMStub(ClassMethod([parser parse:[OCMArg any]])).andReturn(expectedResult);
    
    __block BOOL isCalled = NO;
    __block NSDictionary *result = nil;
    [self.fetcher getImageWithPlaceRequest:parameters completion:^(NSDictionary *imageUrls) {
        isCalled = YES;
        result = imageUrls;
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

- (void)testGetImageWithPlaceRequestReceivedDataIncorrect
{
    NSDictionary *parameters = @{@"para": @"meters"};
    
    id request = OCMClassMock([SMAFlickrImageRequest class]);
    id urlRequest = OCMClassMock([NSURLRequest class]);
    OCMStub(ClassMethod([request getUrlRequestWithParameters:[OCMArg any]])).andReturn(urlRequest);
    
    id configuration = OCMClassMock([NSURLSessionConfiguration class]);
    OCMStub(ClassMethod([configuration defaultSessionConfiguration])).andReturn(configuration);
    
    id session = OCMClassMock([NSURLSession class]);
    OCMStub(ClassMethod([session sessionWithConfiguration:configuration])).andReturn(session);
    
    id sessionDataTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([session dataTaskWithRequest:urlRequest completionHandler:([OCMArg invokeBlockWithArgs:[OCMArg isNotNil], [OCMArg any], [NSNull null], nil])]).andReturn(sessionDataTask);
    
    id parser = OCMClassMock([SMAFlickrImageParser class]);
    OCMStub(ClassMethod([parser parse:[OCMArg any]])).andReturn(nil);
    
    OCMStub([self.fetcher getImageWithPlaceWeatherRequest:[OCMArg any] completion:[OCMArg any]]);
    
    __block BOOL isCalled = NO;
    __block NSDictionary *result = nil;
    [self.fetcher getImageWithPlaceRequest:parameters completion:^(NSDictionary *imageUrls) {
        isCalled = YES;
        result = imageUrls;
    }];
    
    OCMVerify([sessionDataTask resume]);
    OCMReject([self.fetcher getImageWithPlaceWeatherRequest:[OCMArg any] completion:[OCMArg any]]);
    expect(result).to.beNil();
    expect(isCalled).to.beFalsy();
    
    [request stopMocking];
    [urlRequest stopMocking];
    [configuration stopMocking];
    [session stopMocking];
    [sessionDataTask stopMocking];
    [parser stopMocking];
}

@end
