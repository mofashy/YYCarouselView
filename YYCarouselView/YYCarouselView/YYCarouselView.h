//
//  YYCarouselView.h
//  YYCarouselView
//
//  Created by 沈永聪 on 2018/10/22.
//  Copyright © 2018 沈永聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYPageControl.h"
#import "YYCarouselViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YYCarouselViewCellDisplayType) {
    YYCarouselViewCellDisplayTypeTile = 0,
    YYCarouselViewCellDisplayTypeStack,
};

@protocol YYCarouselViewDataSource, YYCarouselViewDelegate;

@interface YYCarouselView : UIView
@property (strong, nonatomic, readonly) UICollectionView *collectionView;
@property (strong, nonatomic, nullable) YYPageControl *pageControl;

@property (assign, nonatomic) CGFloat duration;

@property (weak, nonatomic) id<YYCarouselViewDataSource> dataSource;
@property (weak, nonatomic) id<YYCarouselViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame type:(YYCarouselViewCellDisplayType)type;

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (YYCarouselViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

- (void)reloadData;

- (void)pause;
- (void)resume;
@end


@protocol YYCarouselViewDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInCarouselView:(YYCarouselView *)carouselView;
- (YYCarouselViewCell *)carouselView:(YYCarouselView *)carouselView cellForItemAtIndex:(NSInteger)index;
@end


@protocol YYCarouselViewDelegate <NSObject>
@optional
- (void)carouselView:(YYCarouselView *)carouselView didSelectItemAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
