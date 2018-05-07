//
// Created by majiancheng on 2018/5/7.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "MCCollectionCell.h"


@implementation MCCollectionCell
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}

+ (CGSize)size {
    return CGSizeZero;
}

@end