
//
//  PDUserCell.m
//  grow
//
//  Created by Luca  on 16/9/8.
//  Copyright © 2016年 snow. All rights reserved.
//

#import "PDUserCell.h"
#import "PDUserModel.h"
#import <UIImageView+WebCache.h>


@interface PDUserCell ()
///个人头像
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
///用户昵称
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
///粉丝数
@property (weak, nonatomic) IBOutlet UILabel *fansNumLabel;

@end


@implementation PDUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.headImage.layer.cornerRadius = 18;
    
}


- (void)setUser:(PDUserModel *)user{
    _user = user;
    ///设置头像
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:user.header] placeholderImage:[UIImage imageNamed:@"post_placeholderImage"]];
    self.userNameLabel.text = user.screen_name;
    self.fansNumLabel.text = [NSString stringWithFormat:@"%zd个粉丝数",user.fans_count];
}

@end
