//
// Created by majiancheng on 2017/11/3.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import "AlbumCameraCollectionCell.h"
#import "AlbumColor.h"

#import <Masonry.h>

@interface AlbumCameraCollectionCell ()

@property(nonatomic, strong) UIImageView *iconImageView;

@end


@implementation AlbumCameraCollectionCell {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [AlbumColor colorII];
        self.contentView.backgroundColor = [AlbumColor colorII];
        [self createViews];
        [self addLayout];
    }
    return self;
}

- (void)createViews {
    [self.contentView addSubview:self.iconImageView];
}

- (void)addLayout {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.size.mas_equalTo(self.iconImageView.image.size);
    }];
}

#pragma mark - getter

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"album_film"]];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}

@end