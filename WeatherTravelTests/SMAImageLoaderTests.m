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
- (NSArray *)getPathForDirectoriesInDomains;
- (NSData *)representationOfImage:(UIImage *)image;

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

- (void)testLoadImageFromRemoteURLNil
{
    id url = OCMClassMock([NSURL class]);
    OCMStub(ClassMethod([url URLWithString:[OCMArg any]])).andReturn(nil);
    
    id request = OCMClassMock([NSURLRequest class]);
    OCMStub(ClassMethod([request requestWithURL:url]));
    OCMReject(ClassMethod([request requestWithURL:url]));
    [self.loader loadImageFromRemoteURL:nil completion:nil];
    
    [url stopMocking];
    [request stopMocking];
}

- (void)testLoadImageFromRemoteURLRequestNil
{
    id url = OCMClassMock([NSURL class]);
    OCMStub(ClassMethod([url URLWithString:[OCMArg any]])).andReturn(url);
    
    id request = OCMClassMock([NSURLRequest class]);
    OCMStub(ClassMethod([request requestWithURL:[OCMArg any]])).andReturn(nil);
    
    [self.loader loadImageFromRemoteURL:nil completion:nil];
    
    OCMVerify(ClassMethod([request requestWithURL:url]));
    
    [url stopMocking];
    [request stopMocking];
}

- (void)testLoadImageFromRemoteURL
{
    id url = OCMClassMock([NSURL class]);
    OCMStub(ClassMethod([url URLWithString:[OCMArg any]])).andReturn(url);
    
    id request = OCMClassMock([NSURLRequest class]);
    OCMStub(ClassMethod([request requestWithURL:[OCMArg any]])).andReturn(request);
    
    id configuration = OCMClassMock([NSURLSessionConfiguration class]);
    OCMStub(ClassMethod([configuration defaultSessionConfiguration])).andReturn(configuration);
    
    id session = OCMClassMock([NSURLSession class]);
    OCMStub(ClassMethod([session sessionWithConfiguration:configuration])).andReturn(session);
    
    id sessionDataTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([session dataTaskWithRequest:request completionHandler:[OCMArg any]]).andReturn(sessionDataTask);
    
    [self.loader loadImageFromRemoteURL:nil completion:nil];
    
    OCMVerify([sessionDataTask resume]);
    
    [url stopMocking];
    [request stopMocking];
    [configuration stopMocking];
    [session stopMocking];
    [sessionDataTask stopMocking];
}

- (void)testLoadImageFromRemoteURLReceivedDataNil
{
    id url = OCMClassMock([NSURL class]);
    OCMStub(ClassMethod([url URLWithString:[OCMArg any]])).andReturn(url);
    
    id request = OCMClassMock([NSURLRequest class]);
    OCMStub(ClassMethod([request requestWithURL:[OCMArg any]])).andReturn(request);
    
    id configuration = OCMClassMock([NSURLSessionConfiguration class]);
    OCMStub(ClassMethod([configuration defaultSessionConfiguration])).andReturn(configuration);
    
    id session = OCMClassMock([NSURLSession class]);
    OCMStub(ClassMethod([session sessionWithConfiguration:configuration])).andReturn(session);
    
    id error = OCMPartialMock([NSError new]);
    OCMStub([error localizedDescription]).andReturn(nil);

    id sessionDataTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([session dataTaskWithRequest:request completionHandler:([OCMArg invokeBlockWithArgs:[NSNull null], [OCMArg any], error, nil])]).andReturn(sessionDataTask);
    
    id image = OCMClassMock([UIImage class]);
    OCMStub(ClassMethod([image imageWithData:[OCMArg any]]));
    
    __block UIImage *result = nil;
    __block BOOL isCalled = NO;
    
    [self.loader loadImageFromRemoteURL:nil completion:^(UIImage *image) {
        isCalled = YES;
        result = image;
    }];
    
    OCMVerify([sessionDataTask resume]);
    OCMVerify([error localizedDescription]);
    OCMReject([image imageWithData:[OCMArg any]]);
    expect(result).to.beNil();
    expect(isCalled).to.beFalsy();
    
    [url stopMocking];
    [request stopMocking];
    [configuration stopMocking];
    [session stopMocking];
    [error stopMocking];
    [sessionDataTask stopMocking];
    [image stopMocking];
}

