//
// Created by majiancheng on 2017/9/5.
// Copyright (c) 2017 挖趣智慧科技（北京）有限公司. All rights reserved.
//

#import "AlbumSelectCollectionCell.h"
#import "MCAssetDto.h"
#import "MCAssetsManager.h"
#import "AlbumColorStyle.h"

#import <ReactiveCocoa.h>
#import <Masonry.h>


@interface AlbumSelectCollectionCell ()

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIButton *delBtn;
@property(nonatomic, strong) MCAssetDto *dto;

@property(nonatomic, strong) UILabel *indexLabel;

@end

@implementation AlbumSelectCollectionCell {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self createViews];
        [self addLayout];
        [self addGesture];
    }
    return self;
}

- (void)loadData:(MCAssetDto *)asset {
    self.dto = asset;
    if (asset.cacheImage) {
        self.imageView.image = asset.cacheImage;
    } else {
        @weakify(self);
        [[MCAssetsManager manager] getPhotoWithAsset:asset.asset photoSize:self.bounds.size completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            @strongify(self);
            if (photo) {
                self.imageView.image = photo;
            }
        }];
    }
}

- (void)loadImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)addGesture {
}

- (void)changeEdit:(BOOL)isEdit {
    if (isEdit) {
//        [ViewShapeMask cornerView:self.imageView radius:0 border:1 color:[AlbumColorStyle babyColorI]];
        self.indexLabel.hidden = NO;
    } else {
//        [ViewShapeMask cornerView:self.imageView radius:0 border:0 color:nil];
        self.indexLabel.hidden = YES;
    }
}


- (void)delBtnClick {
    if ([self.delegate respondsToSelector:@selector(albumSelectCollectionCellDel:)]) {
        [self.delegate albumSelectCollectionCellDel:self.indexPath];
    }
}


- (void)createViews {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.delBtn];
    [self.imageView addSubview:self.indexLabel];
}

- (void)addLayout {
    @weakify(self);
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.contentView.mas_top).offset(8);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-8);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];

    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.right.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];

    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.imageView);
        make.left.equalTo(self.imageView);
    }];
}


#pragma mark - getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@""];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIButton *)delBtn {
    if (!_delBtn) {
        _delBtn = [[UIButton alloc] init];
        [_delBtn setImage:[UIImage imageNamed:@"album_delete"] forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(delBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delBtn;
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.textColor = [AlbumColorStyle babyColorII];
        _indexLabel.font = [UIFont systemFontOfSize:12];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.backgroundColor = [AlbumColorStyle babyColorI];
        _indexLabel.hidden = YES;
    }
    return _indexLabel;
}

@end
