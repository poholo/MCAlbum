//
// Created by majiancheng on 2018/5/7.
// Copyright (c) 2018 majiancheng. All rights reserved.
//


#import "MCAssetDto.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHAsset.h>

#import <ReactiveCocoa.h>

@implementation MCSectionDto

- (instancetype)init {
    self = [super init];
    if (self) {
        self.assetsArray = [NSMutableArray new];
    }

    return self;
}

@end

@implementation MCAssetDto

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

+ (instancetype)modelWithAsset:(id)asset type:(TZAssetModelMediaType)type {
    MCAssetDto *model = [[MCAssetDto alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    model.type = type;
    return model;
}

+ (instancetype)modelWithAsset:(id)asset type:(TZAssetModelMediaType)type timeLength:(NSString *)timeLength {
    MCAssetDto *model = [self modelWithAsset:asset type:type];
    model.timeLength = timeLength;
    return model;
}

+ (instancetype)modelWithAsset:(id)asset type:(TZAssetModelMediaType)type timeLength:(NSString *)timeLength createDate:(NSDate *)createDate {
    MCAssetDto *model = [self modelWithAsset:asset type:type timeLength:timeLength];
    model.createDate = createDate;
    return model;
}

- (NSString *)createTimeText {
    return @"";
}

- (NSTimeInterval)duration {
    if ([self.asset isKindOfClass:[PHAsset class]]) {
        PHAsset *asset = self.asset;
        return asset.duration;
    } else if ([self.asset isKindOfClass:[ALAsset class]]) {
        ALAsset *asset = self.asset;
        return [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
    } else {
        return 0.0f;
    }
}

@end


@implementation MMAlbumModel

- (MCAssetDto *)firstModel:(TZAssetModelMediaType)type {
    if ([self.result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *result = self.result;
        PHAssetMediaType mediaType;
        switch (type) {
            case TZAssetModelMediaTypeAudio: {
                mediaType = PHAssetMediaTypeAudio;
            }
                break;
            case TZAssetModelMediaTypeLivePhoto: {
                mediaType = PHAssetMediaTypeImage;
            }
                break;
            case TZAssetModelMediaTypePhoto: {
                mediaType = PHAssetMediaTypeImage;
            }
                break;
            case TZAssetModelMediaTypeVideo: {
                mediaType = PHAssetMediaTypeVideo;
            }
                break;
        }

        __block PHAsset *asset = result.firstObject;
        @weakify(self);
        [result enumerateObjectsUsingBlock:^(PHAsset *tmAsset, NSUInteger idx, BOOL *stop) {
            @strongify(self);
            if (tmAsset.mediaType == mediaType) {
                asset = tmAsset;
                *stop = YES;
            }

        }];
        return asset;
    } else if ([self.result isKindOfClass:[ALAssetsGroup class]]) {
        return nil;
    } else {
        return nil;
    }

}

- (MCAssetDto *)lastModel:(TZAssetModelMediaType)type {
    if ([self.result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *result = self.result;
        PHAssetMediaType mediaType;
        switch (type) {
            case TZAssetModelMediaTypeAudio: {
                mediaType = PHAssetMediaTypeAudio;
            }
                break;
            case TZAssetModelMediaTypeLivePhoto: {
                mediaType = PHAssetMediaTypeImage;
            }
                break;
            case TZAssetModelMediaTypePhoto: {
                mediaType = PHAssetMediaTypeImage;
            }
                break;
            case TZAssetModelMediaTypeVideo: {
                mediaType = PHAssetMediaTypeVideo;
            }
                break;
        }

        __block PHAsset *asset = result.firstObject;
        @weakify(self);
        [result enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset *tmAsset, NSUInteger idx, BOOL *stop) {
            @strongify(self);
            if (tmAsset.mediaType == mediaType) {
                asset = tmAsset;
                *stop = YES;
            }

        }];
        return asset;
    } else if ([self.result isKindOfClass:[ALAssetsGroup class]]) {
        return nil;
    } else {
        return nil;
    }
}


- (NSUInteger)countOfAssetsWithMediaType:(TZAssetModelMediaType)type {
    if ([self.result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *result = self.result;
        PHAssetMediaType mediaType;
        switch (type) {
            case TZAssetModelMediaTypeAudio: {
                mediaType = PHAssetMediaTypeAudio;
            }
                break;
            case TZAssetModelMediaTypeLivePhoto: {
                mediaType = PHAssetMediaTypeImage;
            }
                break;
            case TZAssetModelMediaTypePhoto: {
                mediaType = PHAssetMediaTypeImage;
            }
                break;
            case TZAssetModelMediaTypeVideo: {
                mediaType = PHAssetMediaTypeVideo;
            }
                break;
        }

        return [result countOfAssetsWithMediaType:mediaType];
    } else if ([self.result isKindOfClass:[ALAssetsGroup class]]) {
        return 0;
    } else {
        return 0;
    }

}


@end
