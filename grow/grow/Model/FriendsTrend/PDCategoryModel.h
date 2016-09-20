//
//  PDRecommendModel.h
//  grow
//
//  Created by Luca  on 16/9/6.
//  Copyright © 2016年 snow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDCategoryModel : NSObject

//类别名
@property (nonatomic, strong) NSString *name;
//类别id
@property (nonatomic, assign) NSInteger id;


///该类别对应的user数据
@property (nonatomic, strong) NSMutableArray *users;
///该类别对应的user总数
@property (nonatomic, assign) NSInteger total;
///该类别对应user的页面数
@property (nonatomic, assign) NSInteger currentPage;


@end
