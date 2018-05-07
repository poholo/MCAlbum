//
// Created by majiancheng on 2018/5/7.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "MCController.h"


@interface MCGridController : MCController <UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, readonly) UICollectionView *collectionView;

- (void)pullToRefresh;

- (void)refresh;

- (void)reloadData;

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;


@end