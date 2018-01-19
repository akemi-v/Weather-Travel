//
//  SMAHistoryViewController.m
//  WeatherTravel
//
//  Created by Maria Semakova on 1/16/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import "SMAHistoryViewController.h"
#import "SMAHistoryCollectionViewCell.h"
#import "UIColor+CustomColors.h"
#import "SMAForecastService.h"

static NSString *const SMAHistoryCollectionViewID = @"SMAHistoryCollectionViewCell";
static const CGFloat SMACollectionViewOffset = 2.f;
static const CGFloat SMAForecastOffset = 20.f;
static const CGFloat SMAItemsPerRow = 3.f;


@interface SMAHistoryViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSMutableArray <SMAForecastModel *> *forecasts;
@property (nonatomic, strong) SMAForecastService *forecastService;
@property (nonatomic, strong) SMAImageLoader *imageLoader;

@end

@implementation SMAHistoryViewController


#pragma mark - Жизненный цикл

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.forecastService = [SMAForecastService new];
    self.imageLoader = [SMAImageLoader new];
    [self setupUI];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect viewBounds = self.view.bounds;
    CGFloat topBarOffset = self.topLayoutGuide.length;
    viewBounds.origin.y = -topBarOffset;
    self.view.bounds = viewBounds;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        self.forecastView = [SMAForecastView new];
        self.forecastView.translatesAutoresizingMaskIntoConstraints = NO;
        self.forecastView.pictureView.clipsToBounds = YES;
        self.forecastView.layer.opacity = 0.f;
        [self.view addSubview:self.forecastView];
    });
    [self setupConstraints];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(tapAction:)];
        [self.forecastView addGestureRecognizer:tapRecognizer];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.forecastService getForecastsHistoryCompletion:^(NSArray<SMAForecastModel *> *models) {
        self.forecasts = [models mutableCopy];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI

/**
 Настройка UI элементов
 */
- (void)setupUI
{
    self.title = @"История";
    self.view.backgroundColor = UIColor.customDarkBlue;
    [self setupCollectionView];
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 2;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame
                                             collectionViewLayout:layout];
    self.collectionView.backgroundColor = UIColor.customDarkBlue;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.collectionView registerClass:[SMAHistoryCollectionViewCell class]
            forCellWithReuseIdentifier:SMAHistoryCollectionViewID];
    [self.view addSubview:self.collectionView];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

- (void)setupConstraints
{
    CGFloat topForecastOffset = SMAForecastOffset;
    CGFloat bottomForecastOffset = CGRectGetHeight(self.tabBarController.tabBar.frame) + self.topLayoutGuide.length + SMAForecastOffset;
    NSMutableArray *allConstraints = [NSMutableArray array];
    NSDictionary *views = @{@"collectionView": self.collectionView,
                            @"forecastView": self.forecastView
                            };
    NSDictionary *metrics = @{
                              @"offset": [[NSNumber alloc] initWithFloat:SMACollectionViewOffset],
                              @"topForecastOffset": [[NSNumber alloc] initWithFloat:topForecastOffset],
                              @"bottomForecastOffset": [[NSNumber alloc] initWithFloat:bottomForecastOffset],
                              @"forecastSideOffset": [[NSNumber alloc] initWithFloat:SMAForecastOffset]
                              };
    NSArray *verticalConstraints = [NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:|-offset-[collectionView]-offset-|"
                                    options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:verticalConstraints];
    NSArray *horizontalConstraints = [NSLayoutConstraint
                                      constraintsWithVisualFormat:@"H:|[collectionView]|"
                                      options:0 metrics:nil views:views];
    [allConstraints addObjectsFromArray:horizontalConstraints];
    
    NSArray *verticalConstraintsForecastView = [NSLayoutConstraint
                                                constraintsWithVisualFormat:@"V:|-topForecastOffset-[forecastView]-bottomForecastOffset-|"
                                                options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:verticalConstraintsForecastView];
    NSArray *horizontalConstraintsForecastView = [NSLayoutConstraint
                                                  constraintsWithVisualFormat:@"H:|-forecastSideOffset-[forecastView]-forecastSideOffset-|"
                                                  options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:horizontalConstraintsForecastView];
    
    [self.view addConstraints:allConstraints];
    [self.view setNeedsLayout];
}

- (void)reloadData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.forecasts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMAHistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SMAHistoryCollectionViewID
                                                                            forIndexPath:indexPath];
    
    SMAForecastModel *model = self.forecasts[indexPath.row];
    cell.backgroundColor = UIColor.customBlue;
    [cell configureWithForecastModel:model];
    [self.imageLoader loadImageFromFileURL:model.urlSquareImage completion:^(UIImage *image) {
        cell.imageView.image = image;
    }];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


#pragma mark - UICollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMAForecastModel *model = self.forecasts[indexPath.row];
    [UIView animateWithDuration:0.5 animations:^{
        self.forecastView.layer.opacity = 0.1f;
        self.forecastView.transform = CGAffineTransformMakeScale(0.05f, 0.05f);
        for (id obj in self.view.subviews)
        {
            UIView *view = (UIView *)obj;
            if (![view isKindOfClass:[SMAForecastView class]])
            {
                view.layer.opacity = 0.2f;
            }
        }
    } completion:^(BOOL finished) {
        [self.forecastView setupWithForecastModel:model];
        [self.imageLoader loadImageFromFileURL:model.urlOrigImage completion:^(UIImage *image) {
            self.forecastView.pictureView.image = image;
            [UIView animateWithDuration:0.5 animations:^{
                self.forecastView.layer.opacity = 1.f;
                self.forecastView.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat frameWidth = CGRectGetWidth(self.view.frame);
    CGFloat cellWidth = frameWidth / SMAItemsPerRow;
    CGSize size = CGSizeMake(cellWidth - SMACollectionViewOffset, cellWidth - SMACollectionViewOffset);
    return size;
}

#pragma mark - UIContentContainer

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - SMASeatchViewControllerDelegate

- (void)reload
{
    [self.forecastService getForecastsHistoryCompletion:^(NSArray<SMAForecastModel *> *models) {
        self.forecasts = [models mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
}

#pragma mark - UITapGestureRecognizer

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (60.0*M_PI)/180, 0.0, 0.7, 0.7);
    
    CATransform3D scale;
    scale = CATransform3DMakeScale(0.1, 0.1, 0.1);
    
    
    self.forecastView.alpha = 1.f;
    
    CATransform3D animations;
    animations = CATransform3DConcat(rotation, scale);
    
    self.forecastView.layer.transform = CATransform3DIdentity;
    self.forecastView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    [UIView beginAnimations:@"animation" context:NULL];
    [UIView setAnimationDuration:1.5];
    self.forecastView.layer.transform = animations;
    self.forecastView.alpha = 0.f;
    for (id obj in self.view.subviews)
    {
        UIView *view = (UIView *)obj;
        if (![view isKindOfClass:[SMAForecastView class]])
        {
            view.layer.opacity = 1.f;
        }
    }
    [UIView commitAnimations];
    
    
}


@end
