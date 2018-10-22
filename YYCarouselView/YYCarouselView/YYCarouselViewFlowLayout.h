//
//  YYCarouselViewFlowLayout.h
//  YYCarouselView
//
//  Created by 沈永聪 on 2018/10/22.
//  Copyright © 2018 沈永聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYCarouselViewLayoutAttributes.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YYCarouselViewAnimatorProtocol <NSObject>
- (void)animate:(UICollectionView *)collectionView attributes:(YYCarouselViewLayoutAttributes *)attributes;
@end


@interface YYCarouselViewStackAnimator : NSObject <YYCarouselViewAnimatorProtocol>
@property (assign, nonatomic) CGFloat percent;

- (instancetype)initWithPercent:(CGFloat)percent;
@end

@interface YYCarouselViewFlowLayout : UICollectionViewFlowLayout

@end

NS_ASSUME_NONNULL_END
