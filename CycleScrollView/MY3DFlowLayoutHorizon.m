//
//  MY3DFlowLayoutHorizon.m
//  Manyi
//
//  Created by 满艺网 on 2017/12/6.
//  Copyright © 2017年 lvzhenhua. All rights reserved.
//

#define KScreen_width [UIScreen mainScreen].bounds.size.width
#define kSpace 10
#define kItemWidth KScreen_width - kSpace * 4
#define kHeightSpace 10
#define kScale 0.1
#import "MY3DFlowLayoutHorizon.h"
#import <UIImageView+WebCache.h>
@implementation MY3DFlowLayoutHorizon

- (void)prepareLayout {
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = kSpace;
    self.sectionInset = UIEdgeInsetsMake(0, kSpace, 0, 0);
    self.itemSize = CGSizeMake(kItemWidth,self.collectionView.frame.size.height-kHeightSpace*2);
    [super prepareLayout];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *superAttributes = [super layoutAttributesForElementsInRect:rect];
    NSArray *attributes = [[NSArray alloc] initWithArray:superAttributes copyItems:YES];
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x,0,self.collectionView.frame.size.width,self.collectionView.frame.size.height);
    CGFloat centerX = CGRectGetMidX(visibleRect);
    [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat distance = centerX - attribute.center.x;
        CGFloat scaleHeight = distance / self.itemSize.height;
        CGFloat scale = (1-kScale) + kScale * (1 - fabs(scaleHeight));
        attribute.transform3D = CATransform3DMakeScale(1, scale, 1);
        attribute.zIndex = 1;
    }];
    return attributes;
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // 确定停止时显示区域
    CGRect visibleRect;
    visibleRect.origin  = proposedContentOffset;
    visibleRect.size    = CGSizeMake(KScreen_width, self.collectionView.frame.size.height);
    // 获取这个区域中心
    CGFloat centerX = CGRectGetMidX(visibleRect);
    // 获得这个区域内Item
    NSArray *arr =[super layoutAttributesForElementsInRect:visibleRect];

    CGFloat distance = MAXFLOAT;

    // 遍历寻找距离中心点最近的Item
    for (UICollectionViewLayoutAttributes *atts in arr) {


        if (fabs(centerX - atts.center.x) < distance) {

            distance = centerX - atts.center.x;
        }
    }
    // 补偿差值
    proposedContentOffset.x -= distance;

    //防止在第一个和最后一个  卡住
    if (proposedContentOffset.x < 0) {
        proposedContentOffset.x = 0;
    }
    if (proposedContentOffset.x > (self.collectionView.contentSize.width - self.sectionInset.left - self.sectionInset.right - self.itemSize.width)) {

        proposedContentOffset.x = floor(proposedContentOffset.x);
    }
    return proposedContentOffset;
}

//滚动的时会调用
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds;
{
    return YES;
}
@end
