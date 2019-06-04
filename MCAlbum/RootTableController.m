//
// Created by majiancheng on 2018/5/7.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "RootTableController.h"

#import <ReactiveCocoa.h>

#import "MCTableCell.h"
#import "AlbumRoute.h"
#import "AlbumActionDto.h"
#import "MMRoutable.h"

@interface RootTableController ()

@property(nonatomic, strong) NSArray *actions;

@property(nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation RootTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    MMRoutable *routable = [MMRoutable sharedRouter];
    routable.navigationController = self.navigationController;

    self.navigationItem.titleView = self.segmentedControl;
    [self.tableView registerClass:[MCTableCell class] forCellReuseIdentifier:[MCTableCell identifier]];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MCTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[MCTableCell identifier] forIndexPath:indexPath];
    cell.textLabel.text = self.actions[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actions.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumActionDto *albumActionDto = [AlbumActionDto new];
    if (indexPath.row == 0) {
        albumActionDto.creationType = CreationTypePhotoAlbum;
        albumActionDto.albumType = AlbumPhoto;
        albumActionDto.maxNum = 10;
        albumActionDto.canRepeatSelected = YES;
        albumActionDto.albumEditorOperationType = AlbumEditorOperationNext;
        @weakify(self);
        albumActionDto.albumDetailSeclectionsCallBack = ^(NSArray<MCAssetDto *> *array) {
            @strongify(self);
//            self.editStepManager.currentSelectedAssetArray = [NSMutableArray arrayWithArray:array];
        };

    } else if (indexPath.row == 1) {
        albumActionDto.creationType = CreationTypePhotoAlbum;
        albumActionDto.albumType = AlbumPhoto;
        albumActionDto.maxNum = 1;
        albumActionDto.canRepeatSelected = YES;
        albumActionDto.albumEditorOperationType = AlbumEditorOperationNext;
        @weakify(self);
        albumActionDto.albumDetailSeclectionsCallBack = ^(NSArray<MCAssetDto *> *array) {
            @strongify(self);
//            self.editStepManager.currentSelectedAssetArray = [NSMutableArray arrayWithArray:array];
        };

    } else if (indexPath.row == 2) {
        albumActionDto.creationType = CreationTypePhotoAlbum;
        albumActionDto.albumType = AlbumVideo;
        albumActionDto.maxNum = 4;
        albumActionDto.canRepeatSelected = YES;
        albumActionDto.albumEditorOperationType = AlbumEditorOperationNext;
        @weakify(self);
        albumActionDto.albumDetailSeclectionsCallBack = ^(NSArray<MCAssetDto *> *array) {
            @strongify(self);
//            self.editStepManager.currentSelectedAssetArray = [NSMutableArray arrayWithArray:array];
        };

    } else if (indexPath.row == 3) {
        albumActionDto.creationType = CreationTypePhotoAlbum;
        albumActionDto.albumType = AlbumVideo;
        albumActionDto.maxNum = 1;
        albumActionDto.canRepeatSelected = YES;
        albumActionDto.albumEditorOperationType = AlbumEditorOperationNext;
        @weakify(self);
        albumActionDto.albumDetailSeclectionsCallBack = ^(NSArray<MCAssetDto *> *array) {
            @strongify(self);
//            self.editStepManager.currentSelectedAssetArray = [NSMutableArray arrayWithArray:array];
        };

    } else if (indexPath.row == 4) {
        albumActionDto.creationType = CreationTypePhotoAlbum;
        albumActionDto.albumType = AlbumAll;
        albumActionDto.maxNum = 4;
        albumActionDto.canRepeatSelected = YES;
        albumActionDto.albumEditorOperationType = AlbumEditorOperationNext;
        @weakify(self);
        albumActionDto.albumDetailSeclectionsCallBack = ^(NSArray<MCAssetDto *> *array) {
            @strongify(self);
//            self.editStepManager.currentSelectedAssetArray = [NSMutableArray arrayWithArray:array];
        };

    } else if (indexPath.row == 5) {
        albumActionDto.creationType = CreationTypePhotoAlbum;
        albumActionDto.albumType = AlbumAll;
        albumActionDto.maxNum = 1;
        albumActionDto.canRepeatSelected = YES;
        albumActionDto.albumEditorOperationType = AlbumEditorOperationNext;
        @weakify(self);
        albumActionDto.albumDetailSeclectionsCallBack = ^(NSArray<MCAssetDto *> *array) {
            @strongify(self);
//            self.editStepManager.currentSelectedAssetArray = [NSMutableArray arrayWithArray:array];
        };

    }
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [AlbumRoute pushAlbumList:albumActionDto];
    } else if (self.segmentedControl.selectedSegmentIndex == 1) {
        [AlbumRoute presentAlbumList:albumActionDto];
    }

}

#pragma mark -getter

- (NSArray *)actions {
    if (!_actions) {
        _actions = @[@"多选相册(图片)", @"单选相册(图片)", @"多选相册(视频)", @"单选相册(视频)", @"混合多选(视频&图片)", @"混合单选(视频&图片)"];
    }
    return _actions;
}

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"push", @"present"]];
        _segmentedControl.selectedSegmentIndex = 0;
    }
    return _segmentedControl;
}
@end
