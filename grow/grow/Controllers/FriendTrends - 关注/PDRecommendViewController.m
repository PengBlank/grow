//
//  PDRecommendViewController.m
//  grow
//
//  Created by Luca  on 16/9/6.
//  Copyright © 2016年 snow. All rights reserved.
//

#import "PDRecommendViewController.h"
#import <AFNetworking.h>

@interface PDRecommendViewController ()

@end

@implementation PDRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"推荐关注";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //发送请求
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    NSString *urlString = @"http://api.budejie.com/api/api_open.php";
    paras[@"a"] = @"category";
    paras[@"c"] = @"subscribe";
    [manager GET:urlString parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
}

@end
