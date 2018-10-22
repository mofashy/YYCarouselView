//
//  ViewController.m
//  YYCarouselView
//
//  Created by 沈永聪 on 2018/10/22.
//  Copyright © 2018 沈永聪. All rights reserved.
//

#import "ViewController.h"
#import "YYCarouselView.h"

@interface ViewController () <YYCarouselViewDataSource, YYCarouselViewDelegate>
@property (strong, nonatomic) YYCarouselView *carouselView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    YYCarouselView *view = [[YYCarouselView alloc] initWithFrame:CGRectMake(20, 100, CGRectGetWidth(self.view.frame) - 40, (CGRectGetWidth(self.view.frame) - 40) * 9 / 16) type:YYCarouselViewCellDisplayTypeStack];
    view.dataSource = self;
    view.delegate = self;
    [self.view addSubview:view];
    _carouselView = view;
    
    view.pageControl = [[YYPageControl alloc] initWithType:YYPageControlTypeRing];
    
    [view registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"XYZ"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_carouselView pause];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_carouselView resume];
}

- (NSInteger)numberOfItemsInCarouselView:(YYCarouselView *)carouselView {
    return 3;
}

- (YYCarouselViewCell *)carouselView:(YYCarouselView *)carouselView cellForItemAtIndex:(NSInteger)index {
    YYCarouselViewCell *cell = [carouselView dequeueReusableCellWithReuseIdentifier:@"XYZ" forIndex:index];
    
    cell.contentView.backgroundColor = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor]][index % 3];
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = cell.bounds;
    label.text = [NSString stringWithFormat:@"%ld", index];
    [cell.contentView addSubview:label];
    
    return cell;
}

- (void)carouselView:(YYCarouselView *)carouselView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"select %ld", index);
}

@end
