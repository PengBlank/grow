//
//  PDCategoryCell.m
//  grow
//
//  Created by Luca  on 16/9/6.
//  Copyright © 2016年 snow. All rights reserved.
//

#import "PDCategoryCell.h"
#import "PDCategoryModel.h"


@interface PDCategoryCell ()
//选中状态下左边的竖线
@property (weak, nonatomic) IBOutlet UIView *lineView;
//cell的分隔线
@property (weak, nonatomic) IBOutlet UIView *seperatorLine;

@end

@implementation PDCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setCategory:(PDCategoryModel *)category{
    _category = category;
    self.textLabel.text = category.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.lineView.backgroundColor = selected?[UIColor redColor]:PDRGBColor(239, 239, 239);
    self.textLabel.textColor = selected?[UIColor redColor]:PDRGBColor(100, 100, 100);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat originHeight = self.textLabel.frame.size.height - 2 * self.seperatorLine.frame.size.height;
    CGPoint point = CGPointMake(self.textLabel.frame.origin.x, self.seperatorLine.frame.size.height );
    self.textLabel.frame = CGRectMake(point.x, point.y, self.textLabel.frame.size.width, originHeight);
}

@end
