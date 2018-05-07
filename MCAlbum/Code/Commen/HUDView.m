//
// Created by majiancheng on 2018/5/7.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "HUDView.h"

#import <MBProgressHUD/MBProgressHUD.h>

#import "GCDQueue.h"
#import "AppDelegate.h"

static MBProgressHUD *hud;

@implementation HUDView

+ (void)show {
    if (hud) return;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if ([NSThread isMainThread]) {
        hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
    } else {

        __block MBProgressHUD *popupHud = hud;
        [[GCDQueue mainQueue] execute:^{
            popupHud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
            popupHud.mode = MBProgressHUDModeIndeterminate;
        }                  afterDelay:USEC_PER_SEC];
    }
}

+ (void)showView {
    if (hud) return;
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    UIWindow *keyWindow = delegate.window;
    if ([NSThread isMainThread]) {
        hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;

    } else {
        __block MBProgressHUD *popupHud = hud;
        [[GCDQueue mainQueue] execute:^{
            popupHud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
            popupHud.mode = MBProgressHUDModeIndeterminate;
        }                  afterDelay:USEC_PER_SEC];
    }
}

+ (void)showWithText:(NSString *)text {
    if (hud) {
        [[self class] dismiss];
    }
    if ([NSThread isMainThread]) {
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.textColor = [UIColor whiteColor];
        hud.label.text = text;
    } else {
        [[GCDQueue mainQueue] execute:^{
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.label.text = text;
            hud.label.textColor = [UIColor whiteColor];
        }                  afterDelay:USEC_PER_SEC];
    }
}

+ (void)dismiss {
    if ([NSThread isMainThread]) {
        [hud hideAnimated:YES];
        hud = nil;
    } else {
        [[GCDQueue mainQueue] execute:^{
            [hud hideAnimated:YES];
            hud = nil;
        }                  afterDelay:USEC_PER_SEC];
    }
}

+ (void)progress:(CGFloat)progress {
    if (hud) {
        [self dismiss];
    }
    if ([NSThread isMainThread]) {
        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
        hud.progress = progress;
    } else {
        [[GCDQueue mainQueue] execute:^{
            hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
            hud.progress = progress;
        }                  afterDelay:USEC_PER_SEC];
    }
}

@end