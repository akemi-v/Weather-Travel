//
//  SMAHistoryViewController.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/16/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMASearchViewControllerDelegateProtocol.h"
#import "SMAForecastView.h"

/**
 Вьюконтроллер, который принимает показывает историю запросов погоды
 */
@interface SMAHistoryViewController : UIViewController <SMASearchViewControllerDelegate>

/**
 Вью, который отображает прогноз и фотографию
 */
@property (nonatomic, strong) SMAForecastView *forecastView;

- (void)reloadData;

@end
