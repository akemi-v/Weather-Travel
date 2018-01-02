//
//  SMASearchViewController.h
//  WeatherTravel
//
//  Created by Maria Semakova on 12/31/17.
//  Copyright © 2017 Maria Semakova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAForecastView.h"


/**
 Вьюконтроллер, который принимает запрос от пользователя (город) и выдает карточку с прогнозом погоды
 */
@interface SMASearchViewController : UIViewController <UITextFieldDelegate>

///**
// Вью, который отображает прогноз и фотографию
// */
//@property (nonatomic, strong) SMAForecastView *forecastView;

@end
