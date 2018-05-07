//
// Created by majiancheng on 2018/5/7.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "MCTableCell.h"


@implementation MCTableCell
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}

+ (CGFloat)height {
    return 44;
}

@end