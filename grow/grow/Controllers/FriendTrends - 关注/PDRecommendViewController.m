//
//  PDRecommendViewController.m
//  grow
//
//  Created by Luca  on 16/9/6.
//  Copyright © 2016年 snow. All rights reserved.
//

#import "PDRecommendViewController.h"
#import <MJExtension.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "PDCategoryModel.h"
#import "PDCategoryCell.h"
#import "PDUserModel.h"
#import "PDUserCell.h"


@interface PDRecommendViewController () <UITableViewDelegate, UITableViewDataSource>

//存放请求的类别数据
@property (nonatomic, strong) NSArray *categories;
//推荐的用户
@property (nonatomic, strong) NSArray *users;
//左边类别table
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
//右边详情table
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@end

@implementation PDRecommendViewController

static NSString * const categoryCell = @"categoryCell";
static NSString * const userCell = @"userCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"推荐关注";
    self.view.backgroundColor = PDGlobalBG;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.categoryTableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    [self.detailTableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    self.detailTableView.rowHeight = 70;
    //注册categoryCell
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([PDCategoryCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:categoryCell];
    
    //注册UserCell
    [self.detailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([PDUserCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:userCell];
    
    //显示蒙板
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];

    //发送类别请求
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    NSString *urlString = @"http://api.budejie.com/api/api_open.php";//类别url地址

    
    paras[@"a"] = @"category";
    paras[@"c"] = @"subscribe";
    [[AFHTTPSessionManager manager] GET:urlString parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.categories = [PDCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [SVProgressHUD dismiss];
        [self.categoryTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求错误!!!"];
        NSLog(@"failure");
    }];

    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.categoryTableView) {
        return self.categories.count;
    } else {
        return self.users.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.categoryTableView) {
        PDCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryCell];
        cell.category = self.categories[indexPath.row];
        return cell;
    } else {
        PDUserCell *cell = [tableView dequeueReusableCellWithIdentifier:userCell];
        cell.user = self.users[indexPath.row];
        return cell;
    }
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    NSString *userlUrlString = @"http://api.budejie.com/api/api_open.php";//左侧类别对应的推荐用户组url
    PDCategoryModel *category = self.categories[indexPath.row];
    NSInteger category_id = category.id;
    if (tableView == self.categoryTableView) {
        //用户请求
        paras[@"a"] = @"list";
        paras[@"c"] = @"subscribe";
        paras[@"category_id"] = @(category_id);
        [[AFHTTPSessionManager manager] GET:userlUrlString parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            self.users = [PDUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            [SVProgressHUD dismiss];
            [self.detailTableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"请求错误!!!"];
            NSLog(@"failure");
        }];
    }
}
@end
