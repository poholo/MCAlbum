//
// Created by majiancheng on 2017/9/5.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "MCCollectionCell.h"

@class MCAssetDto;

@protocol AlbumSelectCollectionCellDelegate <NSObject>

- (void)albumSelectCollectionCellDel:(NSIndexPath *)indexPath;

@end

@interface AlbumSelectCollectionCell : MCCollectionCell

@property(nonatomic, strong) NSIndexPath *indexPath;

@property(nonatomic, weak) id <AlbumSelectCollectionCellDelegate> delegate;

- (void)loadData:(MCAssetDto *)asset;

- (void)loadImage:(UIImage *)image;

- (void)changeEdit:(BOOL)isEdit;

@end