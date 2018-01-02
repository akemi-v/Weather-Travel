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
//#import "SMAForecastView.h"

static const CGFloat SMASearchFieldHeight = 50.f;


@interface SMASearchViewController ()

/**
 Строка ввода названия локации для поиска
 */
@property (nonatomic, strong) SMALocationSearchField *searchField;


/**
 Вью, который отображает прогноз и фотографию
 */
@property (nonatomic, strong) SMAForecastView *forecastView;

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
            
            CGRect frame = CGRectMake(10, 150, CGRectGetWidth(self.view.frame) - 20, 100);
            SMAForecastModel *model = [[SMAForecastModel alloc] initWithForecastInfo:@{
                                                                                       @"temperature":@"-100"
                                                                                       }];
            self.forecastView = [[SMAForecastView alloc] initWithFrame:frame withForecastModel:model];
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

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.returnKeyType = UIReturnKeySearch;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        self.forecastView.layer.opacity = 0.1;
        self.forecastView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.forecastView.layer.opacity = 1.0;
            self.forecastView.transform = CGAffineTransformIdentity;
        }];
    }];
    return YES;
}

@end
