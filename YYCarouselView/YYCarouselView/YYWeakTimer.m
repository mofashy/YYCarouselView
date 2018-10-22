//
//  YYWeakTimer.m
//  YYCarouselView
//
//  Created by 沈永聪 on 2018/10/22.
//  Copyright © 2018 沈永聪. All rights reserved.
//

#import "YYWeakTimer.h"

@implementation NSTimer (YYCarouselView)

- (void)pause {
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resume {
    [self setFireDate:[NSDate date]];
}

- (void)resumeAfter:(NSTimeInterval)interval {
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end


@implementation YYWeakTimer

- (void)running:(NSTimer *)timer {
    if (self.target) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:self.timer];
#pragma clang diagnostic pop
    } else {
        if ([self.timer isValid]) {
            [self.timer invalidate];
        }
        _timer = nil;
    }
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    YYWeakTimer *bridgeTimer = [[YYWeakTimer alloc] init];
    bridgeTimer.target = aTarget;
    bridgeTimer.selector = aSelector;
    bridgeTimer.timer = [NSTimer timerWithTimeInterval:ti target:bridgeTimer selector:@selector(running:) userInfo:nil repeats:YES];
    [bridgeTimer.timer pause];
    [[NSRunLoop currentRunLoop] addTimer:bridgeTimer.timer forMode:NSRunLoopCommonModes];
    
    return bridgeTimer.timer;
}

@end
