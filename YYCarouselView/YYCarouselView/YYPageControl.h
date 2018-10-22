//
//  YYPageControl.h
//  YYCarouselView
//
//  Created by 沈永聪 on 2018/10/22.
//  Copyright © 2018 沈永聪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YYPageControlType) {
    YYPageControlTypeDot = 0,
    YYPageControlTypeDash,
    YYPageControlTypeRing,
};

@interface YYPageControl : UIControl

- (instancetype)initWithType:(YYPageControlType)type;
- (instancetype)initWithFrame:(CGRect)frame type:(YYPageControlType)type;

@property (assign, nonatomic) YYPageControlType type;

@property (assign, nonatomic) NSInteger numberOfPages;
@property (assign, nonatomic) NSInteger currentPage;

@property (assign, nonatomic) BOOL hidesForSinglePage;

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

@property (strong, nonatomic, nullable) UIColor *pageIndicatorTintColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic, nullable) UIColor *currentPageIndicatorTintColor UI_APPEARANCE_SELECTOR;
@end

NS_ASSUME_NONNULL_END
