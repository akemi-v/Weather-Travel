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
    return YES;
}

@end
