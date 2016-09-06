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

@interface PDRecommendViewController () <UITableViewDelegate, UITableViewDataSource>

//存放请求的类别数据
@property (nonatomic, strong) NSArray *categories;
//左边类别table
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;

@end

@implementation PDRecommendViewController

static NSString * const categoryCell = @"CategoryCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"推荐关注";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //注册cell
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([PDCategoryCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:categoryCell];
    
    //显示蒙板
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];

    //发送请求
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    NSString *urlString = @"http://api.budejie.com/api/api_open.php";
    paras[@"a"] = @"category";
    paras[@"c"] = @"subscribe";
    [manager GET:urlString parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
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
    return self.categories.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PDCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryCell];
    cell.category = self.categories[indexPath.row];
    return cell;
}
@end
