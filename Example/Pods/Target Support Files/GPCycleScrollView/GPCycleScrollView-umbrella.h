#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "TAAbstractDotView.h"
#import "TAAnimatedDotView.h"
#import "TADotView.h"
#import "TAPageControl.h"
#import "SDCollectionViewCell.h"
#import "SDCycleScrollView.h"
#import "UIView+SDExtension.h"
#import "VPCollectionViewLayout.h"
#import "VPCycleScrollView.h"

FOUNDATION_EXPORT double GPCycleScrollViewVersionNumber;
FOUNDATION_EXPORT const unsigned char GPCycleScrollViewVersionString[];

