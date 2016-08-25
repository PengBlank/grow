//
//  PDTabBarController.m
//  grow
//
//  Created by Luca  on 16/8/26.
//  Copyright © 2016年 snow. All rights reserved.
//

#import "PDTabBarController.h"
#import "PDJinghuaViewController.h"
#import "PDZuiXinViewController.h"
#import "PDGuanZhuViewController.h"
#import "PDMeViewController.h"

@interface PDTabBarController ()

@end

@implementation PDTabBarController

- (instancetype)init{
    if (self = [super init]) {
        PDJinghuaViewController *jingHuaVC = [[PDJinghuaViewController alloc]init];
        jingHuaVC.view.backgroundColor = [UIColor orangeColor];
        jingHuaVC.tabBarItem.title = @"精华";
        jingHuaVC.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
        jingHuaVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_essence_click_icon"];
        [self addChildViewController:jingHuaVC];
        
        PDZuiXinViewController *zuiXinVC = [[PDZuiXinViewController alloc]init];
        zuiXinVC.view.backgroundColor = [UIColor blueColor];
        zuiXinVC.tabBarItem.title = @"最新";
        zuiXinVC.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
        zuiXinVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_new_click_icon"];
        [self addChildViewController:zuiXinVC];
        
        PDGuanZhuViewController *guanZhuVC = [[PDGuanZhuViewController alloc]init];
        guanZhuVC.view.backgroundColor = [UIColor redColor];
        guanZhuVC.tabBarItem.title = @"关注";
        guanZhuVC.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
        guanZhuVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_friendTrends_click_icon"];
        [self addChildViewController:guanZhuVC];
        
        PDMeViewController *meVC = [[PDMeViewController alloc]init];
        meVC.view.backgroundColor = [UIColor greenColor];
        meVC.tabBarItem.title = @"我";
        meVC.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
        meVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_me_click_icon"];
        [self addChildViewController:meVC];
        
        self.selectedViewController = meVC;
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

@end
