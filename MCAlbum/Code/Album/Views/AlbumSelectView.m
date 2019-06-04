//
// Created by majiancheng on 2017/9/5.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "AlbumSelectView.h"

#import <ReactiveCocoa.h>
#import <Masonry.h>

#import "MCAssetDto.h"
#import "AlbumColor.h"
#import "AlbumSelectCollectionCell.h"
#import "AlbumActionDto.h"

@interface AlbumSelectView () <UICollectionViewDataSource, UICollectionViewDelegate, AlbumSelectCollectionCellDelegate>

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *confirmBtn;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSArray<MCAssetDto *> *assets;

@end


@implementation AlbumSelectView {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        [self addLayout];
    }
    return self;
}

- (void)createView {
    [self addSubview:self.titleLabel];
    [self addSubview:self.confirmBtn];
    [self addSubview:self.collectionView];
    self.backgroundColor = [AlbumColor colorII];
}

- (void)addLayout {
    @weakify(self);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(20);
    }];

    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(50);
    }];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.confirmBtn.mas_bottom).offset(20);
        make.left.equalTo(self.mas_left).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
        make.bottom.equalTo(self.mas_bottom).offset(-12);
    }];

}


- (void)confirmBtnClick {
    if ([self.delegate respondsToSelector:@selector(albumSelectViewConfirm)]) {
        [self.delegate albumSelectViewConfirm];
    }
}

- (void)loadData:(NSArray<MCAssetDto *> *)assets albumActionDto:(AlbumActionDto *)albumActionDto {
    self.assets = assets;
    [self.collectionView reloadData];
    [self refreshTitleLabel:albumActionDto.minNum max:albumActionDto.maxNum albumType:albumActionDto.albumType];
}

#pragma mark AlbumSelectCollectionCellDelegate

- (void)albumSelectCollectionCellDel:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(albumSelectViewRemove:)]) {
        [self.delegate albumSelectViewRemove:indexPath];
    }
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumSelectCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[AlbumSelectCollectionCell identifier] forIndexPath:indexPath];
    [cell loadData:self.assets[indexPath.row]];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}


#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [AlbumColor colorMinorI];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [self refreshTitleLabel:1 max:4 albumType:AlbumPhoto];
    }
    return _titleLabel;
}

- (void)refreshTitleLabel:(NSInteger)min max:(NSInteger)max albumType:(AlbumType)albumType {
    if (albumType == AlbumVideo) {
        _titleLabel.text = [NSString stringWithFormat:@"已选择%zd个片段", self.assets.count];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_titleLabel.text attributes:
                @{NSForegroundColorAttributeName: [AlbumColor colorMinorI],
                        NSFontAttributeName: [UIFont systemFontOfSize:12]}];
        [attributedString                                  addAttributes:@{NSForegroundColorAttributeName: [AlbumColor colorI],
                NSFontAttributeName: [UIFont systemFontOfSize:12]} range:NSMakeRange(3, 1)];
        _titleLabel.attributedText = attributedString;
    } else if (albumType == AlbumPhoto) {
        NSString *render = [NSString stringWithFormat:@"%zd-%zd张", min, max];
        _titleLabel.text = [NSString stringWithFormat:@"请选择%@%@", render, albumType == AlbumVideo ? @"视频" : @"照片"];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_titleLabel.text attributes:
                @{NSForegroundColorAttributeName: [AlbumColor colorMinorI],
                        NSFontAttributeName: [UIFont systemFontOfSize:12]}];
        [attributedString                                  addAttributes:@{NSForegroundColorAttributeName: [AlbumColor colorI],
                NSFontAttributeName: [UIFont systemFontOfSize:12]} range:NSMakeRange(3, render.length)];
        _titleLabel.attributedText = attributedString;
    }
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[AlbumColor colorV] forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) / 5 - 10;
        layout.itemSize = CGSizeMake(width, width);
        layout.minimumInteritemSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [AlbumColor colorII];

        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[AlbumSelectCollectionCell class] forCellWithReuseIdentifier:[AlbumSelectCollectionCell identifier]];
    }
    return _collectionView;
}

@end
