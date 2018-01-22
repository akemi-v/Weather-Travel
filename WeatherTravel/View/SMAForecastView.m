//
//  SMAForecastView.m
//  WeatherTravel
//
//  Created by Maria Semakova on 1/2/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import "SMAForecastView.h"
#import "SMAForecastModel.h"
#import "UIColor+CustomColors.h"
#import "SMAImageLoader.h"

static const CGFloat SMAForecastLabelHeight = 25.f;
static const CGFloat SMAForecastOffset = 8.f;


@implementation SMAForecastView


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI
{
    
    self.backgroundColor = UIColor.customPaleBlue;
    
    _pictureView = [UIImageView new];
    _pictureView.translatesAutoresizingMaskIntoConstraints = NO;
    _pictureView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_pictureView];
    
    _temperatureLabel = [UILabel new];
    _temperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_temperatureLabel];
    
    _humidityLabel = [UILabel new];
    _humidityLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_humidityLabel];
    
    _summaryWeatherLabel = [UILabel new];
    _summaryWeatherLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_summaryWeatherLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_timeLabel];
    
    _dateLabel = [UILabel new];
    _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_dateLabel];
    
    _cityLabel = [UILabel new];
    _cityLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_cityLabel];
    
    _countryLabel = [UILabel new];
    _countryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_countryLabel];
    
    [self setupConstraints];
}

- (void)setupWithForecastModel:(SMAForecastModel *)model
{
    NSDictionary *strokeTextAttributes = @{
                                           NSFontAttributeName: [UIFont boldSystemFontOfSize:25.f],
                                           NSStrokeColorAttributeName: UIColor.blackColor,
                                           NSForegroundColorAttributeName: UIColor.whiteColor,
                                           NSStrokeWidthAttributeName: @-3.0
                                           };
    
    self.temperatureLabel.attributedText = [[NSAttributedString alloc]
                                            initWithString: [NSString stringWithFormat:@"%@ °C", model.temperature]
                                            attributes:strokeTextAttributes];
    self.humidityLabel.attributedText = [[NSAttributedString alloc]
                                         initWithString:[NSString stringWithFormat:@"Humidity: %@%%", model.humidity]
                                         attributes:strokeTextAttributes];
    self.summaryWeatherLabel.attributedText = [[NSAttributedString alloc]
                                               initWithString:model.summaryWeather
                                               attributes:strokeTextAttributes];
    self.timeLabel.attributedText = [[NSAttributedString alloc]
                                     initWithString:[NSString stringWithFormat:@"%@ (local)", model.time]
                                     attributes:strokeTextAttributes];
    self.dateLabel.attributedText = [[NSAttributedString alloc]
                                     initWithString:model.date
                                     attributes:strokeTextAttributes];
    self.cityLabel.attributedText = [[NSAttributedString alloc]
                                     initWithString:model.city
                                     attributes:strokeTextAttributes];
    self.countryLabel.attributedText = [[NSAttributedString alloc]
                                        initWithString:model.country
                                        attributes:strokeTextAttributes];
}

- (void)setupConstraints
{
    NSMutableArray *allConstraints = [NSMutableArray array];
    NSDictionary *metrics = @{
                              @"offset": [[NSNumber alloc] initWithFloat:SMAForecastOffset],
                              @"height": [[NSNumber alloc] initWithFloat:SMAForecastLabelHeight]
                              };
    NSDictionary *views = @{
                            @"pictureView": _pictureView,
                            @"temperatureLabel": _temperatureLabel,
                            @"humidityLabel": _humidityLabel,
                            @"summaryLabel": _summaryWeatherLabel,
                            @"timeLabel": _timeLabel,
                            @"dateLabel": _dateLabel,
                            @"cityLabel": _cityLabel,
                            @"countryLabel": _countryLabel
                            };
    
    NSArray *verticalConstraintsPictureView = [NSLayoutConstraint
                                               constraintsWithVisualFormat:@"V:|[pictureView]|"
                                               options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:verticalConstraintsPictureView];
    NSArray *horizontalConstraintsPictureView = [NSLayoutConstraint
                                                 constraintsWithVisualFormat:@"H:|[pictureView]|"
                                                 options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:horizontalConstraintsPictureView];
    
    NSArray *verticalConstraints = [NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:|-[temperatureLabel(height)]-offset-[humidityLabel(height)]-offset-[summaryLabel(height)]->=0-[timeLabel(height)]-offset-[dateLabel(height)]-offset-[cityLabel(height)]-offset-[countryLabel(height)]-|"
                                    options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:verticalConstraints];
    NSArray *horizontalConstraintsTemp = [NSLayoutConstraint
                                          constraintsWithVisualFormat:@"H:|->=0-[temperatureLabel]-|"
                                          options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:horizontalConstraintsTemp];
    NSArray *horizontalConstraintsHum = [NSLayoutConstraint
                                         constraintsWithVisualFormat:@"H:|->=0-[humidityLabel]-|"
                                         options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:horizontalConstraintsHum];
    NSArray *horizontalConstraintsSummary = [NSLayoutConstraint
                                             constraintsWithVisualFormat:@"H:|->=0-[summaryLabel]-|"
                                             options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:horizontalConstraintsSummary];
    NSArray *horizontalConstraintsTime = [NSLayoutConstraint
                                          constraintsWithVisualFormat:@"H:|-[timeLabel]->=0-|"
                                          options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:horizontalConstraintsTime];
    NSArray *horizontalConstraintsDate = [NSLayoutConstraint
                                          constraintsWithVisualFormat:@"H:|-[dateLabel]->=0-|"
                                          options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:horizontalConstraintsDate];
    NSArray *horizontalConstraintsCity = [NSLayoutConstraint
                                          constraintsWithVisualFormat:@"H:|-[cityLabel]->=0-|"
                                          options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:horizontalConstraintsCity];
    NSArray *horizontalConstraintsCountry = [NSLayoutConstraint
                                             constraintsWithVisualFormat:@"H:|-[countryLabel]->=0-|"
                                             options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:horizontalConstraintsCountry];
    
    [self addConstraints: allConstraints];
    
}

@end
