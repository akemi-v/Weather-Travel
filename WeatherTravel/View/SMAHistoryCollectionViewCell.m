//
//  SMAHistoryCollectionViewCell.m
//  WeatherTravel
//
//  Created by Maria Semakova on 1/17/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import "SMAHistoryCollectionViewCell.h"

@implementation SMAHistoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.cityLabel = [UILabel new];
        self.cityLabel.frame = CGRectMake(0, 0, CGRectGetWidth(frame), 25);
        
        [self.contentView addSubview:self.cityLabel];
    }
    return self;
}


@end
