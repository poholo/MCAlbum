//
// Created by majiancheng on 2018/5/7.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "MCGridController.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "AlbumColorStyle.h"


@interface MCGridController ()

@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation MCGridController

- (void)dealloc {
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
    self.collectionView.emptyDataSetSource = nil;
    self.collectionView.emptyDataSetDelegate = nil;
}

- (void)pullToRefresh {
    [self refresh];
}

- (void)refresh {
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;


    [self.view addSubview:self.collectionView];

    self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - CollectionDataSource & delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - Empty
#pragma mark Source

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"暂无数据" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor], NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@""];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"no_comment"];
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 30.0f;
}

#pragma mark Delegate


#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [AlbumColorStyle babyColorIII];
        _collectionView.emptyDataSetDelegate = self;
        _collectionView.emptyDataSetSource = self;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _collectionView;
}


@end