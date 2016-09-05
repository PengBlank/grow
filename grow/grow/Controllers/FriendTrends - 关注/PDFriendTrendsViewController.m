//
//  PDGuanZhuViewController.m
//  grow
//
//  Created by Luca  on 16/8/26.
//  Copyright © 2016年 snow. All rights reserved.
//

#import "PDFriendTrendsViewController.h"
#import "UIBarButtonItem+PDExtension.h"
#import "PDRecommendViewController.h"
//关注
@interface PDFriendTrendsViewController ()

@end

@implementation PDFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关注";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonWithImage:@"friendsRecommentIcon" highlightImage:@"friendsRecommentIcon-click" target:self action:@selector(friendClick)];
    
}

- (void)friendClick{
//    NSLog(@"friend Click");
    PDRecommendViewController *recommendVC = [[PDRecommendViewController alloc]init];
    [self.navigationController pushViewController:recommendVC animated:YES];
}
@end
