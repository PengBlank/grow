//
//  PDTabBarController.m
//  grow
//
//  Created by Luca  on 16/8/26.
//  Copyright © 2016年 snow. All rights reserved.
//

#import "PDTabBarController.h"
#import "PDEssenceViewController.h"
#import "PDNewViewController.h"
#import "PDFriendTrendsViewController.h"
#import "PDMeViewController.h"
#import "PDTabBar.h"
@interface PDTabBarController ()

@end

@implementation PDTabBarController

- (instancetype)init{
    if (self = [super init]) {
        
        PDEssenceViewController *jingHuaVC = [[PDEssenceViewController alloc]init];
        [self setupViewController:jingHuaVC title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
        jingHuaVC.view.backgroundColor = [UIColor orangeColor];
        [self addChildViewController:jingHuaVC];
        
        PDNewViewController *zuiXinVC = [[PDNewViewController alloc]init];
        zuiXinVC.view.backgroundColor = [UIColor blueColor];
        [self setupViewController:zuiXinVC title:@"最新" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
        [self addChildViewController:zuiXinVC];
        
        PDFriendTrendsViewController *guanZhuVC = [[PDFriendTrendsViewController alloc]init];
        guanZhuVC.view.backgroundColor = [UIColor redColor];
        [self setupViewController:guanZhuVC title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
        [self addChildViewController:guanZhuVC];
        
        PDMeViewController *meVC = [[PDMeViewController alloc]init];
        meVC.view.backgroundColor = [UIColor greenColor];
        [self setupViewController:meVC title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
        [self addChildViewController:meVC];
        //自定义tabbar
        [self setValue:[[PDTabBar alloc]init] forKeyPath:@"tabBar"];
  
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置tabBarItem的属性值(通过appearance全局设置一次)
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];

}


//初始化控制器
- (void)setupViewController:(UIViewController *)viewController title:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName{
    
    viewController.tabBarItem.title = title;
    //设置tabBarItem 图片
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.image = image;
    //设置tabBarItem 选中后的图片
    UIImage *selectImage = [UIImage imageNamed:selectedImageName];
    selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = selectImage;
    
}

@end