- (void)testLoadImageFromRemoteURLReceivedDataCorrect
{
    id url = OCMClassMock([NSURL class]);
    OCMStub(ClassMethod([url URLWithString:[OCMArg any]])).andReturn(url);
    
    id request = OCMClassMock([NSURLRequest class]);
    OCMStub(ClassMethod([request requestWithURL:[OCMArg any]])).andReturn(request);
    
    id configuration = OCMClassMock([NSURLSessionConfiguration class]);
    OCMStub(ClassMethod([configuration defaultSessionConfiguration])).andReturn(configuration);
    
    id session = OCMClassMock([NSURLSession class]);
    OCMStub(ClassMethod([session sessionWithConfiguration:configuration])).andReturn(session);
    
    id sessionDataTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([session dataTaskWithRequest:request completionHandler:([OCMArg invokeBlockWithArgs:[OCMArg isNotNil], [OCMArg any], [NSNull null], nil])]).andReturn(sessionDataTask);
    
    UIImage *expectedImage = [UIImage imageNamed:@"search"];
    id image = OCMClassMock([UIImage class]);
    OCMStub(ClassMethod([image imageWithData:[OCMArg any]])).andReturn(expectedImage);
    
    __block UIImage *result = nil;
    __block BOOL isCalled = NO;
    
    [self.loader loadImageFromRemoteURL:nil completion:^(UIImage *image) {
        isCalled = YES;
        result = image;
    }];
    
    OCMVerify([sessionDataTask resume]);
    expect(result).after(5).to.equal(expectedImage);
    expect(isCalled).after(5).to.beTruthy();
    
    [url stopMocking];
    [request stopMocking];
    [configuration stopMocking];
    [session stopMocking];
    [sessionDataTask stopMocking];
    [image stopMocking];
}

- (void)testLoadImageFromRemoteURLReceivedDataIncorrect
{
    id url = OCMClassMock([NSURL class]);
    OCMStub(ClassMethod([url URLWithString:[OCMArg any]])).andReturn(url);
    
    id request = OCMClassMock([NSURLRequest class]);
    OCMStub(ClassMethod([request requestWithURL:[OCMArg any]])).andReturn(request);
    
    id configuration = OCMClassMock([NSURLSessionConfiguration class]);
    OCMStub(ClassMethod([configuration defaultSessionConfiguration])).andReturn(configuration);
    
    id session = OCMClassMock([NSURLSession class]);
    OCMStub(ClassMethod([session sessionWithConfiguration:configuration])).andReturn(session);
    
    id sessionDataTask = OCMClassMock([NSURLSessionDataTask class]);
    OCMStub([session dataTaskWithRequest:request completionHandler:([OCMArg invokeBlockWithArgs:[OCMArg isNotNil], [OCMArg any], [NSNull null], nil])]).andReturn(sessionDataTask);
    
    id image = OCMClassMock([UIImage class]);
    OCMStub(ClassMethod([image imageWithData:[OCMArg any]])).andReturn(nil);
    
    __block UIImage *result = nil;
    __block BOOL isCalled = NO;
    
    [self.loader loadImageFromRemoteURL:nil completion:^(UIImage *image) {
        isCalled = YES;
        result = image;
    }];
    
    OCMVerify([sessionDataTask resume]);
    expect(result).after(5).to.beNil();
    expect(isCalled).after(5).to.beTruthy();
    
    [url stopMocking];
    [request stopMocking];
    [configuration stopMocking];
    [session stopMocking];
    [sessionDataTask stopMocking];
    [image stopMocking];
}

