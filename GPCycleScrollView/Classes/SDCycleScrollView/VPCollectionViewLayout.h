//
//  VPCollectionViewLayout.h
//  VPCycleScrollView
//
//  Created by 姜敏 on 2017/5/25.
//  Copyright © 2017年 姜敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCollectionViewCell.h"

@interface VPCollectionViewLayout : UICollectionViewLayout

@property (nonatomic) CGSize itemSize; //cell的大小

@property (nonatomic, assign) NSInteger visibleCount;

@property (nonatomic, assign) CGFloat minimumScale; //缩放最小倍数

@property (nonatomic, assign) VPBannerViewType cellType; //样式


@end
