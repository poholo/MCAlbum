//
// Created by majiancheng on 2018/5/7.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MCController : UIViewController

- (instancetype)initWithRouterParams:(NSDictionary *)params;

+ (NSString *)identifier;

@end