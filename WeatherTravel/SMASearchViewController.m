//
//  SMASearchViewController.m
//  WeatherTravel
//
//  Created by Maria Semakova on 12/31/17.
//  Copyright © 2017 Maria Semakova. All rights reserved.
//


#import "SMASearchViewController.h"
#import "SMALocationSearchField.h"
#import "UIColor+CustomColors.h"

static const CGFloat SMASearchFieldHeight = 50.f;


@interface SMASearchViewController ()

/**
 Строка ввода названия локации для поиска
 */
@property (nonatomic, strong) SMALocationSearchField *searchField;

@end


@implementation SMASearchViewController


#pragma mark - Жизненный цикл

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect viewBounds = self.view.bounds;
    CGFloat topBarOffset = self.topLayoutGuide.length;
    viewBounds.origin.y = -topBarOffset;
    self.view.bounds = viewBounds;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.searchField.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), SMASearchFieldHeight);
            
            CGRect frame = CGRectMake(10, 150, CGRectGetWidth(self.view.frame) - 20, 300);
            SMAForecastModel *model = [[SMAForecastModel alloc] initWithForecastInfo:@{
                                                                                       @"temperature":@"-100",
                                                                                       @"humidity":@"50%",
                                                                                       @"clouds":@"overcast",
                                                                                       @"time": @"00:00",
                                                                                       @"date":@"today",
                                                                                       @"city": @"Moscow",
                                                                                       @"country": @"Russia"
                                                                                       }];
            self.forecastView = [[SMAForecastView alloc] initWithFrame:frame withForecastModel:model];
            self.forecastView.layer.opacity = 0.f;
            [self.view addSubview:self.forecastView];
        } completion:nil];
    });
    self.searchField.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), SMASearchFieldHeight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UI

/**
 Настройка UI элементов
 */
- (void)setupUI
{
    self.view.backgroundColor = [UIColor customBlue];
    [self setupSearchField];
}

- (void)setupSearchField
{
    self.searchField = [[SMALocationSearchField alloc] initWithFrame:CGRectMake(0, CGRectGetMidY(self.view.frame), CGRectGetWidth(self.view.frame), SMASearchFieldHeight)];
    self.searchField.delegate = self;
    [self.view addSubview:self.searchField];
}

@end
