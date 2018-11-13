//
// Created by majiancheng on 2017/9/4.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "MCCollectionCell.h"

@class MCAssetDto;


@interface AlbumCollectionCell : MCCollectionCell

- (void)loadData:(MCAssetDto *)data;

- (void)refreshSelectStyle:(BOOL)selected;

@end