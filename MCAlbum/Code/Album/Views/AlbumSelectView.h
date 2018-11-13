//
// Created by majiancheng on 2017/9/5.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCAssetDto;
@class AlbumActionDto;

@protocol AlbumSelectViewDelegate <NSObject>

- (void)albumSelectViewRemove:(NSIndexPath *)indexPath;

- (void)albumSelectViewConfirm;

@end


@interface AlbumSelectView : UIView

@property(nonatomic, weak) id <AlbumSelectViewDelegate> delegate;

- (void)loadData:(NSArray<MCAssetDto *> *)assets albumActionDto:(AlbumActionDto *)albumActionDto;

@end