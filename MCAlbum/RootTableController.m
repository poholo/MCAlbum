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

@end

@implementation RootTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    MMRoutable *routable = [MMRoutable sharedRouter];
    routable.navigationController = self.navigationController;
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
    if (indexPath.row == 0) {
        AlbumActionDto *albumActionDto = [AlbumActionDto new];
        albumActionDto.creationType = CreationTypePhotoAlbum;
        albumActionDto.albumType = AlbumPhoto;
        albumActionDto.maxNum = 4;
        albumActionDto.canRepeatSelected = YES;
        albumActionDto.albumEditorOperationType = AlbumEditorOperationNext;
        @weakify(self);
        albumActionDto.albumDetailSeclectionsCallBack = ^(NSArray<MCAssetDto *> *array) {
            @strongify(self);
//            self.editStepManager.currentSelectedAssetArray = [NSMutableArray arrayWithArray:array];
        };

        [AlbumRoute pushAlbumList:albumActionDto];
    } else if (indexPath.row == 1) {
        AlbumActionDto *albumActionDto = [AlbumActionDto new];
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

        [AlbumRoute pushAlbumList:albumActionDto];
    } else if (indexPath.row == 2) {
        AlbumActionDto *albumActionDto = [AlbumActionDto new];
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

        [AlbumRoute pushAlbumList:albumActionDto];
    } else if (indexPath.row == 3) {
        AlbumActionDto *albumActionDto = [AlbumActionDto new];
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

        [AlbumRoute pushAlbumList:albumActionDto];

    } else if (indexPath.row == 4) {
        AlbumActionDto *albumActionDto = [AlbumActionDto new];
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

        [AlbumRoute pushAlbumList:albumActionDto];

    } else if (indexPath.row == 5) {
        AlbumActionDto *albumActionDto = [AlbumActionDto new];
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

        [AlbumRoute pushAlbumList:albumActionDto];
    }
}

#pragma mark -getter

- (NSArray *)actions {
    if (!_actions) {
        _actions = @[@"多选相册(图片)", @"单选相册(图片)", @"多选相册(视频)", @"单选相册(视频)", @"混合多选(视频&图片)", @"混合单选(视频&图片)"];
    }
    return _actions;
}
@end
