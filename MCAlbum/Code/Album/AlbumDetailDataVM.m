//
// Created by majiancheng on 2017/9/2.
// Copyright (c) 2017 挖趣智慧科技（北京）有限公司. All rights reserved.
//

#import "AlbumDetailDataVM.h"
#import "MCAssetsManager.h"
#import "MCAssetDto.h"
#import "AlbumActionDto.h"

#import <ReactiveCocoa.h>


@implementation AlbumDetailDataVM {

}

- (RACSignal *)albumDtails {
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        @strongify(self);
        if (self.isRefresh) {
            [self.dataArray removeAllObjects];
        }
        switch (self.actionDto.albumType) {
            case AlbumVideo: {
                [[MCAssetsManager manager] getVideoAssetsFromFetchResult:self.currentAssetModel.result completion:^(NSArray<MCAssetDto *> *array) {
                    @strongify(self);
                    self.currentPos = @(-1);
                    [array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(MCAssetDto *model, NSUInteger idx, BOOL *stop) {
                        @strongify(self);
                        [self.dataArray addObject:model];
                    }];
                    [subscriber sendNext:self.dataArray];
                    [subscriber sendCompleted];
                }];
            }
                break;
            case AlbumPhoto: {
                [[MCAssetsManager manager] getAssetsFromFetchResult:self.currentAssetModel.result allowPickingVideo:NO completion:^(NSArray<MCAssetDto *> *models) {
                    @strongify(self);
                    self.currentPos = @(-1);
                    [models enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(MCAssetDto *model, NSUInteger idx, BOOL *stop) {
                        @strongify(self);
                        [self.dataArray addObject:model];
                    }];
                    [subscriber sendNext:self.dataArray];
                    [subscriber sendCompleted];
                }];
            }
                break;
        }
        return nil;
    }];
    return signal;
}

- (CGFloat)canCutLessSecends {
    CGFloat lessDuration = 0.0f;
//    for (MCAssetDto *assetModel in self.selectionsAssets) {
//        lessDuration += assetModel.editorClip.trimOutTime.floatValue - assetModel.editorClip.trimInTime.floatValue;
//    }
    return lessDuration;//[VideoCropDto maxDuration] - lessDuration;
}

- (void)setActionDto:(AlbumActionDto *)actionDto {
    _actionDto = actionDto;
    for (MCAssetDto *assetModel in actionDto.selectionsAssets) {
        [self.selectionsAssets addObject:assetModel];
    }
}

- (NSMutableArray<MCAssetDto *> *)selectionsAssets {
    if (!_selectionsAssets) {
        _selectionsAssets = [NSMutableArray array];
    }
    return _selectionsAssets;
}
@end
