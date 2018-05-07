//
// Created by majiancheng on 2018/5/7.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "MCDataVM.h"


@implementation MCDataVM

- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentPos = @0;
    }

    return self;
}

- (BOOL)hasMore {
    return [self.currentPos integerValue] != -1;
}

- (void)refresh {
    self.isRefresh = YES;
    self.currentPos = @0;
}

- (void)more {
    self.isRefresh = NO;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end