- (void)testLoadImageFromFileURLNil
{
    OCMStub([self.loader getPathForDirectoriesInDomains]).andReturn(nil);
    
    id error = OCMPartialMock([NSError new]);
    id data = OCMClassMock([NSData class]);
    OCMStub(ClassMethod([data dataWithContentsOfFile:[OCMArg any] options:0 error:&error]));
    
    [self.loader loadImageFromFileURL:nil completion:nil];
    
    OCMReject([data dataWithContentsOfFile:[OCMArg any] options:0 error:&error]);
    
    [error stopMocking];
    [data stopMocking];
}

- (void)testLoadImageFromFileURLDataNil
{
    OCMStub([self.loader getPathForDirectoriesInDomains]).andReturn(@[@"path"]);

    id data = OCMClassMock([NSData class]);
    OCMStub(ClassMethod([data dataWithContentsOfFile:[OCMArg any] options:0 error:(NSError * __autoreleasing *)[OCMArg anyPointer]])).andReturn(nil);
    
    id image = OCMClassMock([UIImage class]);
    OCMStub(ClassMethod([image imageWithData:[OCMArg any]]));
    
    [self.loader loadImageFromFileURL:nil completion:nil];
    
    OCMVerify([data dataWithContentsOfFile:[OCMArg any] options:0 error:(NSError * __autoreleasing *)[OCMArg anyPointer]]);
    OCMReject([image imageWithData:[OCMArg any]]);
    
    [data stopMocking];
    [image stopMocking];
}

- (void)testLoadImageFromFileURLReceivedDataCorrect
{
    OCMStub([self.loader getPathForDirectoriesInDomains]).andReturn(@[@"path"]);
    
    id data = OCMClassMock([NSData class]);
    OCMStub(ClassMethod([data dataWithContentsOfFile:[OCMArg any] options:0 error:(NSError * __autoreleasing *)[OCMArg anyPointer]])).andReturn(data);
    
    UIImage *expectedImage = [UIImage imageNamed:@"search"];
    id image = OCMClassMock([UIImage class]);
    OCMStub(ClassMethod([image imageWithData:[OCMArg any]])).andReturn(expectedImage);
    
    __block UIImage *result = nil;
    __block BOOL isCalled = NO;
    
    [self.loader loadImageFromFileURL:nil completion:^(UIImage *image) {
        isCalled = YES;
        result = image;
    }];
    
    OCMVerify([data dataWithContentsOfFile:[OCMArg any] options:0 error:(NSError * __autoreleasing *)[OCMArg anyPointer]]);
    OCMVerify([image imageWithData:[OCMArg any]]);
    expect(result).after(5).to.equal(expectedImage);
    expect(isCalled).after(5).to.beTruthy();
    
    [data stopMocking];
    [image stopMocking];
}

- (void)testLoadImageFromFileURLReceivedDataIncorrect
{
    OCMStub([self.loader getPathForDirectoriesInDomains]).andReturn(@[@"path"]);
    
    id data = OCMClassMock([NSData class]);
    OCMStub(ClassMethod([data dataWithContentsOfFile:[OCMArg any] options:0 error:(NSError * __autoreleasing *)[OCMArg anyPointer]])).andReturn(data);
    
    id image = OCMClassMock([UIImage class]);
    OCMStub(ClassMethod([image imageWithData:[OCMArg any]])).andReturn(nil);
    
    __block UIImage *result = nil;
    __block BOOL isCalled = NO;
    
    [self.loader loadImageFromFileURL:nil completion:^(UIImage *image) {
        isCalled = YES;
        result = image;
    }];
    
    OCMVerify([data dataWithContentsOfFile:[OCMArg any] options:0 error:(NSError * __autoreleasing *)[OCMArg anyPointer]]);
    OCMVerify([image imageWithData:[OCMArg any]]);
    expect(result).after(5).to.beNil();
    expect(isCalled).after(5).to.beTruthy();
    
    [data stopMocking];
    [image stopMocking];
}

