//
// Created by Jiangmingz on 2017/12/26.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "UIView+Corner.h"


@implementation UIView (Corner)

- (void)addCorner:(CGFloat)radius {
    [self addCorner:radius borderColor:nil];
}

- (void)addCorner:(CGFloat)radius borderColor:(UIColor *)color {
    [self addCorner:radius borderColor:color borderWidth:1];
}

- (void)addCorner:(CGFloat)radius borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = borderWidth;
}


@end
