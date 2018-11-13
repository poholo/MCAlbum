//
// Created by majiancheng on 2017/9/4.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "AlbumActionDto.h"

@implementation AlbumActionDto {

}

- (NSInteger)minNum {
    if (_minNum == 0) {
        return 1;
    }
    return _minNum;
}

- (NSInteger)maxNum {
    if (_maxNum == 0) {
        return 4;
    }
    return _maxNum;
}

@end