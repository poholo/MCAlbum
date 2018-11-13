//
// Created by majiancheng on 2018/5/7.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

#import "MCAssetDto.h"

@class MMAlbumModel, MCAssetDto;

@interface MCAssetsManager : NSObject

@property(nonatomic, strong) PHCachingImageManager *cachingImageManager;

+ (instancetype)manager;

/// Return YES if Authorized 返回YES如果得到了授权
- (BOOL)authorizationStatusAuthorized;

- (void)openAuthorizationStatusAuthorized:(void (^)(BOOL granted))authorizationGranted;

/// Get Album 获得相册/相册数组
- (void)getCameraRollAlbum:(BOOL)allowPickingVideo completion:(void (^)(MMAlbumModel *model))completion;

- (void)getCameraRollForceALLibraryAlbum:(BOOL)allowPickingVideo completion:(void (^)(MMAlbumModel *model))completion;

- (void)getAllAlbums:(BOOL)allowPickingVideo completion:(void (^)(NSArray<MMAlbumModel *> *models))completion;

/// Get Assets 获得Asset数组

/// Get Assets 获得视频数组
- (void)getVideoAssetsFromFetchResult:(id)result completion:(void (^)(NSArray<MCAssetDto *> *))completion;

- (void)getAssetsFromFetchResult:(id)result allowPickingVideo:(BOOL)allowPickingVideo completion:(void (^)(NSArray<MCAssetDto *> *models))completion;

- (void)getAssetFromFetchResult:(id)result atIndex:(NSInteger)index allowPickingVideo:(BOOL)allowPickingVideo completion:(void (^)(MCAssetDto *model))completion;

/// Get photo 获得照片
- (void)getPostImageWithAlbumModel:(MMAlbumModel *)model completion:(void (^)(UIImage *postImage))completion;

- (void)getPostImageWithAlbumModel:(MMAlbumModel *)model type:(TZAssetModelMediaType)type completion:(void (^)(UIImage *postImage))completion;

- (void)getPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion;

- (void)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion;

- (void)getPhotoWithAsset:(id)asset photoSize:(CGSize)photSize completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion;

- (void)getOriginalPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo, NSDictionary *info))completion;

/// Get video 获得视频
- (void)getVideoWithAsset:(id)asset completion:(void (^)(AVPlayerItem *playerItem, NSDictionary *info))completion;

- (void)getAssetWithAsset:(id)asset completion:(void (^)(AVAsset *asset, NSDictionary *info))completion;

- (void)getAssetsWithAsset:(NSArray<MCAssetDto *> *)assets completion:(void (^)(NSArray<AVAsset *> *))completion;

- (void)getAssetWithALAssetUrl:(id)asset completion:(void (^)(NSString *asset, NSError *error))completion;

/// Get photo bytes 获得一组照片的大小
- (void)getPhotosBytesWithArray:(NSArray *)photos completion:(void (^)(NSString *totalBytes))completion;

@end