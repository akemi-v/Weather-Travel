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
#import "SMAForecastService.h"

static const CGFloat SMASearchFieldHeight = 50.f;


@interface SMASearchViewController ()

/**
 Строка ввода названия локации для поиска
 */
@property (nonatomic, strong) SMALocationSearchField *searchField;

/**
 Сервис, составляющий модель прогноза
 */
@property (nonatomic, strong) SMAForecastService *forecastService;
@property (nonatomic, strong) SMAImageLoader *imageLoader;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end


@implementation SMASearchViewController


#pragma mark - Жизненный цикл

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    self.forecastService = [SMAForecastService new];
    self.imageLoader = [SMAImageLoader new];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setupBounds];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        self.searchField.frame = CGRectMake(0, CGRectGetMidY(self.view.frame), CGRectGetWidth(self.view.frame), SMASearchFieldHeight);
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.searchField.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), SMASearchFieldHeight);
        } completion:^(BOOL finished) {
            [self setupConstraints];
        }];
    });
    
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
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupSearchField];
    [self setupActivityIndicator];
    [self setupForecastView];
}

- (void)setupSearchField
{
    self.searchField = [[SMALocationSearchField alloc] initWithFrame:CGRectMake(0, CGRectGetMidY(self.view.frame), CGRectGetWidth(self.view.frame), SMASearchFieldHeight)];
    self.searchField.delegate = self;
    self.searchField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.searchField];
}

- (void)setupActivityIndicator
{
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.hidesWhenStopped = YES;
    self.activityIndicator.center = self.view.center;
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.activityIndicator];
}

- (void)setupForecastView
{
    self.forecastView = [SMAForecastView new];
    self.forecastView.translatesAutoresizingMaskIntoConstraints = NO;
    self.forecastView.pictureView.clipsToBounds = YES;
    self.forecastView.layer.opacity = 0.f;
    [self.view addSubview:self.forecastView];
}

- (void)setupBounds
{
    CGRect viewBounds = self.view.bounds;
    CGFloat topBarOffset = self.topLayoutGuide.length;
    viewBounds.origin.y = -topBarOffset;
    self.view.bounds = viewBounds;
}

- (void)setupConstraints
{
    NSMutableArray *allConstraints = [NSMutableArray array];
    CGFloat tabBarHeight = CGRectGetHeight(self.tabBarController.tabBar.frame) + self.topLayoutGuide.length;
    NSDictionary *metrics = @{
                              @"searchFieldHeight": [[NSNumber alloc] initWithFloat:SMASearchFieldHeight],
                              @"tabBarHeight": [[NSNumber alloc] initWithFloat:tabBarHeight]
                              };
    NSDictionary *views = @{
                            @"forecastView": self.forecastView,
                            @"searchField": self.searchField,
                            @"activityIndicator": self.activityIndicator
                            };
    
    NSArray *verticalConstraints = [NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:|-searchFieldHeight-[forecastView]-tabBarHeight-|"
                                    options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:verticalConstraints];
    NSArray *horizontalConstraints = [NSLayoutConstraint
                                      constraintsWithVisualFormat:@"H:|[forecastView]|"
                                      options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:horizontalConstraints];
    NSArray *horizontalConstraintsSearchField = [NSLayoutConstraint
                                                 constraintsWithVisualFormat:@"H:|[searchField]|"
                                                 options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:horizontalConstraintsSearchField];
    NSArray *verticalConstraintsSearchField = [NSLayoutConstraint
                                               constraintsWithVisualFormat:@"V:|[searchField(searchFieldHeight)]|"
                                               options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:verticalConstraintsSearchField];
    
    NSLayoutConstraint *activityIndicatorConstraintX = [NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                                                    attribute:NSLayoutAttributeCenterX
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self.activityIndicator.superview
                                                                                    attribute:NSLayoutAttributeCenterX
                                                                                   multiplier:1.f constant:0.f];
    [allConstraints addObject:activityIndicatorConstraintX];
    NSLayoutConstraint *activityIndicatorConstraintY = [NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                                                    attribute:NSLayoutAttributeCenterY
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self.activityIndicator.superview
                                                                                    attribute:NSLayoutAttributeCenterY
                                                                                   multiplier:1.f constant:0.f];
    [allConstraints addObject:activityIndicatorConstraintY];
    
    [self.view addConstraints:allConstraints];
    [self.view setNeedsLayout];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.returnKeyType = UIReturnKeySearch;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.activityIndicator startAnimating];
    [UIView animateWithDuration:0.5 animations:^{
        self.forecastView.layer.opacity = 0.1f;
        self.forecastView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    }];
    
    NSString *city = textField.text;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.forecastService getForecastForCityOnline:city completion:^(SMAForecastModel *model) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.forecastView setupWithForecastModel:model];
            });
            [self.imageLoader loadImageFromFileURL:model.urlOrigImage completion:^(UIImage *image) {
                self.forecastView.pictureView.image = image;
                [self.activityIndicator stopAnimating];
                [UIView animateWithDuration:0.5 animations:^{
                    self.forecastView.layer.opacity = 1.f;
                    self.forecastView.transform = CGAffineTransformIdentity;
                }];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    [self.delegate reload];
                });
            }];
        }];
    });
    
    return YES;
}

@end
