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
}

@end
