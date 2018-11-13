//
// Created by majiancheng on 2017/9/2.
// Copyright (c) 2017 挖趣智慧科技（北京）有限公司. All rights reserved.
//

#import "AlbumDetailController.h"

#import <ReactiveCocoa.h>

#import "AlbumDetailDataVM.h"
#import "AlbumCollectionCell.h"
#import "AlbumRoute.h"
#import "MCAssetDto.h"
#import "AlbumCategroriesController.h"
#import "AlbumActionDto.h"
#import "AlbumUtils.h"
#import "AlbumSelectView.h"
#import "MCAssetsManager.h"
#import "HUDView.h"
#import "GCDQueue.h"
#import "AlbumCameraCollectionCell.h"


@interface AlbumDetailController () <AlbumSelectViewDelegate>

@property(nonatomic, strong) AlbumSelectView *albumSelectView;

@property(nonatomic, strong) AlbumDetailDataVM *dataVM;

@property(nonatomic, copy) void (^albumSelectCallBack)(NSArray<MCAssetDto *> *);

- (void)showAlbumSelectView;

- (void)hideAlbumSelectView;

@end


@implementation AlbumDetailController {

}

- (void)dealloc {
    if (self.albumSelectCallBack) {
        self.albumSelectCallBack(self.dataVM.selectionsAssets);
    }
}


- (instancetype)initWithRouterParams:(NSDictionary *)params {
    self = [super initWithRouterParams:params];
    if (self) {
        self.dataVM.currentAssetModel = params[kRouteAlbumModel];
        self.dataVM.actionDto = params[kRouteAlbumAction];
        self.albumSelectCallBack = params[kRouteAlbumSelectCallBack];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.dataVM.currentAssetModel.name;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10.0f;
    layout.minimumLineSpacing = 10.0f;
    CGFloat width = (CGRectGetWidth(self.view.frame) - 20) / 3.0f;
    layout.itemSize = CGSizeMake(width, width);
    self.collectionView.collectionViewLayout = layout;

    [self.collectionView registerClass:[AlbumCollectionCell class] forCellWithReuseIdentifier:[AlbumCollectionCell identifier]];
    [self.collectionView registerClass:[AlbumCameraCollectionCell class] forCellWithReuseIdentifier:[AlbumCameraCollectionCell identifier]];

    [self pullToRefresh];

    [[GCDQueue mainQueue] execute:^{
        if (self.dataVM.selectionsAssets.count > 0) {
            [self showAlbumSelectView];
        } else {
            [self hideAlbumSelectView];
        }
    }              afterDelaySecs:.3];
}

- (void)refresh {
    if (self.dataVM.isRefresh) {
        return;
    }
    [self.dataVM refresh];
    [self loadData];
}

- (void)loadData {
    RACSignal *signal = [self.dataVM albumDtails];
    @weakify(self);
    [signal subscribeNext:^(id x) {
        @strongify(self);
        [self reloadData];
        self.dataVM.isRefresh = NO;
    }               error:^(NSError *error) {
        @strongify(self);
        [self reloadData];
        self.dataVM.isRefresh = NO;
    }];
}

- (void)showAlbumSelectView {
    if (!_albumSelectView) {
        if (self.dataVM.selectionsAssets.count > 0) {
            [self.view addSubview:self.albumSelectView];
            [self.albumSelectView loadData:self.dataVM.selectionsAssets albumActionDto:self.dataVM.actionDto];
            [UIView animateWithDuration:.3 animations:^{
                self.albumSelectView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 150.0f, CGRectGetWidth(self.view.frame), 150.0f);
            }                completion:^(BOOL finished) {

            }];
        }
    } else {
        [self.albumSelectView loadData:self.dataVM.selectionsAssets albumActionDto:self.dataVM.actionDto];
    }
    UIEdgeInsets insets = self.collectionView.contentInset;
    insets.bottom = 150.0f;
    self.collectionView.contentInset = insets;
}

- (void)hideAlbumSelectView {
    [UIView animateWithDuration:.3 animations:^{
        _albumSelectView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 150.0f);
    }                completion:^(BOOL finished) {
        [_albumSelectView removeFromSuperview];
        _albumSelectView = nil;
    }];
    UIEdgeInsets insets = self.collectionView.contentInset;
    insets.bottom = 0.0f;
    self.collectionView.contentInset = insets;
}


