//
//  AlbumConstant.h
//  BabyShow
//
//  Created by majiancheng on 2017/9/2.
//  Copyright © 2017年 挖趣智慧科技（北京）有限公司. All rights reserved.
//

#ifndef AlbumConstant_h
#define AlbumConstant_h

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AlbumType) {
    AlbumVideo,
    AlbumPhoto
};

typedef NS_ENUM(NSInteger, AlbumEditorOperationType) {
    AlbumEditorOperationNext,
    AlbumEditorOperationBack
};

@class MCAssetDto;

typedef void (^AlbumDetailSeclectionsCallBack)(NSArray<MCAssetDto *> *);


#endif /* AlbumConstant_h */