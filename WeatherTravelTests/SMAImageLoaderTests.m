//
//  SMAImageLoaderTests.m
//  WeatherTravelTests
//
//  Created by Maria Semakova on 1/19/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>

#import "SMAImageLoader.h"

@interface SMAImageLoader(Tests)

- (NSString *)randomId;

@end

@interface SMAImageLoaderTests : XCTestCase

@property (nonatomic, strong) SMAImageLoader *loader;

@end

@implementation SMAImageLoaderTests

- (void)setUp
{
    [super setUp];
    self.loader = OCMPartialMock([SMAImageLoader new]);
}

- (void)tearDown
{
    self.loader = nil;
    [super tearDown];
}

- (void)testLoadImageFromRemoteURLWrong
{
    NSString *urlString = @"sdfsdf";
    
    __block BOOL isCalled = NO;
    __block UIImage *img = nil;
    [self.loader loadImageFromRemoteURL:urlString completion:^(UIImage *image) {
        isCalled = YES;
        img = image;
    }];
    expect(isCalled).after(5).to.beFalsy();
    expect(img).after(5).to.beNil();
}

- (void)testLoadImageFromRemoteURLNotImage
{
    NSString *urlString = @"https://github.com";
    
    __block BOOL isCalled = NO;
    __block UIImage *img = nil;
    [self.loader loadImageFromRemoteURL:urlString completion:^(UIImage *image) {
        isCalled = YES;
        img = image;
    }];
    expect(isCalled).after(5).to.beTruthy();
    expect(img).after(5).to.beNil();
}

- (void)testLoadImageFromRemoteURLDirectLink
{
    NSString *urlString = @"https://s14.postimg.org/b984nbxk1/DR5_Nkt6_VAAANRii.jpg";
    
    __block BOOL isCalled = NO;
    __block UIImage *img = nil;
    [self.loader loadImageFromRemoteURL:urlString completion:^(UIImage *image) {
        isCalled = YES;
        img = image;
    }];
    expect(isCalled).after(5).to.beTruthy();
    expect(img).after(5).toNot.beNil();
}

- (void)testLoadImageFromFileURLWrong
{
    NSString *urlString = @"sdfsdf";
    
    __block BOOL isCalled = NO;
    __block UIImage *img = nil;
    [self.loader loadImageFromFileURL:urlString completion:^(UIImage *image) {
        isCalled = YES;
        img = image;
    }];
    expect(isCalled).after(5).to.beFalsy();
    expect(img).after(5).to.beNil();
}

- (void)testRandomId
{
    NSString *idString = nil;
    idString = [self.loader randomId];
    expect(idString).toNot.beNil();
}

@end
