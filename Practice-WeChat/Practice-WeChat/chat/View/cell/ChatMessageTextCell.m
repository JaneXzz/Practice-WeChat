//
//  ChatMessageTextCell.m
//  Practice-WeChat
//
//  Created by Jane on 2017/3/23.
//  Copyright © 2017年 Jane. All rights reserved.
//

#import "ChatMessageTextCell.h"
#import "UIResponder+Extension.h"
#import "MessageConst.h"
#import "GlobalDefines.h"
#import "ChatFrame.h"
#import "ChatModel.h"

@interface ChatMessageTextCell ()<MLEmojiLabelDelegate>

@property (nonatomic, strong) MLEmojiLabel *chatLabel;


@end

@implementation ChatMessageTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.chatLabel];
    }
    return self;
}

#pragma mark - Private Method


- (void)setModelFrame:(ChatFrame *)modelFrame
{
    [super setModelFrame:modelFrame];
    self.chatLabel.frame = modelFrame.chatLabelF;
    [self.chatLabel setEmojiText:modelFrame.model.message.content];
}


- (void)urlSkip:(NSURL *)url
{
    [self routerEventWithName:GXRouterEventURLSkip userInfo:@{@"url":url}];
}

#pragma mark - Getter and Setter
- (MLEmojiLabel *)chatLabel
{
    if (nil == _chatLabel) {
        _chatLabel = [[MLEmojiLabel alloc] init];
        _chatLabel.numberOfLines = 0;
        _chatLabel.emojiDelegate = self;
        _chatLabel.font = MessageFont;
        _chatLabel.textColor = kRGB(0x282724);
        _chatLabel.backgroundColor = [UIColor clearColor];
        _chatLabel.lineBreakMode = NSLineBreakByCharWrapping;

        [_chatLabel sizeToFit];
        _chatLabel.isNeedAtAndPoundSign = YES;
    }
    return _chatLabel;
}
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{

    if ([self.clickDelegate respondsToSelector:@selector(didSelectLinkTextOperationLink:type:)]) {
        [self.clickDelegate didSelectLinkTextOperationLink:link type:type];
    }
}

@end
