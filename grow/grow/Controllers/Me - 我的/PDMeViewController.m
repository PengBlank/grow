//
//  PDMeViewController.m
//  grow
//
//  Created by Luca  on 16/8/26.
//  Copyright © 2016年 snow. All rights reserved.
//

#import "PDMeViewController.h"
#import "UIBarButtonItem+PDExtension.h"

@interface PDMeViewController ()

@end
// 我
@implementation PDMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的";
    self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem buttonWithImage:@"mine-setting-icon" highlightImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)],[UIBarButtonItem buttonWithImage:@"mine-moon-icon" highlightImage:@"mine-moon-icon-click" target:self action:@selector(moonClick)]];
}

- (void)settingClick{
    
}

- (void)moonClick{
    
}
@end