- (void)testSaveImagePathNil
{
    OCMStub([self.loader getPathForDirectoriesInDomains]).andReturn(nil);
    OCMStub([self.loader randomId]).andReturn(nil);
    
    id manager = OCMClassMock([NSFileManager class]);
    OCMStub([manager defaultManager]);
    
    [self.loader saveImage:nil completion:nil];
    
    OCMReject([manager defaultManager]);
    
    [manager stopMocking];
}

- (void)testSaveImageFolderNotExistCannotCreate
{
    OCMStub([self.loader getPathForDirectoriesInDomains]).andReturn(@[@"path"]);
    OCMStub([self.loader randomId]).andReturn(nil);
    
    id manager = OCMClassMock([NSFileManager class]);
    OCMStub([manager defaultManager]).andReturn(manager);
    OCMStub([manager fileExistsAtPath:[OCMArg any]]).andReturn(NO);
    OCMStub([manager createDirectoryAtPath:[OCMArg any] withIntermediateDirectories:[OCMArg any] attributes:nil error:(NSError * __autoreleasing *)[OCMArg anyPointer]]).andReturn(NO);
    
    [self.loader saveImage:nil completion:nil];
    
    OCMVerify([manager defaultManager]);
    OCMVerify([manager fileExistsAtPath:[OCMArg any]]);
    OCMVerify([manager createDirectoryAtPath:[OCMArg any] withIntermediateDirectories:[OCMArg any] attributes:nil error:(NSError * __autoreleasing *)[OCMArg anyPointer]]);
    OCMReject([self.loader representationOfImage:[OCMArg any]]);
    
    [manager stopMocking];
}

- (void)testSaveImageFolderNotExistCanCreate
{
    OCMStub([self.loader getPathForDirectoriesInDomains]).andReturn(@[@"path"]);
    OCMStub([self.loader randomId]).andReturn(nil);
    
    id manager = OCMClassMock([NSFileManager class]);
    OCMStub([manager defaultManager]).andReturn(manager);
    OCMStub([manager fileExistsAtPath:[OCMArg any]]).andReturn(NO);
    OCMStub([manager createDirectoryAtPath:[OCMArg any] withIntermediateDirectories:[OCMArg any] attributes:nil error:(NSError * __autoreleasing *)[OCMArg anyPointer]]).andReturn(YES);
    
    [self.loader saveImage:nil completion:nil];
    
    OCMVerify([manager fileExistsAtPath:[OCMArg any]]);
    OCMVerify([manager createDirectoryAtPath:[OCMArg any] withIntermediateDirectories:[OCMArg any] attributes:nil error:(NSError * __autoreleasing *)[OCMArg anyPointer]]);
    OCMVerify([self.loader representationOfImage:[OCMArg any]]);
    
    [manager stopMocking];
}

- (void)testSaveImageFolderExists
{
    OCMStub([self.loader getPathForDirectoriesInDomains]).andReturn(@[@"path"]);
    OCMStub([self.loader randomId]).andReturn(nil);
    
    id manager = OCMClassMock([NSFileManager class]);
    OCMStub([manager defaultManager]).andReturn(manager);
    OCMStub([manager fileExistsAtPath:[OCMArg any]]).andReturn(YES);
    
    [self.loader saveImage:nil completion:nil];
    
    OCMVerify([self.loader representationOfImage:[OCMArg any]]);
    
    [manager stopMocking];
}

