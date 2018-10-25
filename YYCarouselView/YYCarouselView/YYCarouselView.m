//
//  YYCarouselView.m
//  YYCarouselView
//
//  Created by 沈永聪 on 2018/10/22.
//  Copyright © 2018 沈永聪. All rights reserved.
//

#import "YYCarouselView.h"
#import "YYWeakTimer.h"
#import "YYCarouselViewFlowLayout.h"
#import "YYCarouselViewTileLayout.h"
#import "YYCarouselViewStackLayout.h"

#if __OBJC__
#if DEBUG
#define YYLog(s, ...) NSLog(@"<%@:(%d)> %s \"%@\"", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __FUNCTION__,[NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define YYLog(s, ...)
#endif
#endif

@interface YYCarouselView () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation YYCarouselView {
    NSTimer *_timer;
    
    NSInteger _currentIndex;
    NSInteger _centerIndex;
    NSInteger _numberOfItems;
    
    BOOL _running;
    BOOL _showing;
}

#pragma mark - Life cycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    YYLog(@"%@ dealloc", NSStringFromClass([self class]));
}

- (instancetype)initWithFrame:(CGRect)frame type:(YYCarouselViewCellDisplayType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _duration = 1.5;
        
        [self setupcollectionViewWithType:type];
        [self setupTimer];
        [self setupObservers];
    }
    
    return self;
}

#pragma mark - Public

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (YYCarouselViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index {
    return (YYCarouselViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

- (void)reloadData {
    _numberOfItems = [self.dataSource numberOfItemsInCarouselView:self];
    [self.collectionView reloadData];
    
    _pageControl.numberOfPages = _numberOfItems;
    CGSize size = [_pageControl sizeForNumberOfPages:_numberOfItems];
    _pageControl.frame = CGRectMake((self.frame.size.width - size.width) / 2, self.frame.size.height - size.height, size.width, size.height);
}

- (void)pause {
    [_timer pause];
    _running = NO;
    [self.collectionView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];  // fix content offset if need
}

- (void)resume {
    if (!_running && _showing && _numberOfItems > 1) {
        [self.collectionView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];  // fix content offset if need
        [_timer resumeAfter:_duration];
    }
}

#pragma mark - Setup

- (void)setupcollectionViewWithType:(YYCarouselViewCellDisplayType)type {
    YYCarouselViewFlowLayout *layout = nil;
    if (type == YYCarouselViewCellDisplayTypeStack) {
        layout = [[YYCarouselViewStackLayout alloc] init];
    } else {
        layout = [[YYCarouselViewTileLayout alloc] init];
    }
    layout.itemSize = self.bounds.size;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.pagingEnabled = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self addSubview:_collectionView];
}

- (void)setupTimer {
    _timer = [YYWeakTimer timerWithTimeInterval:_duration target:self selector:@selector(keepGoing:) userInfo:nil repeats:YES];
}

- (void)setupObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - Notification handler

- (void)didEnterBackground:(NSNotification *)noti {
    [self pause];
}

- (void)willEnterForeground:(NSNotification *)noti {
    [self resume];
}

#pragma mark - Override

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    _currentIndex = 0;
    _centerIndex = 1;
    [self.collectionView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    
    if (_numberOfItems > 1) {
        [_timer resumeAfter:_duration];
        _running = YES;
    }
    _showing = YES;
}

#pragma mark - Action

- (void)keepGoing:(NSTimer *)timer {
    if (self.collectionView.contentOffset.x != self.frame.size.width) {
        [self.collectionView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];  // fix content offset if need
    }
    if (self.collectionView.contentSize.width == 0.0 || self.collectionView.dragging || self.collectionView.decelerating) {
        return;
    }
    
    CGFloat contentOffsetX = self.collectionView.contentOffset.x + self.frame.size.width;
    [self.collectionView setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger offset = 0;
    if (scrollView.contentOffset.x >= scrollView.frame.size.width * 1.5) {
        offset = 1;
    } else if (scrollView.contentOffset.x <= scrollView.frame.size.width * 0.5) {
        offset = -1;
    }
    
    _pageControl.currentPage = _currentIndex + offset >= _numberOfItems ? 0 : _currentIndex + offset < 0 ? _numberOfItems - 1 : _currentIndex + offset;
    
    if (scrollView.contentOffset.x == scrollView.frame.size.width * 2 ||
        scrollView.contentOffset.x == 0) {
        _currentIndex += offset;
        if (_currentIndex >= _numberOfItems) {
            _currentIndex = 0;
        } else if (_currentIndex < 0) {
            _currentIndex = _numberOfItems - 1;
        }
        
        if (scrollView.contentOffset.x == 0) {
            _centerIndex += 1;
            if (_centerIndex >= _numberOfItems) {
                _centerIndex = 0;
            }
        } else {
            _centerIndex -= 1;
            if (_centerIndex < 0) {
                _centerIndex = _numberOfItems - 1;
            }
        }
        
        [_timer pause];
        _running = NO;
        [self.collectionView reloadData];
        [self.collectionView setContentOffset:CGPointMake(scrollView.frame.size.width, 0)];
        if (_numberOfItems > 1) {
            [_timer resumeAfter:_duration];
            _running = YES;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timer pause];
    _running = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate && _numberOfItems > 1) {
        [_timer resumeAfter:_duration];
        _running = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_numberOfItems > 1) {
        [_timer resumeAfter:_duration];
        _running = YES;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.item;
    if (index < _centerIndex) {
        index += _numberOfItems - _centerIndex;
    } else {
        index -= _centerIndex;
    }
    return [self.dataSource carouselView:self cellForItemAtIndex:index];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(carouselView:didSelectItemAtIndex:)]) {
        [self.delegate carouselView:self didSelectItemAtIndex:_currentIndex];
    }
}

#pragma mark - Setter

- (void)setDataSource:(id<YYCarouselViewDataSource>)dataSource {
    _dataSource = dataSource;
    
    _numberOfItems = [dataSource numberOfItemsInCarouselView:self];
}

- (void)setPageControl:(YYPageControl *)pageControl {
    _pageControl = pageControl;
    
    _pageControl.numberOfPages = _numberOfItems;
    CGSize size = [_pageControl sizeForNumberOfPages:_numberOfItems];
    _pageControl.frame = CGRectMake((self.frame.size.width - size.width) / 2, self.frame.size.height - size.height, size.width, size.height);
    [self addSubview:_pageControl];
}

@end
