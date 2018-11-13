//
// Created by majiancheng on 2017/9/2.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "AlbumCategroryDataVM.h"

#import <ReactiveCocoa.h>

#import "MCAssetsManager.h"
#import "AlbumActionDto.h"
#import "MCAssetDto.h"


@implementation AlbumCategroryDataVM {

}

- (RACSignal *)albumCategroies {
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        @strongify(self);
        if (self.isRefresh) {
            [self.dataArray removeAllObjects];
        }
        if (self.granted) {
            [[MCAssetsManager manager] getAllAlbums:YES completion:^(NSArray<MMAlbumModel *> *models) {
                @strongify(self);
                self.currentPos = @(-1);
                for (MMAlbumModel *model in models) {
                    if ([model countOfAssetsWithMediaType:self.actionDto.albumType == AlbumVideo ? TZAssetModelMediaTypeVideo : TZAssetModelMediaTypePhoto] > 0) {
                        [self.dataArray addObject:model];
                    }
                }
                [subscriber sendNext:self.dataArray];
                [subscriber sendCompleted];
            }];
        } else {
            [subscriber sendNext:self.dataArray];
            [subscriber sendCompleted];
        }

        return nil;
    }];
    return signal;
}

@end
