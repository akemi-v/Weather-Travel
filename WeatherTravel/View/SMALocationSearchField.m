//
//  SMALocationSearchField.m
//  WeatherTravel
//
//  Created by Maria Semakova on 12/31/17.
//  Copyright © 2017 Maria Semakova. All rights reserved.
//

#import "SMALocationSearchField.h"
#import "UIColor+CustomColors.h"


@implementation SMALocationSearchField


#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupUI];
    }
    return self;
}


#pragma mark - UI

- (void)setupUI
{
    self.backgroundColor = UIColor.customGloomyBlue;
    self.textColor = UIColor.customYellow;
    
    self.layer.shadowColor = UIColor.yellowColor.CGColor;
    self.layer.shadowOffset = CGSizeMake(1.0f, 2.0f);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 1.0f;
    
    self.placeholder = @"Введите название города";
    
    self.leftViewMode = UITextFieldViewModeAlways;
    UIImage *icon = [UIImage imageNamed:@"search"];
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:icon];
    self.leftView = iconImageView;
}

@end
