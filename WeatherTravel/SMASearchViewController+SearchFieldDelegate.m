//
//  SMASearchViewController+SearchFieldDelegate.m
//  WeatherTravel
//
//  Created by Maria Semakova on 1/2/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import "SMASearchViewController+SearchFieldDelegate.h"


@implementation SMASearchViewController (SearchFieldDelegate)


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.returnKeyType = UIReturnKeySearch;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        self.forecastView.layer.opacity = 0.1f;
        self.forecastView.transform = CGAffineTransformMakeScale(0.05f, 0.05f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.forecastView.layer.opacity = 1.f;
            self.forecastView.transform = CGAffineTransformIdentity;
        }];
    }];
    return YES;
}

@end

