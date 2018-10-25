//
//  YYCarouselViewController.h
//  YYCarouselView
//
//  Created by 沈永聪 on 2018/10/25.
//  Copyright © 2018 沈永聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYCarouselView.h"
#import "YYPageControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYCarouselViewController : UIViewController
@property (assign, nonatomic) YYCarouselViewCellDisplayType type;
@property (assign, nonatomic) YYPageControlType pageControlType;
@end

NS_ASSUME_NONNULL_END
