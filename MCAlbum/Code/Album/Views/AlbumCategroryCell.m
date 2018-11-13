//
// Created by majiancheng on 2017/9/2.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "AlbumCategroryCell.h"

#import <ReactiveCocoa.h>
#import <Masonry.h>

#import "MCAssetDto.h"
#import "AlbumActionDto.h"
#import "MCAssetsManager.h"
#import "AlbumColor.h"

@interface AlbumCategroryCell ()

@property(nonatomic, strong) UIImageView *alumImageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *numLabel;

@end

@implementation AlbumCategroryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
        [self addLayout];
    }
    return self;
}

- (void)loadData:(MMAlbumModel *)model actionDto:(AlbumActionDto *)actionDto {
    @weakify(self);
    [[MCAssetsManager manager] getPostImageWithAlbumModel:model type:actionDto.albumType == AlbumVideo ? TZAssetModelMediaTypeVideo : TZAssetModelMediaTypePhoto completion:^(UIImage *postImage) {
        @strongify(self);
        if (postImage) {
            self.alumImageView.image = postImage;
        } else {
            self.alumImageView.image = [UIImage imageNamed:@""];
        }
    }];

    self.titleLabel.text = model.name;
    self.numLabel.text = [NSString stringWithFormat:@"%zd", [model countOfAssetsWithMediaType:actionDto.albumType == AlbumVideo ? TZAssetModelMediaTypeVideo : TZAssetModelMediaTypePhoto]];
}


- (void)createView {
    [self.contentView addSubview:self.alumImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.numLabel];
}

- (void)addLayout {
    @weakify(self);
    [self.alumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.mas_equalTo(75.0f);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.alumImageView.mas_right).offset(10);
        make.centerY.equalTo(self.alumImageView.mas_centerY).offset(-20);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];

    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.right.equalTo(self.titleLabel);
    }];
}

#pragma mark - getter

- (UIImageView *)alumImageView {
    if (!_alumImageView) {
        _alumImageView = [[UIImageView alloc] init];
        _alumImageView.contentMode = UIViewContentModeScaleAspectFill;
        _alumImageView.image = [UIImage imageNamed:@""];
        _alumImageView.clipsToBounds = YES;
    }
    return _alumImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [AlbumColor colorMajor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _titleLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.textColor = [AlbumColor colorMinorI];
        _numLabel.font = [UIFont systemFontOfSize:12];
    }
    return _numLabel;
}

+ (CGFloat)height {
    return 90.0f;
}

@end