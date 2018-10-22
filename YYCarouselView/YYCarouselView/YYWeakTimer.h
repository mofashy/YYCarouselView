//
//  YYWeakTimer.h
//  YYCarouselView
//
//  Created by 沈永聪 on 2018/10/22.
//  Copyright © 2018 沈永聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (YYCarouselView)
- (void)pause;
- (void)resume;
- (void)resumeAfter:(NSTimeInterval)interval;
@end


@interface YYWeakTimer : NSObject
@property (weak, nonatomic) id target;
@property (assign, nonatomic) SEL selector;
@property (strong, nonatomic) NSTimer *timer;

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;
@end

NS_ASSUME_NONNULL_END
