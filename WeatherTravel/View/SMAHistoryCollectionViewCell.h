//
//  SMAHistoryCollectionViewCell.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/17/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAForecastModel.h"


/**
 Ячейка collection view в истории запросов погоды
 */
@interface SMAHistoryCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *imageView;

- (void)configureWithForecastModel:(SMAForecastModel *)model;

@end
