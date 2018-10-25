//
//  ViewController.m
//  YYCarouselView
//
//  Created by 沈永聪 on 2018/10/22.
//  Copyright © 2018 沈永聪. All rights reserved.
//

#import "ViewController.h"
#import "YYCarouselViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *types;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _types = @[@"Delegate+Stack+Dot",
               @"Delegate+Tile+Ring"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _types.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ViewControllerTableCell"];
    cell.textLabel.text = _types[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YYCarouselViewController *vc = [[YYCarouselViewController alloc] init];
    if (indexPath.row == 0) {
        vc.type = YYCarouselViewCellDisplayTypeStack;
        vc.pageControlType = YYPageControlTypeDot;
    } else {
        vc.type = YYCarouselViewCellDisplayTypeTile;
        vc.pageControlType = YYPageControlTypeRing;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
