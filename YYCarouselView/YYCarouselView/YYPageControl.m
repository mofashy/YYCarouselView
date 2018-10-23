//
//  YYPageControl.m
//  YYCarouselView
//
//  Created by 沈永聪 on 2018/10/22.
//  Copyright © 2018 沈永聪. All rights reserved.
//

#import "YYPageControl.h"

@implementation YYPageControl {
    UIEdgeInsets _insets;
    CGFloat _itemSpacing;
    CGSize _itemSize;
}

- (instancetype)initWithType:(YYPageControlType)type {
    self = [super init];
    if (self) {
        _type = type;
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame type:(YYPageControlType)type {
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    
    _insets = UIEdgeInsetsMake(10, 10, 10, 10);
    _itemSpacing = 7;
    _pageIndicatorTintColor = [UIColor lightGrayColor];
    _currentPageIndicatorTintColor = [UIColor grayColor];
    if (_type == YYPageControlTypeDot) {
        _itemSize = CGSizeMake(7, 7);
    } else if (_type == YYPageControlTypeDash) {
        _itemSize = CGSizeMake(10, 4);
    } else if (_type == YYPageControlTypeRing) {
        _itemSize = CGSizeMake(7, 7);
    } else {
        _itemSize = CGSizeMake(10, 4);
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (int i = 0; i < _numberOfPages; i++) {
        CGFloat x = _insets.left + i * (_itemSize.width + _itemSpacing);
        CGFloat y = _insets.top;
        
        CGContextSetFillColorWithColor(context, [i == _currentPage ? _currentPageIndicatorTintColor : _pageIndicatorTintColor CGColor]);
        if (_type == YYPageControlTypeDot) {
            CGContextFillEllipseInRect(context, (CGRect){{x, y}, _itemSize});
        } else if (_type == YYPageControlTypeDash) {
            CGContextFillRect(context, (CGRect){{x, y}, _itemSize});
        } else if (_type == YYPageControlTypeRing) {
            CGContextSetLineWidth(context, 2);
            CGContextSetStrokeColorWithColor(context, [i == _currentPage ? _currentPageIndicatorTintColor : _pageIndicatorTintColor CGColor]);
            CGContextAddEllipseInRect(context, (CGRect){{x, y}, _itemSize});
            CGContextStrokePath(context);
            
            if (i == _currentPage) {
                CGContextFillEllipseInRect(context, (CGRect){{x, y}, _itemSize});
            }
        } else {
            if (i == _currentPage) {
                CGContextFillRect(context, CGRectMake(_insets.left, y, x + _itemSize.width - _insets.left, _itemSize.height));
            } else if ( i > _currentPage) {
                CGContextFillRect(context, (CGRect){{x, y}, _itemSize});
            }
        }
    }
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount {
    return CGSizeMake(_insets.left + _insets.right + (pageCount - 1) * _itemSpacing + pageCount * _itemSize.width, _insets.top + _insets.bottom + _itemSize.height);
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    
    [self setNeedsDisplay];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    
    if (numberOfPages <= 1 && _hidesForSinglePage) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
}

@end
