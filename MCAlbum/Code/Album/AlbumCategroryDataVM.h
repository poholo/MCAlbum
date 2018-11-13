//
// Created by majiancheng on 2017/9/2.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "MCDataVM.h"

#import "AlbumConstant.h"

@class RACSignal;
@class AlbumActionDto;


@interface AlbumCategroryDataVM : MCDataVM

@property(nonatomic, assign) BOOL granted;

@property(nonatomic, strong) AlbumActionDto *actionDto;

- (RACSignal *)albumCategroies;

@end