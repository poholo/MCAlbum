//
// Created by majiancheng on 2018/5/7.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "MCController.h"


@implementation MCController
- (instancetype)initWithRouterParams:(NSDictionary *)params {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}

@end