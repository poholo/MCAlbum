 //
// Created by majiancheng on 2017/9/4.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "AlbumConstant.h"

typedef NS_ENUM(NSInteger, CreationType) {
    CreationTypeVideo,      ///< 1分钟短视频/剪辑
    CreationTypeMV,         ///< MV
    CreationTypePhotoAlbum  ///< 写真
};

@interface AlbumActionDto : NSObject

@property(nonatomic, copy) AlbumDetailSeclectionsCallBack albumDetailSeclectionsCallBack;

@property(nonatomic, assign) AlbumEditorOperationType albumEditorOperationType;
@property(nonatomic, assign) CreationType creationType;
@property(nonatomic, assign) AlbumType albumType;

@property(nonatomic, assign) NSInteger minNum;
@property(nonatomic, assign) NSInteger maxNum;

@property(nonatomic, assign) NSTimeInterval minDuration;
@property(nonatomic, assign) NSTimeInterval maxDuration;

@property(nonatomic, assign) BOOL canRepeatSelected;

@property(nonatomic, strong) NSMutableArray<MCAssetDto *> *selectionsAssets;

@end
