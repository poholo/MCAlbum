//
// Created by majiancheng on 2018/5/7.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TZAssetModelMediaTypePhoto = 0,
    TZAssetModelMediaTypeLivePhoto,
    TZAssetModelMediaTypeVideo,
    TZAssetModelMediaTypeAudio
} TZAssetModelMediaType;

@class PHAsset;

@interface MCSectionDto : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) NSMutableArray *assetsArray;

@end


@interface MCAssetDto : NSObject

@property(nonatomic, strong) id asset;             ///< PHAsset or ALAsset
@property(nonatomic, assign) BOOL isSelected;      ///< The select status of a photo, default is No
@property(nonatomic, assign) TZAssetModelMediaType type;
@property(nonatomic, copy) NSString *timeLength;
@property(nonatomic, strong) NSDate *createDate;
@property(nonatomic, strong) UIImage *cacheImage;

/// Init a photo dataModel With a asset
/// 用一个PHAsset/ALAsset实例，初始化一个照片模型
+ (instancetype)modelWithAsset:(id)asset type:(TZAssetModelMediaType)type;

+ (instancetype)modelWithAsset:(id)asset type:(TZAssetModelMediaType)type timeLength:(NSString *)timeLength;

+ (instancetype)modelWithAsset:(id)asset type:(TZAssetModelMediaType)type timeLength:(NSString *)timeLength createDate:(NSDate *)createDate;

- (NSString *)createTimeText;

- (NSTimeInterval)duration;

@end


@class PHFetchResult;

@interface MMAlbumModel : NSObject

@property(nonatomic, strong) NSString *name;        ///< The album name
@property(nonatomic, assign) NSInteger count;       ///< Count of photos the album contain
@property(nonatomic, strong) id result;             ///< PHFetchResult<PHAsset> or ALAssetsGroup<ALAsset>

- (MCAssetDto *)firstModel:(TZAssetModelMediaType)type;

- (MCAssetDto *)lastModel:(TZAssetModelMediaType)type;

- (NSUInteger)countOfAssetsWithMediaType:(TZAssetModelMediaType)type;

@end