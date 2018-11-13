//
// Created by majiancheng on 2017/9/4.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>

@class UIImage;
@class MCAssetDto;


@interface AlbumUtils : NSObject

+ (void)exportImageWithAssetModels:(NSArray<MCAssetDto *> *)assets targetSize:(CGSize)targetSize completeBlock:(void(^)(NSArray<UIImage *> *))completeBlock;

@end