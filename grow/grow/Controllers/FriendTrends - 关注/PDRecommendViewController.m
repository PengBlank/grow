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


#define selectedCategory self.categories[self.categoryTableView.indexPathForSelectedRow.row]

@interface PDRecommendViewController () <UITableViewDelegate, UITableViewDataSource>

//存放请求的类别数据
@property (nonatomic, strong) NSArray *categories;
//左边类别table
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
//右边详情table
@property (weak, nonatomic) IBOutlet UITableView *userTableView;

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
    [self.userTableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    self.userTableView.rowHeight = 70;
    //注册categoryCell
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([PDCategoryCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:categoryCell];
    
    //注册UserCell
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([PDUserCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:userCell];
    
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
        //默认显示第一个类别对应的用户数据
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.categoryTableView selectRowAtIndexPath:indexPath animated:NO  scrollPosition:UITableViewScrollPositionTop];
        [self loadNewData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求错误!!!"];
        NSLog(@"failure");
    }];

}


- (void)setUpRefresh{
    
    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];//下拉刷新
    self.userTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(showMoreData)];//上拉刷新
}


- (void)loadNewData{

    NSInteger currentPage = 1;
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    NSString *userUrlString = @"http://api.budejie.com/api/api_open.php";//左侧类别对应的推荐用户组url
    PDCategoryModel *selectModel = ((PDCategoryModel *)selectedCategory);//当前选中的模型
    NSInteger category_id = selectModel.id;
    selectModel.currentPage = currentPage;
        //用户请求
        paras[@"a"] = @"list";
        paras[@"c"] = @"subscribe";
        paras[@"category_id"] = @(category_id);
        paras[@"page"] = @(currentPage);
        [[AFHTTPSessionManager manager] GET:userUrlString parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            PDLog(@"%@",responseObject);
            [SVProgressHUD dismiss];
            selectModel.total = [[responseObject objectForKey:@"total"] intValue];//取得当前数据的总数
            [selectModel.users removeAllObjects];//每次下拉刷新都清除上一次数据。
            NSArray *users = [NSArray array];
            users = [PDUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            
            [selectModel.users addObjectsFromArray:users];
            
            [self.userTableView reloadData];

            [self.userTableView.mj_header endRefreshing];
            //下拉刷新需要判断foot的显示，否则foot可能显示错误(当第一页为最后一页数据时)
            if(selectModel.users.count == selectModel.total){//当数据加载完成,结束刷新并提示没有更多数据
                [self.userTableView.mj_footer endRefreshingWithNoMoreData];
            }else{//结束刷新
                [self.userTableView.mj_footer endRefreshing];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"请求错误!!!"];
            [self.userTableView.mj_header endRefreshing]; //失败也要结束下拉刷新
            NSLog(@"failure");
        }];
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
        tempCategory.total = [responseObject[@"total"] integerValue];
        if (tempCategory.users.count < tempCategory.total) {//当还有数据时
            [self.userTableView.mj_footer endRefreshing];
        } else {//当没有更多数据
            [self.userTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.userTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求错误!!!"];
        [self.userTableView.mj_footer endRefreshing];
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
        self.userTableView.mj_footer.hidden = (category.users.count == 0);
        
        //每次选择左边类别都回调用此方法，都要在此判断右边tableview foot的显示，因为右边的tableview是共用的,每次都应该根据左边的数据来显示，否则可能显示跟之前一次一样
        if (category.users.count == category.total) {
            [self.userTableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.userTableView.mj_footer endRefreshing];
        }
        
        
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
    
    if (tableView == self.categoryTableView) {
        PDCategoryModel *tmpeCategory = self.categories[indexPath.row];
        if (tmpeCategory.users.count) {//如果缓存有数据，则用缓存数据，否则用网络请求新的数据.
            [self.userTableView reloadData];
        } else {
            //选中类别后立即刷新user数据, 以防显示老数据
            [self.userTableView reloadData];
            //请求新数据时开始下拉刷新(会自动调用loadNewData)
            [self.userTableView.mj_header beginRefreshing];
//            [self loadNewData];
        }
        
    } else {
        [self tableView:self.userTableView didDeselectRowAtIndexPath:indexPath];
    }

}
@end
