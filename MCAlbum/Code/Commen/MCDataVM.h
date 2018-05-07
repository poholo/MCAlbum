//
// Created by majiancheng on 2018/5/7.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MCDataVM : NSObject

@property(nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, strong) NSNumber *currentPos;

@property(nonatomic, assign) BOOL isRefresh;

- (BOOL)hasMore;

- (void)refresh;

- (void)more;
@end