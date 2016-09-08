//
//  PDUserModel.h
//  grow
//
//  Created by Luca  on 16/9/8.
//  Copyright © 2016年 snow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDUserModel : NSObject

@property (nonatomic, strong) NSString *screen_name;
///个人头像url地址
@property (nonatomic, strong) NSString *header;
///粉丝数
@property (nonatomic, assign) NSUInteger fans_count;

@end

