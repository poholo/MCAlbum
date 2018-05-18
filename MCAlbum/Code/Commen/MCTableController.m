//
// Created by majiancheng on 2018/5/7.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "MCTableController.h"


@interface MCTableController ()

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation MCTableController

- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];

    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}

- (void)pullToRefresh {
    [self refresh];
}

- (void)refresh {
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}

- (void)reloadData {
    [self.tableView reloadData];
}

#pragma mark - Empty
#pragma mark Source

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"暂无数据" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor], NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@""];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"no_comment"];
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 30.0f;
}

#pragma mark - ASTableDelegate, ASTableDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (UITableViewStyle)tableStyle {
    return UITableViewStylePlain;
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:[self tableStyle]];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = self.view.backgroundColor;
    }
    return _tableView;
}

@end