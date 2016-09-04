//
//  PDTabBar.m
//  grow
//
//  Created by Luca  on 16/8/26.
//  Copyright © 2016年 snow. All rights reserved.
//

#import "PDTabBar.h"

@interface PDTabBar ()
///发布Button
@property (nonatomic, strong) UIButton *publishButton;

@end

@implementation PDTabBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.publishButton = [[UIButton alloc]initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"tabBar_publish_icon"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *highlightImage = [UIImage imageNamed:@"tabBar_publish_click_icon"];
        highlightImage = [highlightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_publishButton setBackgroundImage:image forState:UIControlStateNormal];
        [_publishButton setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
        [_publishButton sizeToFit];
        [self addSubview:_publishButton];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    //设置发布按钮的位置
    self.publishButton.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    //移动其他的tabbarButton
    CGFloat buttonY = 0;
    CGFloat buttonW = self.frame.size.width / 5;
    CGFloat buttonH = self.frame.size.height;
    int index = 0;
    for (UIView *button in self.subviews) {
        if ([button isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            button.frame = CGRectMake((index > 1 ? (index + 1) : index)* buttonW, buttonY, buttonW, buttonH);
            index ++;
        }
       
    }
}

@end
