//
//  YYCarouselViewFlowLayout.m
//  YYCarouselView
//
//  Created by 沈永聪 on 2018/10/22.
//  Copyright © 2018 沈永聪. All rights reserved.
//

#import "YYCarouselViewFlowLayout.h"

@implementation YYCarouselViewStackAnimator

- (instancetype)init {
    return [self initWithPercent:0.7];
}

- (instancetype)initWithPercent:(CGFloat)percent {
    self = [super init];
    if (self) {
        _percent = percent == 0.0 ? 0.7 : percent;
    }
    
    return self;
}

- (void)animate:(UICollectionView *)collectionView attributes:(YYCarouselViewLayoutAttributes *)attributes {
    attributes.zIndex = [collectionView numberOfItemsInSection:0] -(attributes.indexPath.item);
    CGFloat position = attributes.middleOffset;
    CGPoint itemOrigin = attributes.frame.origin;
    CGPoint contentOffset = collectionView.contentOffset;
    CGFloat itemWidth = collectionView.bounds.size.width;
    
    attributes.transform = CGAffineTransformMakeTranslation(position > 0 ? contentOffset.x - itemOrigin.x + itemWidth * (1 - _percent) * position : 0, 0);
}

@end


@implementation YYCarouselViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.sectionInset = UIEdgeInsetsZero;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

@end
