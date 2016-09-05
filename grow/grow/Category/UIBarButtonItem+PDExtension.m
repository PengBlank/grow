//
//  UIBarButtonItem+PDExtension.m
//  grow
//
//  Created by Luca  on 16/9/2.
//  Copyright © 2016年 snow. All rights reserved.
//

#import "UIBarButtonItem+PDExtension.h"

@implementation UIBarButtonItem (PDExtension)

+ (UIBarButtonItem *)buttonWithImage:(NSString *)imageName highlightImage:(NSString *)highlightImageName target:(id)target action:(SEL)selector{
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBarButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [leftBarButton setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    [leftBarButton sizeToFit];
    [leftBarButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarButton];
    return buttonItem;
}

@end