#pragma mark - CollecionView dataSource & delegate

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && self.dataVM.actionDto.creationType == CreationTypeVideo) {
        AlbumCameraCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[AlbumCameraCollectionCell identifier] forIndexPath:indexPath];
        return cell;
    } else {
        AlbumCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[AlbumCollectionCell identifier] forIndexPath:indexPath];
        NSInteger row = indexPath.row - (self.dataVM.actionDto.creationType == CreationTypeVideo ? 1 : 0);
        MCAssetDto *dto = self.dataVM.dataArray[row];
        [cell loadData:dto];
        [cell refreshSelectStyle:[self.dataVM.selectionsAssets containsObject:dto]];
        return cell;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataVM.dataArray.count + (self.dataVM.actionDto.creationType == CreationTypeVideo ? 1 : 0);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && self.dataVM.actionDto.creationType == CreationTypeVideo) {
        @weakify(self);
        //TODO::
        return;
    }
    NSString *mentionInfo;
    if (self.dataVM.selectionsAssets.count >= self.dataVM.actionDto.maxNum) {
        mentionInfo = [NSString stringWithFormat:@"最多添加%zd%@", self.dataVM.actionDto.maxNum, self.dataVM.actionDto.albumType == AlbumVideo ? @"段视频" : @"张照片"];
    }
    NSInteger row = indexPath.row - (self.dataVM.actionDto.creationType == CreationTypeVideo ? 1 : 0);
    MCAssetDto *assetModel = self.dataVM.dataArray[row];
    if (self.dataVM.actionDto.albumType == AlbumVideo) {
        if (assetModel.duration < self.dataVM.actionDto.minDuration) {
            mentionInfo = [NSString stringWithFormat:@"大于%zd秒的视频才能被使用", (NSInteger) self.dataVM.actionDto.minDuration];
        } else if (assetModel.duration > self.dataVM.actionDto.maxDuration) {
            mentionInfo = [NSString stringWithFormat:@"大于%zd秒的视频才能被使用", (NSInteger) self.dataVM.actionDto.maxDuration];
        }
    }

    if (mentionInfo) {
        NSLog(@"%@", mentionInfo);
        return;
    }

    if (!self.dataVM.actionDto.canRepeatSelected) {
        if ([self.dataVM.selectionsAssets containsObject:assetModel]) return;
    }

    switch (self.dataVM.actionDto.creationType) {
        case CreationTypeVideo : {
            [HUDView show];

        }
            break;
        case CreationTypeMV:
        case CreationTypePhotoAlbum : {
            [self selectModel:assetModel indexPath:indexPath];
        }
            break;
    }
}

- (void)selectModel:(MCAssetDto *)asset indexPath:(NSIndexPath *)indexPath {
    [self.dataVM.selectionsAssets addObject:asset];
    if (self.dataVM.actionDto.maxNum == 1) {
        [self albumSelectViewConfirm];
    } else {
        [self showAlbumSelectView];
    }

    AlbumCollectionCell *cell = (AlbumCollectionCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
    [cell refreshSelectStyle:[self.dataVM.selectionsAssets containsObject:asset]];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - AlbumSelectViewDelegate

- (void)albumSelectViewConfirm {
    NSString *mentionInfo;
    if (self.dataVM.selectionsAssets.count < self.dataVM.actionDto.minNum) {
        mentionInfo = [NSString stringWithFormat:@"最少添加%zd%@", self.dataVM.actionDto.minNum, self.dataVM.actionDto.albumType == AlbumVideo ? @"段视频" : @"张照片"];
    }

    if (mentionInfo) {
//        [ToastUtils showOnTabTopTitle:mentionInfo];
        return;
    }

    if (self.dataVM.actionDto.albumDetailSeclectionsCallBack) {
        self.dataVM.actionDto.albumDetailSeclectionsCallBack(self.dataVM.selectionsAssets);
    }
    if (self.dataVM.actionDto.albumEditorOperationType == AlbumEditorOperationNext) {
        switch (self.dataVM.actionDto.creationType) {
            case CreationTypeVideo : {

            }
                break;
            case CreationTypeMV: {

            }
                break;
            case CreationTypePhotoAlbum : {

            }
                break;
        }
    } else {
        if (self.navigationController) {
            NSArray<UIViewController *> *viewControllers = self.navigationController.viewControllers;
            __block UIViewController *destVc = viewControllers.firstObject;
            @weakify(self);
            [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
                @strongify(self);
                if (![vc isKindOfClass:[self class]]
                        && ![vc isKindOfClass:[AlbumCategroriesController class]]) {
                    destVc = vc;
                    *stop = YES;
                }
            }];
            [self.navigationController popToViewController:destVc animated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)albumSelectViewRemove:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataVM.selectionsAssets.count) {
        return;
    }
    MCAssetDto *asset = self.dataVM.selectionsAssets[indexPath.row];
    NSInteger index = [self.dataVM.dataArray indexOfObject:asset];

    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.dataVM.selectionsAssets removeObjectAtIndex:indexPath.row];

    AlbumCollectionCell *cell = (AlbumCollectionCell *) [self.collectionView cellForItemAtIndexPath:currentIndexPath];
    [cell refreshSelectStyle:[self.dataVM.selectionsAssets containsObject:asset]];

    [self.albumSelectView loadData:self.dataVM.selectionsAssets albumActionDto:self.dataVM.actionDto];
    if (self.dataVM.selectionsAssets.count == 0) {
        [self hideAlbumSelectView];
    }
}

#pragma mark - empty

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"相册无数据" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor], NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
}

#pragma mark - getter

- (AlbumDetailDataVM *)dataVM {
    if (!_dataVM) {
        _dataVM = [AlbumDetailDataVM new];
    }
    return _dataVM;
}

- (AlbumSelectView *)albumSelectView {
    if (!_albumSelectView) {
        _albumSelectView = [[AlbumSelectView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 150.0f)];
        _albumSelectView.delegate = self;
    }
    return _albumSelectView;
}
@end
