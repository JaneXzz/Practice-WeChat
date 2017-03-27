//
//  HeadImageView.m
//  Practice-WeChat
//
//  Created by Jane on 2017/3/23.
//  Copyright © 2017年 Jane. All rights reserved.
//

#import "HeadImageView.h"

#define XZRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]


@interface HeadImageView()

@property (nonatomic, assign) CGFloat bordering;

@end

@implementation HeadImageView

- (instancetype)init
{
    if (self = [super init]) {
        [self imageView];
        self.layer.masksToBounds  = YES;
        self.backgroundColor      = XZRGB(0xf0f0f0);
        //        self.bordering            = 4;
        self.bordering            = 0;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    self.layer.cornerRadius = self.frame.size.width*0.5;
    
    CGRect temp = self.frame;
    temp.size.width = self.frame.size.width-_bordering;
    temp.size.height = self.frame.size.height-_bordering;
    self.imageView.frame = temp;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width*0.5;
    CGPoint pointTemp ;
    pointTemp.x = self.frame.size.height*0.5;
    pointTemp.y = self.frame.size.height*0.5;
    self.imageView.center = pointTemp;
}

- (void)setColor:(UIColor *)color bording:(CGFloat)bord
{
    self.backgroundColor = color;
    self.bordering = bord;
}

- (UIImageView *)imageView
{
    if (nil == _imageView) {
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.layer.masksToBounds = YES;
        [self addSubview:imageV];
        _imageView = imageV;
    }
    return _imageView;
}

@end
