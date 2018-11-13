# MCAlbum

## 功能
MCAlbum是对iOS相册高度自定的一个项目，包含以下功能：
1 support图片多选、单选，视频多选、单选，混合（视频、图片）多选，混合（视频、图片）单选。
2 support iOS8 or later
3 support iClound

## 使用手册

```
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
```

## 依赖

```
  pod 'Masonry'
  pod 'ReactiveCocoa', '2.5'
  pod 'MBProgressHUD'
  pod 'DZNEmptyDataSet'
```

# Add Notes
1. 相册列表，相册详情页增加空白页。 before
2. 调整目录结构 2018.11.13
3. Demo入口以及优化 2018.11.13


# TODO
 - 编辑资源
   图像 1.裁剪 2. 旋转 等
   视频 1.区间裁剪
- 资源预览
  图像 放大缩小
  视频 播放
