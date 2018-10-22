//
//  YYCarouselViewStackLayout.m
//  YYCarouselView
//
//  Created by 沈永聪 on 2018/10/22.
//  Copyright © 2018 沈永聪. All rights reserved.
//

#import "YYCarouselViewStackLayout.h"

@implementation YYCarouselViewStackLayout {
    YYCarouselViewStackAnimator *_animator;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    _animator = [[YYCarouselViewStackAnimator alloc] init];
}

+ (Class)layoutAttributesClass {
    return [YYCarouselViewLayoutAttributes class];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    NSMutableArray *array = [NSMutableArray array];
    for (YYCarouselViewLayoutAttributes *attribute in attributes) {
        [array addObject:[self transformLayoutAttributes:attribute]];
    }
    
    return array;
}

- (UICollectionViewLayoutAttributes *)transformLayoutAttributes:(YYCarouselViewLayoutAttributes *)attributes {
    CGFloat distance = self.collectionView.frame.size.width;
    CGFloat itemOffset = attributes.center.x - self.collectionView.contentOffset.x;
    
    attributes.middleOffset = itemOffset / distance - 0.5;
    
    [_animator animate:self.collectionView attributes:attributes];
    
    return attributes;
}

@end
