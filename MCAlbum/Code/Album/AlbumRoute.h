//
// Created by majiancheng on 2017/9/2.
// Copyright (c) 2017 挖趣智慧科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AlbumConstant.h"

@class MMAlbumModel;
@class AlbumActionDto;

extern NSString *const kRouteAlbumModel;
extern NSString *const kRouteAlbumAction;
extern NSString *const kRouteAlbumSelectCallBack;


@interface AlbumRoute : NSObject

+ (void)registerAlbum;

+ (void)presentAlbumList:(AlbumActionDto *)albumActionDto;

+ (void)presentAlbumDetail:(AlbumActionDto *)albumActionDto album:(MMAlbumModel *)albumModel;

+ (void)pushAlbumList:(AlbumActionDto *)albumActionDto;

+ (void)pushAlbumDetail:(AlbumActionDto *)albumActionDto album:(MMAlbumModel *)albumModel selectedCallBack:(void (^)(NSMutableArray<MCAssetDto *> *))selectCallBack;

@end
