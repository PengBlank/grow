//
//  PDNavigationViewController.m
//  grow
//
//  Created by Luca  on 16/9/5.
//  Copyright © 2016年 snow. All rights reserved.
//

#import "PDNavigationViewController.h"

@interface PDNavigationViewController ()

@end

@implementation PDNavigationViewController


//当类第一次使用时，调用此方法.
+ (void)initialize{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

}


/**
 *  拦截push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count > 0) {
        UIButton *backItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [backItem addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [backItem setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [backItem setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [backItem setTitle:@"返回" forState:UIControlStateNormal];
        [backItem setTitle:@"返回" forState:UIControlStateHighlighted];
        backItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        backItem.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [backItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backItem setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [backItem sizeToFit];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backItem];
        //隐藏Tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    //这句代码放在后面，让viewController可以覆盖上面设置的leftBarButtonItem.
    [super pushViewController:viewController animated:animated];

}

- (void)back{
    [self popViewControllerAnimated:YES];
}

@end
