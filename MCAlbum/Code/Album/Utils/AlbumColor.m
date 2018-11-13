//
// Created by majiancheng on 2018/5/7.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "AlbumColor.h"


@implementation AlbumColor {

}


+ (UIColor *)colorI {
    return [AlbumColor colorWithHexInt:0xFF497B];
}

+ (UIColor *)colorII {
    return [AlbumColor colorWithHexInt:0xFFFFFF];
}


+ (UIColor *)colorIII {
    return [AlbumColor colorWithHexInt:0xF6F6F6];
}


+ (UIColor *)colorIV {
    return [AlbumColor colorWithHexInt:0xE5E5E5];
}


+ (UIColor *)colorV {
    return [AlbumColor colorWithHexInt:0xFF9222];
}


+ (UIColor *)colorVI {
    return [AlbumColor colorWithHexInt:0x1DC9A3];
}

+ (UIColor *)colorMajor {
    return [AlbumColor colorWithHexInt:0x333333];
}

+ (UIColor *)colorMinorI {
    return [AlbumColor colorWithHexInt:0x666666];
}

+ (UIColor *)colorMinorII {
    return [AlbumColor colorWithHexInt:0x999999];
}

+ (UIColor *)colorGary {
    return [AlbumColor colorWithHexInt:0xC8C8C8];
}

+ (UIColor *)colorWithHexInt:(NSUInteger)rgbValue {
    return [UIColor colorWithRed:(CGFloat) (((float) ((rgbValue & 0xFF0000) >> 16)) / 255.0)
                           green:(CGFloat) (((float) ((rgbValue & 0xFF00) >> 8)) / 255.0)
                            blue:(CGFloat) (((float) (rgbValue & 0xFF)) / 255.0)
                           alpha:1.0];
}
@end