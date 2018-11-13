//
// Created by majiancheng on 2017/9/2.
// Copyright (c) 2017 挖趣智慧科技（北京）有限公司. All rights reserved.
//

#import "MCTableCell.h"

@class MMAlbumModel;
@class AlbumActionDto;


@interface AlbumCategroryCell : MCTableCell

- (void)loadData:(MMAlbumModel *)model actionDto:(AlbumActionDto *)actionDto;

@end