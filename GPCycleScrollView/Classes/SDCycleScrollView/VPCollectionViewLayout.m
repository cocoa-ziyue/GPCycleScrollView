//
//  VPCollectionViewLayout.m
//  TestDemon
//
//  Created by 姜敏 on 2017/5/25.
//  Copyright © 2017年 姜敏. All rights reserved.
//

#import "VPCollectionViewLayout.h"

@interface VPCollectionViewLayout ()

@property (nonatomic, assign) CGFloat viewWidth;

@property (nonatomic, assign) CGFloat itemWidth;

@end

@implementation VPCollectionViewLayout



- (void)prepareLayout {
    
    [super prepareLayout];
    
    if (self.visibleCount < 1) {
        self.visibleCount = 5;
    }
    
    _viewWidth = CGRectGetWidth(self.collectionView.frame);
    _itemWidth = self.itemSize.width;
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, (_viewWidth - _itemWidth) / 2, 0, (_viewWidth - _itemWidth) / 2);
}

- (CGSize)collectionViewContentSize {
    
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    
    return CGSizeMake(cellCount * _itemWidth, CGRectGetHeight(self.collectionView.frame));
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat centerY =  self.collectionView.contentOffset.x + _viewWidth / 2;
    
    NSInteger index = centerY / _itemWidth;
    NSInteger count = (self.visibleCount - 1) / 2;
    NSInteger minIndex = MAX(0, (index - count));
    NSInteger maxIndex = MIN((cellCount - 1), (index + count));
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSInteger i = minIndex; i <= maxIndex; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [array addObject:attributes];
        
    }
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    attributes.size = self.itemSize;
    CGFloat cX = self.collectionView.contentOffset.x + _viewWidth / 2;
    CGFloat attributesX = _itemWidth * indexPath.row + _itemWidth / 2;
    attributes.zIndex = -ABS(attributesX - cX);
    CGFloat delta = cX - attributesX;
    CGFloat ratio =  - delta / (_itemWidth * 2);
   
    switch (self.cellType) {
        case VPBannerViewTypeHomeHot: {
            CGFloat clipX;
            CGFloat scale = 1 - fabs(ratio / 0.5) * (1 - _minimumScale);
            if (ratio <= - 0.5) {
                clipX = cX - (1 + ratio) * _itemWidth * scale;
            }else if (ratio > 0.5) {
                clipX = cX + (1 - ratio) * _itemWidth * scale;
            }else if (ratio < 0.5 && ratio >= 0.25) {
                clipX = cX + 0.5 * _itemWidth * scale;
            }else if (ratio >= - 0.25 && ratio < 0.25) {
                clipX = cX + (ratio / 0.5) * _itemWidth * scale;
            }else if (ratio < - 0.25 && ratio > -0.5) {
                clipX = cX  - 0.5 * _itemWidth * scale;
            }else {
                clipX = cX + ratio * _itemWidth * scale;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshBannerEffectAlpha" object:nil userInfo:@{@"indexPath" : indexPath, @"scale" : [NSString stringWithFormat:@"%f",scale]}];
            attributes.transform = CGAffineTransformMakeScale(scale, scale);
            attributes.center = CGPointMake(clipX, CGRectGetHeight(self.collectionView.frame) / 2);
            break;
        }
        case VPBannerViewTypeNews: {
            
            CGFloat scale = _minimumScale;
            if (fabs(ratio) < 0.5) {
                scale = 1 - (fabs(ratio) / 0.5) * (1 - _minimumScale);
            }
            attributes.transform = CGAffineTransformMakeScale(scale, scale);
            attributes.center = CGPointMake(attributesX - (_viewWidth - _itemWidth) / 2 , CGRectGetHeight(self.collectionView.frame) / 2);
            break;
        }
        default:
            break;
    }
    

    return attributes;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat index = roundf((proposedContentOffset.x + _viewWidth / 2 - _itemWidth / 2) / _itemWidth);
    switch (self.cellType) {
        case VPBannerViewTypeHomeHot: {
            proposedContentOffset.x = _itemWidth * index + _itemWidth / 2 - _viewWidth / 2;
            break;
        }
        case VPBannerViewTypeNews: {
            proposedContentOffset.x = _itemWidth * (index + 1) - _viewWidth;
            break;
        }
        default:
            break;
    }
    
    return proposedContentOffset;
    
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return !CGRectEqualToRect(newBounds, self.collectionView.bounds);
    
}

@end
