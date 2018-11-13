//
// Created by majiancheng on 2017/9/4.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "AlbumUtils.h"

#import <UIKit/UIKit.h>
#import <ReactiveCocoa.h>

#import "MCAssetDto.h"
#import "MCAssetsManager.h"


@implementation AlbumUtils {

}

+ (void)exportImageWithAssetModels:(NSArray<MCAssetDto *> *)assets targetSize:(CGSize)targetSize completeBlock:(void (^)(NSArray<UIImage *> *))completeBlock {
    NSMutableArray<UIImage *> *images = [NSMutableArray arrayWithCapacity:assets.count];
    @weakify(self);
    [assets enumerateObjectsUsingBlock:^(MCAssetDto *model, NSUInteger idx, BOOL *stop) {
        @strongify(self);
        __block BOOL canNext = NO;
        [[MCAssetsManager manager] getPhotoWithAsset:model.asset photoSize:targetSize completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            @strongify(self);
            if (!isDegraded) {
                [images addObject:photo];
                canNext = YES;
            }
        }];

        while (!canNext) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.05]];
        }
        if (idx + 1 == assets.count) {
            if (completeBlock) {
                completeBlock(images);
            }
            *stop = YES;
        }

    }];
}

@end
