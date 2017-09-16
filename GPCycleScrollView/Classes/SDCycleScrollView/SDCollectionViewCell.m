//
//  SDCollectionViewCell.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//


/*
 
 *********************************************************************************
 *
 * 🌟🌟🌟 新建SDCycleScrollView交流QQ群：185534916 🌟🌟🌟
 *
 * 在您使用此自动轮播库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * 新浪微博:GSD_iOS
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 *
 * 另（我的自动布局库SDAutoLayout）：
 *  一行代码搞定自动布局！支持Cell和Tableview高度自适应，Label和ScrollView内容自适应，致力于
 *  做最简单易用的AutoLayout库。
 * 视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * 用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 * GitHub：https://github.com/gsdios/SDAutoLayout
 *********************************************************************************
 
 */

#import "SDCollectionViewCell.h"
#import "UIView+SDExtension.h"
#import "UIImageView+WebCache.h"

@interface SDCollectionViewCell ()

@end

@implementation SDCollectionViewCell
{
    __weak UILabel *_titleLabel;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
        [self setupTitleLabel];
    }
    
    return self;
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    _titleLabel.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = titleLabelTextFont;
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.clipsToBounds = NO;
    _imageView = imageView;
    [self.contentView addSubview:imageView];
}

- (void)setupTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.hidden = YES;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:titleLabel];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"   %@", title];
    [_titleLabel sizeToFit];
    CGFloat titleLabelW = SCREEN_WIDTH-30;
    CGSize size = LBL_SIZE(title,_titleLabel.font,titleLabelW,MAXFLOAT);
    CGFloat titleLabelY = self.sd_height - size.height-FitAllScreen(60,35);
    if (self.count > 1) {
        titleLabelY = self.sd_height - size.height-FitAllScreen(80,50);
    }
    _titleLabel.frame = CGRectMake(15, titleLabelY, titleLabelW, size.height);
    if (_titleLabel.hidden)  _titleLabel.hidden = NO;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.onlyDisplayText) {
        _titleLabel.frame = self.bounds;
    } else {
        _imageView.frame = self.bounds;
    }
}

- (UILabel *)matchTitleLabel {
    if (!_matchTitleLabel) {
        _matchTitleLabel = [[UILabel alloc] init];
        _matchTitleLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        _matchTitleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _matchTitleLabel;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        _effectView.alpha = 0;
    }
    return _effectView;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *plistNameNew = [NSString stringWithFormat:@"%@.bundle/homeHotBanner",@"Resources"];
        NSString *path = [bundle pathForResource:plistNameNew ofType:@"png"];
        _backgroundImageView.image = [UIImage imageNamed:path];
    }
    return _backgroundImageView;
}

- (void)setBannerViewType:(VPBannerViewType)bannerViewType {
    _bannerViewType = bannerViewType;
    switch (bannerViewType) {
        case VPBannerViewTypeHomeHot: {
            [self.imageView addSubview:self.backgroundImageView];
            [self.imageView addSubview:self.matchTitleLabel];
            [self addSubview:self.effectView];
            [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.bottom.left.equalTo(self);
            }];
            [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.bottom.equalTo(self);
            }];
            break;
        }
        default:
            break;
    }
    
}

@end
