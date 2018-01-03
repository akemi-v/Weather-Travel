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

static const CGFloat SMAForecastLabelHeight = 20.f;
static const CGFloat SMAForecastOffset = 8.f;


@implementation SMAForecastView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame withForecastModel:(SMAForecastModel *)model
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupUI];
        
        self.pictureView.image = model.picture;
        self.temperatureLabel.text = model.temperature;
        self.humidityLabel.text = model.humidity;
        self.cloudsLabel.text = model.clouds;
        self.timeLabel.text = model.time;
        self.dateLabel.text = model.date;
        self.cityLabel.text = model.city;
        self.countryLabel.text = model.country;
    }
    return self;
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
    
    self.temperatureLabel.backgroundColor = [UIColor redColor];
    self.humidityLabel.backgroundColor = [UIColor redColor];
    self.cloudsLabel.backgroundColor = [UIColor redColor];
    self.timeLabel.backgroundColor = [UIColor redColor];
    self.dateLabel.backgroundColor = [UIColor redColor];
    self.cityLabel.backgroundColor = [UIColor redColor];
    self.countryLabel.backgroundColor = [UIColor redColor];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    NSDictionary *metrics = @{@"offset": [[NSNumber alloc] initWithFloat:SMAForecastOffset], @"height": [[NSNumber alloc] initWithFloat:SMAForecastLabelHeight]};
    NSDictionary *labels = @{@"temperatureLabel": self.temperatureLabel, @"humidityLabel": self.humidityLabel, @"cloudsLabel": self.cloudsLabel, @"timeLabel": self.timeLabel, @"dateLabel": self.dateLabel, @"cityLabel": self.cityLabel, @"countryLabel": self.countryLabel};
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[temperatureLabel(height)]-offset-[humidityLabel(height)]-offset-[cloudsLabel(height)]->=0-[timeLabel(height)]-offset-[dateLabel(height)]-offset-[cityLabel(height)]-offset-[countryLabel(height)]-|" options:0 metrics:metrics views:labels];
    NSArray *horizontalConstraintsTemp = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[temperatureLabel]-|" options:0 metrics:metrics views:labels];
    NSArray *horizontalConstraintsHum = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[humidityLabel]-|" options:0 metrics:metrics views:labels];
    NSArray *horizontalConstraintsClouds = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[cloudsLabel]-|" options:0 metrics:metrics views:labels];
    NSArray *horizontalConstraintsTime = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[timeLabel]->=0-|" options:0 metrics:metrics views:labels];
    NSArray *horizontalConstraintsDate = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[dateLabel]->=0-|" options:0 metrics:metrics views:labels];
    NSArray *horizontalConstraintsCity = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[cityLabel]->=0-|" options:0 metrics:metrics views:labels];
    NSArray *horizontalConstraintsCountry = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[countryLabel]->=0-|" options:0 metrics:metrics views:labels];
    [self addConstraints: verticalConstraints];
    [self addConstraints: horizontalConstraintsTemp];
    [self addConstraints: horizontalConstraintsHum];
    [self addConstraints: horizontalConstraintsClouds];
    [self addConstraints: horizontalConstraintsTime];
    [self addConstraints: horizontalConstraintsDate];
    [self addConstraints: horizontalConstraintsCity];
    [self addConstraints: horizontalConstraintsCountry];

}

@end
