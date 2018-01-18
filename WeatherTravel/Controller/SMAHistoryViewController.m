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
//    [self.forecastService getForecastsHistoryCompletion:^(NSArray<SMAForecastModel *> *models) {
//        self.forecasts = [models mutableCopy];
//        [self.collectionView reloadData];
//    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setupConstraints];
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
    
    CGRect viewBounds = self.view.bounds;
    CGFloat topBarOffset = self.topLayoutGuide.length;
    viewBounds.origin.y = -topBarOffset;
    self.view.bounds = viewBounds;
    
    [self setupCollectionView];
    [self setupConstraints];
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
    NSMutableArray *allConstraints = [NSMutableArray array];
    NSDictionary *views = @{@"collectionView": self.collectionView};
    NSDictionary *metrics = @{
                              @"offset": [[NSNumber alloc] initWithFloat:SMACollectionViewOffset]
                              };
    NSArray *verticalConstraints = [NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:|-offset-[collectionView]-offset-|"
                                    options:0 metrics:metrics views:views];
    [allConstraints addObjectsFromArray:verticalConstraints];
    NSArray *horizontalConstraints = [NSLayoutConstraint
                                      constraintsWithVisualFormat:@"H:|[collectionView]|"
                                      options:0 metrics:nil views:views];
    [allConstraints addObjectsFromArray:horizontalConstraints];
    
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


@end
