//
// Created by majiancheng on 2018/5/7.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "MCController.h"


@interface MCTableController : MCController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong, readonly) UITableView *tableView;

- (void)pullToRefresh;

- (void)refresh;

- (void)reloadData;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewStyle)tableStyle;

@end
