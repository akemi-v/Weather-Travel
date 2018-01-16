//
//  SMAForecastView.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/2/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAForecastModel.h"


/**
 Вью, который отображает прогноз и фотографию
 */
@interface SMAForecastView : UIView

@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UILabel *temperatureLabel;
@property (nonatomic, strong) UILabel *humidityLabel;
@property (nonatomic, strong) UILabel *summaryWeatherLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *countryLabel;

/**
 Настройка вью по модели прогноза

 @param model Модель прогноза
 */
- (void)setupWithForecastModel:(SMAForecastModel *)model;

@end
