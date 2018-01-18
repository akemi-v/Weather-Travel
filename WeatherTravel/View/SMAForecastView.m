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

- (void)setupWithForecastModel:(SMAForecastModel *)model
{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self setupUI];
//    });
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

- (void)setupUI
{
    
    self.backgroundColor = UIColor.customPaleBlue;
    
    self.pictureView = [UIImageView new];
    self.pictureView.translatesAutoresizingMaskIntoConstraints = NO;
    self.pictureView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.pictureView];
    
    self.temperatureLabel = [UILabel new];
    self.temperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.temperatureLabel];
    
    self.humidityLabel = [UILabel new];
    self.humidityLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.humidityLabel];
    
    self.summaryWeatherLabel = [UILabel new];
    self.summaryWeatherLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.summaryWeatherLabel];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.timeLabel];
    
    self.dateLabel = [UILabel new];
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.dateLabel];
    
    self.cityLabel = [UILabel new];
    self.cityLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.cityLabel];
    
    self.countryLabel = [UILabel new];
    self.countryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.countryLabel];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    NSMutableArray *allConstraints = [NSMutableArray array];
    NSDictionary *metrics = @{
                              @"offset": [[NSNumber alloc] initWithFloat:SMAForecastOffset],
                              @"height": [[NSNumber alloc] initWithFloat:SMAForecastLabelHeight]
                              };
    NSDictionary *views = @{
                            @"pictureView": self.pictureView,
                            @"temperatureLabel": self.temperatureLabel,
                            @"humidityLabel": self.humidityLabel,
                            @"summaryLabel": self.summaryWeatherLabel,
                            @"timeLabel": self.timeLabel,
                            @"dateLabel": self.dateLabel,
                            @"cityLabel": self.cityLabel,
                            @"countryLabel": self.countryLabel
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
