//
//  PDZuiXinViewController.m
//  grow
//
//  Created by Luca  on 16/8/26.
//  Copyright © 2016年 snow. All rights reserved.
//

#import "PDNewViewController.h"

@interface PDNewViewController ()

@end
// 最新
@implementation PDNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonWithImage:@"MainTagSubIcon" highlightImage:@"MainTagSubIconClick"];
    
    self.navigationItem.titleView = titleView;
}

@end
