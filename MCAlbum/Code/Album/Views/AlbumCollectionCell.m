//
// Created by majiancheng on 2017/9/4.
// Copyright (c) 2017 挖趣智慧科技（北京）有限公司. All rights reserved.
//

#import "AlbumCollectionCell.h"

#import <ReactiveCocoa.h>

#import "MCAssetDto.h"
#import "MCAssetsManager.h"
#import "AlbumColorStyle.h"

@interface AlbumCollectionCell ()

@property(nonatomic, strong) UIImageView *albumImageView;

@property(nonatomic, strong) UILabel *timeLabel;

@property(nonatomic, strong) UIView *coverView;

@end

@implementation AlbumCollectionCell {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        [self addLayout];
    }
    return self;
}

- (void)loadData:(MCAssetDto *)data {
    if (data.cacheImage) {
        self.albumImageView.image = data.cacheImage;
    } else {
        CGFloat width = (CGRectGetWidth([UIScreen mainScreen].bounds) - 30) / 3.0f;
        @weakify(self);
        [[MCAssetsManager manager] getPhotoWithAsset:data.asset photoSize:CGSizeMake(width, width) completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            @strongify(self);
            if (photo) {
                self.albumImageView.image = photo;
                data.cacheImage = photo;
            } else {
                self.albumImageView.image = [UIImage imageNamed:@""];
                data.cacheImage = [UIImage imageNamed:@""];
            }
        }];
    }

    if (data.type == TZAssetModelMediaTypeVideo) {
        static NSDateFormatter *dateFormatter;
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        }
        self.timeLabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:data.duration / 1000]];
    } else {
        self.timeLabel.text = @"";
    }
}

- (void)refreshSelectStyle:(BOOL)selected {
    self.coverView.hidden = !selected;
}


- (void)createView {
    self.contentView.backgroundColor = [AlbumColorStyle babyColorIII];
    [self.contentView addSubview:self.albumImageView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.coverView];
}

- (void)addLayout {
    self.albumImageView.frame = self.bounds;
    self.timeLabel.frame = CGRectMake(10, self.frame.size.height - 20, CGRectGetWidth(self.frame) - 20, 14);
    self.coverView.frame = self.bounds;
}

#pragma mark - getter

- (UIImageView *)albumImageView {
    if (!_albumImageView) {
        _albumImageView = [[UIImageView alloc] init];
        _albumImageView.image = [UIImage imageNamed:@""];
        _albumImageView.contentMode = UIViewContentModeScaleAspectFill;
        _albumImageView.clipsToBounds = YES;
    }
    return _albumImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [AlbumColorStyle babyColorII];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [AlbumColorStyle babyColorII];
        _coverView.alpha = .5;
    }
    return _coverView;
}

@end
