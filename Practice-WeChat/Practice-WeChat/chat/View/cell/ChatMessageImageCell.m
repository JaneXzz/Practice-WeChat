//
//  ChatMessageImageCell.m
//  Practice-WeChat
//
//  Created by Jane on 2017/3/23.
//  Copyright © 2017年 Jane. All rights reserved.
//

#import "ChatMessageImageCell.h"
#import "MessageConst.h"
#import "UIResponder+Extension.h"
#import "MessageHelper.h"
#import "MediaManager.h"
#import "ChatModel.h"
#import "ChatFrame.h"
#import "FileTool.h"

@interface ChatMessageImageCell ()
/** 点击图片按钮 */
@property (nonatomic, strong) UIButton *imageBtn;

@end

@implementation ChatMessageImageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.imageBtn];
    }
    return self;
}


- (void)imageBtnClick:(UIButton *)btn
{
    if (btn.currentBackgroundImage == nil) {
        return;
    }
    CGRect smallRect = [MessageHelper photoFramInWindow:btn];
    CGRect bigRect = [MessageHelper photoLargerInWindow:btn];
    NSValue *smallValue = [NSValue valueWithCGRect:smallRect];
    NSValue *bigValue = [NSValue valueWithCGRect:bigRect];
    [self routerEventWithName:GXRouterEventImageTapEventName
                     userInfo:@{MessageKey   : self.modelFrame,
                                @"smallRect" : smallValue,
                                @"bigRect"   : bigValue
                                }];
}
#pragma mark - Private Method

- (void)setModelFrame:(ChatFrame *)modelFrame
{
    [super setModelFrame:modelFrame];
    MediaManager *manager = [MediaManager sharedManager];
    UIImage *image = [manager imageWithLocalPath:[manager imagePathWithName:modelFrame.model.mediaPath.lastPathComponent]];
    self.imageBtn.frame = modelFrame.picViewF;
    self.bubbleView.userInteractionEnabled = _imageBtn.imageView.image != nil;
    self.bubbleView.image = nil;
    [self.imageBtn setBackgroundImage:image forState:UIControlStateNormal];
}

#pragma mark - Getter

- (UIButton *)imageBtn
{
    if (nil == _imageBtn) {
        _imageBtn = [[UIButton alloc] init];
        [_imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _imageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _imageBtn.layer.masksToBounds = YES;
        _imageBtn.layer.cornerRadius = 5;
        _imageBtn.clipsToBounds = YES;
    }
    return _imageBtn;
}


@end
