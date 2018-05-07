//
// Created by majiancheng on 2018/5/7.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUDView : NSObject

+ (void)show;

+ (void)showView;

+ (void)dismiss;

+ (void)showWithText:(NSString *)text;

+ (void)progress:(CGFloat)progress;

@end