- (void)testSaveImagaDataIncorrect
{
    OCMStub([self.loader getPathForDirectoriesInDomains]).andReturn(@[@"path"]);
    OCMStub([self.loader randomId]).andReturn(nil);
    
    id manager = OCMClassMock([NSFileManager class]);
    OCMStub([manager defaultManager]).andReturn(manager);
    OCMStub([manager fileExistsAtPath:[OCMArg any]]).andReturn(YES);
    
    OCMStub([self.loader representationOfImage:[OCMArg any]]).andReturn(nil);
    
    id data = OCMClassMock([NSData class]);
    OCMStub([data writeToFile:[OCMArg any] options:0 error:(NSError * __autoreleasing *)[OCMArg anyPointer]]);
    
    [self.loader saveImage:nil completion:nil];
    
    OCMReject([data writeToFile:[OCMArg any] options:0 error:(NSError * __autoreleasing *)[OCMArg anyPointer]]);
    
    [manager stopMocking];
    [data stopMocking];
}

- (void)testSaveImagaDataCorrect
{
    OCMStub([self.loader getPathForDirectoriesInDomains]).andReturn(@[@"path"]);
    OCMStub([self.loader randomId]).andReturn(nil);
    
    id manager = OCMClassMock([NSFileManager class]);
    OCMStub([manager defaultManager]).andReturn(manager);
    OCMStub([manager fileExistsAtPath:[OCMArg any]]).andReturn(YES);
    
    id data = OCMClassMock([NSData class]);
    OCMStub([data writeToFile:[OCMArg any] options:0 error:(NSError * __autoreleasing *)[OCMArg anyPointer]]);
    
    OCMStub([self.loader representationOfImage:[OCMArg any]]).andReturn(data);
    
    [self.loader saveImage:nil completion:nil];
    
    OCMVerify([data writeToFile:[OCMArg any] options:0 error:(NSError * __autoreleasing *)[OCMArg anyPointer]]);
    
    [manager stopMocking];
    [data stopMocking];
}

- (void)testSaveImageFileWritten
{
    OCMStub([self.loader getPathForDirectoriesInDomains]).andReturn(@[@"path"]);
    OCMStub([self.loader randomId]).andReturn(nil);
    
    id manager = OCMClassMock([NSFileManager class]);
    OCMStub([manager defaultManager]).andReturn(manager);
    OCMStub([manager fileExistsAtPath:[OCMArg any]]).andReturn(YES);
    
    id data = OCMClassMock([NSData class]);
    OCMStub([data writeToFile:[OCMArg any] options:0 error:(NSError * __autoreleasing *)[OCMArg anyPointer]]).andReturn(YES);
    
    OCMStub([self.loader representationOfImage:[OCMArg any]]).andReturn(data);
    
    __block BOOL isCalled = NO;
    
    [self.loader saveImage:nil completion:^(NSString *urlString) {
        isCalled = YES;
    }];
    
    expect(isCalled).to.beTruthy();
    
    [manager stopMocking];
    [data stopMocking];
}

- (void)testSaveImageFileNotWritten
{
    OCMStub([self.loader getPathForDirectoriesInDomains]).andReturn(@[@"path"]);
    OCMStub([self.loader randomId]).andReturn(nil);
    
    id manager = OCMClassMock([NSFileManager class]);
    OCMStub([manager defaultManager]).andReturn(manager);
    OCMStub([manager fileExistsAtPath:[OCMArg any]]).andReturn(YES);
    
    id data = OCMClassMock([NSData class]);
    OCMStub([data writeToFile:[OCMArg any] options:0 error:(NSError * __autoreleasing *)[OCMArg anyPointer]]).andReturn(NO);
    
    OCMStub([self.loader representationOfImage:[OCMArg any]]).andReturn(data);
    
    __block BOOL isCalled = NO;
    
    [self.loader saveImage:nil completion:^(NSString *urlString) {
        isCalled = YES;
    }];
    
    expect(isCalled).to.beFalsy();
    
    [manager stopMocking];
    [data stopMocking];
}

- (void)testRandomId
{
    NSString *expectedResult = @"info";
    
    id processInfo = OCMPartialMock([NSProcessInfo processInfo]);
    OCMStub([processInfo globallyUniqueString]).andReturn(expectedResult);
    
    NSString *idString = [self.loader randomId];
    expect(idString).to.equal(expectedResult);
    
    [processInfo stopMocking];
}

@end
