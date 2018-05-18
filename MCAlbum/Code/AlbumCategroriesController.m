//
// Created by majiancheng on 2017/9/2.
// Copyright (c) 2017 挖趣智慧科技（北京）有限公司. All rights reserved.
//

#import "AlbumCategroriesController.h"

#import <ReactiveCocoa.h>

#import "AlbumCategroryDataVM.h"
#import "AlbumCategroryCell.h"
#import "AlbumRoute.h"
#import "MCAssetsManager.h"
#import "AlbumSelectView.h"
#import "AlbumActionDto.h"
#import "MCAssetDto.h"
#import "AlbumUtils.h"
#import "GCDQueue.h"
#import "HUDView.h"

@interface AlbumCategroriesController () <AlbumSelectViewDelegate>

@property(nonatomic, strong) AlbumSelectView *albumSelectView;

@property(nonatomic, strong) AlbumCategroryDataVM *dataVM;
@property(nonatomic, copy) AlbumDetailSeclectionsCallBack albumDetailSeclectionsCallBack;

@end

@implementation AlbumCategroriesController {

}

- (void)dealloc {
}

- (instancetype)initWithRouterParams:(NSDictionary *)params {
    self = [super initWithRouterParams:params];
    if (self) {
        self.dataVM.actionDto = params[kRouteAlbumAction];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"相机胶卷";

    [self.tableView registerClass:[AlbumCategroryCell class] forCellReuseIdentifier:[AlbumCategroryCell identifier]];

    [self pullToRefresh];
}

- (void)refresh {
    @weakify(self);
    [[MCAssetsManager manager] openAuthorizationStatusAuthorized:^(BOOL granted) {
        @strongify(self);
        if (granted) {
            [[GCDQueue mainQueue] execute:^{
                @strongify(self);
                self.dataVM.granted = granted;
                if (self.dataVM.isRefresh) {
                    return;
                }
                [self.dataVM refresh];
                [self loadData];
            }];
        } else {
            [[GCDQueue mainQueue] execute:^{
                @strongify(self);
                self.dataVM.granted = granted;
                if (self.dataVM.isRefresh) {
                    return;
                }
                [self.dataVM refresh];
                [self loadData];
            }];
        }
    }];

}

- (void)more {
    if ([self.dataVM hasMore]) {
        [self loadData];
    }
}

- (void)loadData {
    RACSignal *signal = [self.dataVM albumCategroies];
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
        if (self.dataVM.actionDto.selectionsAssets.count > 0) {
            [self.view addSubview:self.albumSelectView];
            [self.albumSelectView loadData:self.dataVM.actionDto.selectionsAssets albumActionDto:self.dataVM.actionDto];
            [UIView animateWithDuration:.3 animations:^{
                self.albumSelectView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 150.0f, CGRectGetWidth(self.view.frame), 150.0f);
            }                completion:^(BOOL finished) {

            }];
        }
    } else {
        [self.albumSelectView loadData:self.dataVM.actionDto.selectionsAssets albumActionDto:self.dataVM.actionDto];
    }
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom = 150.0f;
    self.tableView.contentInset = insets;
}

- (void)hideAlbumSelectView {
    [UIView animateWithDuration:.3 animations:^{
        _albumSelectView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 150.0f);
    }                completion:^(BOOL finished) {
        [_albumSelectView removeFromSuperview];
        _albumSelectView = nil;
    }];
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom = 0.0f;
    self.tableView.contentInset = insets;
}

- (void)albumSelectViewConfirm {
    NSString *mentionInfo;
    if (self.dataVM.actionDto.selectionsAssets.count < self.dataVM.actionDto.minNum) {
        mentionInfo = [NSString stringWithFormat:@"最少添加%zd%@", self.dataVM.actionDto.minNum, self.dataVM.actionDto.albumType == AlbumVideo ? @"段视频" : @"张照片"];
    }

    if (mentionInfo) {
        NSLog(@"%@", mentionInfo);
        return;
    }

    if (self.dataVM.actionDto.albumDetailSeclectionsCallBack) {
        self.dataVM.actionDto.albumDetailSeclectionsCallBack(self.dataVM.actionDto.selectionsAssets);
    }
    if (self.dataVM.actionDto.albumEditorOperationType == AlbumEditorOperationNext) {
        switch (self.dataVM.actionDto.creationType) {
            case CreationTypeVideo : {
                [HUDView show];
                @weakify(self);

            }
                break;
            case CreationTypeMV: {
                [HUDView show];

            }
                break;
            case CreationTypePhotoAlbum : {
                @weakify(self);
                [AlbumUtils exportImageWithAssetModels:self.dataVM.actionDto.selectionsAssets targetSize:CGSizeMake(200, 500) completeBlock:^(NSArray<UIImage *> *array) {
                    @strongify(self);
                    //TODO::
                }];
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
                if (![vc isKindOfClass:[self class]] && ![vc isKindOfClass:[AlbumCategroriesController class]]) {
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
    if (indexPath.row >= self.dataVM.actionDto.selectionsAssets.count) {
        return;
    }
    MCAssetDto *asset = self.dataVM.actionDto.selectionsAssets[indexPath.row];
    NSInteger index = [self.dataVM.dataArray indexOfObject:asset];

    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.dataVM.actionDto.selectionsAssets removeObjectAtIndex:indexPath.row];

    [self.albumSelectView loadData:self.dataVM.actionDto.selectionsAssets albumActionDto:self.dataVM.actionDto];
    if (self.dataVM.actionDto.selectionsAssets.count == 0) {
        [self hideAlbumSelectView];
    }
}

- (void)popController {
    if (self.dataVM.actionDto.selectionsAssets.count > 0) {
        @weakify(self);
        //TODO::确认放弃当前操作吗
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - tableView DataSource & Delgate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCategroryCell *cell = [tableView dequeueReusableCellWithIdentifier:[AlbumCategroryCell identifier] forIndexPath:indexPath];
    [cell loadData:self.dataVM.dataArray[indexPath.row] actionDto:self.dataVM.actionDto];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [AlbumCategroryCell height];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataVM.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MMAlbumModel *model = self.dataVM.dataArray[indexPath.row];
    if (self.navigationController) {
        @weakify(self);
        [AlbumRoute pushAlbumDetail:self.dataVM.actionDto album:model selectedCallBack:^(NSMutableArray<MCAssetDto *> *selectionsAssets) {
            @strongify(self);
            self.dataVM.actionDto.selectionsAssets = selectionsAssets;
            if (self.dataVM.actionDto.selectionsAssets.count > 0) {
                [self showAlbumSelectView];
            } else {
                [self hideAlbumSelectView];
            }
        }];
    } else {
        [AlbumRoute presentAlbumDetail:self.dataVM.actionDto album:model];
    }
}

#pragma mark -

#pragma mark - empty

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *str;
    if (self.dataVM.granted) {
        str = self.dataVM.actionDto.albumType == AlbumVideo ? @"相册无视频" : @"相册无照片";
    } else {
        NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
        str = [NSString stringWithFormat:@"请在%@的\"设置-隐私-照片\"选项中，\r允许%@访问你的手机相册。", [UIDevice currentDevice].model, appName];
    }
    return [[NSAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName: [UIColor grayColor], NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
}

#pragma mark - getter

- (AlbumCategroryDataVM *)dataVM {
    if (!_dataVM) {
        _dataVM = [AlbumCategroryDataVM new];
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
