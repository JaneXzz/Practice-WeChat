//
//  ChatMessageBaseCell.h
//  Practice-WeChat
//
//  Created by Jane on 2017/3/23.
//  Copyright © 2017年 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"


@class ChatMessageBaseCell;
@class ChatFrame;
@class HeadImageView;

@protocol BaseCellDelegate <NSObject>

- (void)longPress:(UILongPressGestureRecognizer *)longRecognizer;
/**
 返还文本中特殊字符 type字符类型, link为字符串
 例如: link:http://baidu.com type MLEmojiLabelLinkTypeURL
 */
- (void)didSelectLinkTextOperationLink:(NSString *)link  type:(MLEmojiLabelLinkType)type;

@optional
//点击头像触发方法
- (void)headImageClicked:(NSString *)eId;
//重新发送消息
- (void)reSendMessage:(ChatMessageBaseCell *)baseCell;

@end

@interface ChatMessageBaseCell : UITableViewCell

@property (nonatomic, weak) id<BaseCellDelegate> clickDelegate;

// 消息模型
@property (nonatomic, strong) ChatFrame *modelFrame;
// 头像
@property (nonatomic, strong) HeadImageView *headImageView;
// 内容气泡视图
@property (nonatomic, strong) UIImageView *bubbleView;
// 菊花视图所在的view
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
// 重新发送
@property (nonatomic, strong) UIButton *retryButton;

@end
