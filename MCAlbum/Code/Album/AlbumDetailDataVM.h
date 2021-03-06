//
// Created by majiancheng on 2017/9/2.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "MCDataVM.h"
#import "AlbumConstant.h"

@class RACSignal;
@class MMAlbumModel;
@class AlbumActionDto;


@interface AlbumDetailDataVM : MCDataVM

@property(nonatomic, strong) NSMutableArray<MCAssetDto *> *selectionsAssets;

@property(nonatomic, strong) AlbumActionDto *actionDto;

@property(nonatomic, strong) MMAlbumModel *currentAssetModel;

- (RACSignal *)albumDtails;

- (CGFloat)canCutLessSecends;

@end