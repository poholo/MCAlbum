//
// Created by Jiangmingz on 2017/12/26.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (Corner)
/**
 * 自定义圆角
 * @param radius 圆角半径
 */
- (void)addCorner:(CGFloat)radius;

/**
 * Border color
 * @param radius  圆角半径
 * @param color 默认颜色 border默认1pt
 */
- (void)addCorner:(CGFloat)radius borderColor:(UIColor *)color;
/**
 * 设置边框颜色 宽度
 * @param radius 圆角半径
 * @param color 默认颜色
 * @param borderWidth boder宽度
 */
- (void)addCorner:(CGFloat)radius borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;
@end
