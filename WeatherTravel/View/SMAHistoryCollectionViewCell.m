//
//  SMAHistoryCollectionViewCell.m
//  WeatherTravel
//
//  Created by Maria Semakova on 1/17/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import "SMAHistoryCollectionViewCell.h"
#import "SMAForecastModel.h"
#import "SMAImageLoader.h"

static const CGFloat SMACollectionViewCellOffset = 5.f;


@implementation SMAHistoryCollectionViewCell

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageView = [UIImageView new];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_imageView];
        _cityLabel = [UILabel new];
        _cityLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_cityLabel];
        _timeLabel = [UILabel new];
        _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_timeLabel];
        _dateLabel = [UILabel new];
        _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_dateLabel];
        
        [self setupConstraints];
    }
    return self;
}


#pragma mark - UI

- (void)setupConstraints
{
    NSMutableArray *allConstraints = [NSMutableArray array];
    NSDictionary *metrics = @{
                              @"offset": [[NSNumber alloc] initWithFloat:SMACollectionViewCellOffset]
                              };
    NSDictionary *views = @{
                            @"imageView": _imageView,
                            @"timeLabel": _timeLabel,
                            @"dateLabel": _dateLabel,
                            @"cityLabel": _cityLabel
                            };
    NSArray *verticalConstraintsImageView = [NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:|[imageView]|"
                                    options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:verticalConstraintsImageView];
    NSArray *horizontalConstraintsImageView = [NSLayoutConstraint
                                       constraintsWithVisualFormat:@"H:|[imageView]|"
                                       options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:horizontalConstraintsImageView];
    NSArray *verticalConstraints = [NSLayoutConstraint
                                               constraintsWithVisualFormat:@"V:|-offset-[cityLabel]->=0-[timeLabel]-offset-[dateLabel]-offset-|"
                                               options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:verticalConstraints];
    NSArray *horizontalConstraints1 = [NSLayoutConstraint
                                                 constraintsWithVisualFormat:@"H:|-offset-[cityLabel]->=0-|"
                                                 options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:horizontalConstraints1];
    NSArray *horizontalConstraints2 = [NSLayoutConstraint
                                       constraintsWithVisualFormat:@"H:|->=0-[timeLabel]-offset-|"
                                       options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:horizontalConstraints2];
    NSArray *horizontalConstraints3 = [NSLayoutConstraint
                                       constraintsWithVisualFormat:@"H:|->=0-[dateLabel]-offset-|"
                                       options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:horizontalConstraints3];
    
    [self addConstraints: allConstraints];
}

- (void)configureWithForecastModel:(SMAForecastModel *)model
{
    NSDictionary *strokeTextAttributes = @{
                                           NSFontAttributeName: [UIFont boldSystemFontOfSize:25.f],
                                           NSStrokeColorAttributeName: UIColor.blackColor,
                                           NSForegroundColorAttributeName: UIColor.whiteColor,
                                           NSStrokeWidthAttributeName: @-3.0
                                           };
    NSDictionary *strokeTextAttributesSmall = @{
                                           NSFontAttributeName: [UIFont boldSystemFontOfSize:17.f],
                                           NSStrokeColorAttributeName: UIColor.blackColor,
                                           NSForegroundColorAttributeName: UIColor.whiteColor,
                                           NSStrokeWidthAttributeName: @-2.0
                                           };

    self.timeLabel.attributedText = [[NSAttributedString alloc]
                                     initWithString:model.time
                                     attributes:strokeTextAttributesSmall];
    self.dateLabel.attributedText = [[NSAttributedString alloc]
                                     initWithString:model.date
                                     attributes:strokeTextAttributesSmall];
    self.cityLabel.attributedText = [[NSAttributedString alloc]
                                     initWithString:model.city
                                     attributes:strokeTextAttributes];
}


@end
