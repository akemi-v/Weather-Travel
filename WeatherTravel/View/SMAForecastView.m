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

static const CGFloat SMAForecastLabelHeight = 25.f;
static const CGFloat SMAForecastOffset = 8.f;


@implementation SMAForecastView

#pragma mark - UI

- (void)setupWithForecastModel:(SMAForecastModel *)model
{
    [self setupUI];
    NSDictionary *strokeTextAttributes = @{
                                           NSFontAttributeName: [UIFont boldSystemFontOfSize:25.f],
                                           NSStrokeColorAttributeName: [UIColor blackColor],
                                           NSForegroundColorAttributeName: [UIColor whiteColor],
                                           NSStrokeWidthAttributeName: @-3.0
                                           };
    
    self.pictureView.image = model.picture;
    self.temperatureLabel.attributedText = [[NSAttributedString alloc]
                                            initWithString:model.temperature
                                            attributes:strokeTextAttributes];
    self.humidityLabel.attributedText = [[NSAttributedString alloc]
                                         initWithString:model.humidity
                                         attributes:strokeTextAttributes];
    self.cloudsLabel.attributedText = [[NSAttributedString alloc]
                                       initWithString:model.clouds
                                       attributes:strokeTextAttributes];
    self.timeLabel.attributedText = [[NSAttributedString alloc]
                                     initWithString:model.time
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
    self.backgroundColor = [UIColor customPaleBlue];
    
    self.pictureView = [[UIImageView alloc] initWithFrame:self.frame];
    [self addSubview:self.pictureView];
    
    self.temperatureLabel = [UILabel new];
    self.temperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.temperatureLabel];
    
    self.humidityLabel = [UILabel new];
    self.humidityLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.humidityLabel];
    
    self.cloudsLabel = [UILabel new];
    self.cloudsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.cloudsLabel];
    
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
    NSDictionary *labels = @{
                             @"temperatureLabel": self.temperatureLabel,
                             @"humidityLabel": self.humidityLabel,
                             @"cloudsLabel": self.cloudsLabel,
                             @"timeLabel": self.timeLabel,
                             @"dateLabel": self.dateLabel,
                             @"cityLabel": self.cityLabel,
                             @"countryLabel": self.countryLabel
                             };
    
    NSArray *verticalConstraints = [NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:|-[temperatureLabel(height)]-offset-[humidityLabel(height)]-offset-[cloudsLabel(height)]->=0-[timeLabel(height)]-offset-[dateLabel(height)]-offset-[cityLabel(height)]-offset-[countryLabel(height)]-|"
                                    options:0 metrics:metrics views:labels];
    [allConstraints addObjectsFromArray:verticalConstraints];
    NSArray *horizontalConstraintsTemp = [NSLayoutConstraint
                                          constraintsWithVisualFormat:@"H:|->=0-[temperatureLabel]-|"
                                          options:0 metrics:metrics views:labels];
    [allConstraints addObjectsFromArray:horizontalConstraintsTemp];
    NSArray *horizontalConstraintsHum = [NSLayoutConstraint
                                         constraintsWithVisualFormat:@"H:|->=0-[humidityLabel]-|"
                                         options:0 metrics:metrics views:labels];
    [allConstraints addObjectsFromArray:horizontalConstraintsHum];
    NSArray *horizontalConstraintsClouds = [NSLayoutConstraint
                                            constraintsWithVisualFormat:@"H:|->=0-[cloudsLabel]-|"
                                            options:0 metrics:metrics views:labels];
    [allConstraints addObjectsFromArray:horizontalConstraintsClouds];
    NSArray *horizontalConstraintsTime = [NSLayoutConstraint
                                          constraintsWithVisualFormat:@"H:|-[timeLabel]->=0-|"
                                          options:0 metrics:metrics views:labels];
    [allConstraints addObjectsFromArray:horizontalConstraintsTime];
    NSArray *horizontalConstraintsDate = [NSLayoutConstraint
                                          constraintsWithVisualFormat:@"H:|-[dateLabel]->=0-|"
                                          options:0 metrics:metrics views:labels];
    [allConstraints addObjectsFromArray:horizontalConstraintsDate];
    NSArray *horizontalConstraintsCity = [NSLayoutConstraint
                                          constraintsWithVisualFormat:@"H:|-[cityLabel]->=0-|"
                                          options:0 metrics:metrics views:labels];
    [allConstraints addObjectsFromArray:horizontalConstraintsCity];
    NSArray *horizontalConstraintsCountry = [NSLayoutConstraint
                                             constraintsWithVisualFormat:@"H:|-[countryLabel]->=0-|"
                                             options:0 metrics:metrics views:labels];
    [allConstraints addObjectsFromArray:horizontalConstraintsCountry];
    
    [self addConstraints: allConstraints];

}

@end
