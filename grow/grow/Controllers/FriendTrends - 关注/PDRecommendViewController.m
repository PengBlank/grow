//
//  PDRecommendViewController.m
//  grow
//
//  Created by Luca  on 16/9/6.
//  Copyright © 2016年 snow. All rights reserved.
//

#import "PDRecommendViewController.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "PDCategoryModel.h"
#import "PDCategoryCell.h"
#import "PDUserModel.h"
#import "PDUserCell.h"
#import <MJRefreshFooter.h>


#define selectedCategory self.categories[self.categoryTableView.indexPathForSelectedRow.row]

@interface PDRecommendViewController () <UITableViewDelegate, UITableViewDataSource>

//存放请求的类别数据
@property (nonatomic, strong) NSArray *categories;
//推荐的用户
//@property (nonatomic, strong) NSArray *users;

//@property (nonatomic, strong) PDCategoryModel *category;

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
    
    [self setUpTableView];//初始化tableView
    
    [self setUpRefresh];//初始化刷新控件
    
}



- (void)setUpTableView{
    
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


- (void)setUpRefresh{
    self.detailTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(showMoreData)];//上拉刷新
}


- (void)showMoreData{
    
    PDCategoryModel *tempCategory = selectedCategory;
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    NSString *userlUrlString = @"http://api.budejie.com/api/api_open.php";//左侧类别对应的推荐用户组url
    NSInteger category_id = tempCategory.id;
    //用户请求
    paras[@"a"] = @"list";
    paras[@"c"] = @"subscribe";
    paras[@"category_id"] = @(category_id);
    paras[@"page"] = @(++ tempCategory.currentPage);
    [[AFHTTPSessionManager manager] GET:userlUrlString parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        PDLog(@"%@",responseObject);
        [SVProgressHUD dismiss];
        NSArray *users = [NSArray array];
        //字典array-->模型array
        users = [PDUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [tempCategory.users addObjectsFromArray:users];
        ///该类别对应的user总数
        NSInteger total = [responseObject[@"total"] integerValue];
        tempCategory.total = total;
        if (tempCategory.users.count < total) {//当还有数据时
//            tempCategory.currentPage = 
            [self.detailTableView.mj_footer endRefreshing];
        } else {//当没有更多数据
            [self.detailTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.detailTableView reloadData];
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
        PDCategoryModel *category = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
        //当类别没有对应的用户数据时，隐藏刷新控件
        self.detailTableView.mj_footer.hidden = (category.users.count == 0);
        return category.users.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.categoryTableView) {
        PDCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryCell];
        cell.category = self.categories[indexPath.row];
        return cell;
    } else {
        PDUserCell *cell = [tableView dequeueReusableCellWithIdentifier:userCell];
        PDCategoryModel *category = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
        //不能用下面这种方式寻找对应的模型，找到的模型应该为选中类别对应的users.
//        PDCategoryModel *category = self.categories[indexPath.row];
        cell.user = category.users[indexPath.row];
        return cell;
    }
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    NSInteger currentPage = 1;
    PDCategoryModel *tmpeCategory = self.categories[indexPath.row];
    if (tmpeCategory.users.count != 0) {//如果缓存有数据，则用缓存数据，否则网络请求新的数据.
        [self.detailTableView reloadData];
    } else {
        NSMutableDictionary *paras = [NSMutableDictionary dictionary];
        NSString *userlUrlString = @"http://api.budejie.com/api/api_open.php";//左侧类别对应的推荐用户组url
        NSInteger category_id = tmpeCategory.id;
        if (tableView == self.categoryTableView) {
            //用户请求
            paras[@"a"] = @"list";
            paras[@"c"] = @"subscribe";
            paras[@"category_id"] = @(category_id);
            paras[@"page"] = @(currentPage);
            [[AFHTTPSessionManager manager] GET:userlUrlString parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                PDLog(@"%@",responseObject);
                [SVProgressHUD dismiss];
                NSArray *users = [NSArray array];
                users = [PDUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
                [tmpeCategory.users addObjectsFromArray:users];
                ///该类别对应的user总数
                NSInteger total = [responseObject[@"total"] integerValue];
                tmpeCategory.total = total;
                if (users.count < total) {//当有多页数据时
                    [self.detailTableView.mj_footer endRefreshing];
                } else {//当只有一页数据
                    [self.detailTableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self.detailTableView reloadData];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SVProgressHUD showErrorWithStatus:@"请求错误!!!"];
                NSLog(@"failure");
            }];
        }
    }
    
    

}
@end
