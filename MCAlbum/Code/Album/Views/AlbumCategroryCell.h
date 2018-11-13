//
// Created by majiancheng on 2017/9/2.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "MCTableCell.h"

@class MMAlbumModel;
@class AlbumActionDto;


@interface AlbumCategroryCell : MCTableCell

- (void)loadData:(MMAlbumModel *)model actionDto:(AlbumActionDto *)actionDto;

@end