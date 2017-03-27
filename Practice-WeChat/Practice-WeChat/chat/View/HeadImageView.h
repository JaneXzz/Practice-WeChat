//
//  HeadImageView.h
//  Practice-WeChat
//
//  Created by Jane on 2017/3/23.
//  Copyright © 2017年 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadImageView : UIView

@property (nonatomic, strong) UIImageView *imageView;

- (void)setColor:(UIColor *)color bording:(CGFloat)bording;

@end
