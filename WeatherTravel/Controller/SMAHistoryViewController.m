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

static NSString *const SMAHistoryCollectionViewID = @"SMAHistoryCollectionViewCell";
static const CGFloat SMACollectionViewOffset = 2.f;
static const CGFloat SMAItemsPerRow = 3.f;


@interface SMAHistoryViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SMAHistoryViewController


#pragma mark - Жизненный цикл

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    CGRect viewBounds = self.view.bounds;
//    CGFloat topBarOffset = self.topLayoutGuide.length;
//    viewBounds.origin.y = -topBarOffset;
//    self.view.bounds = viewBounds;
    [self setupConstraints];
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
    CGRect viewBounds = self.view.bounds;
    CGFloat topBarOffset = self.topLayoutGuide.length;
    viewBounds.origin.y = -topBarOffset;
    self.view.bounds = viewBounds;
    
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


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMAHistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SMAHistoryCollectionViewID
                                                                            forIndexPath:indexPath];
    
    
    cell.backgroundColor = UIColor.customBlue;
    cell.cityLabel.text = @"City";
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

@end
