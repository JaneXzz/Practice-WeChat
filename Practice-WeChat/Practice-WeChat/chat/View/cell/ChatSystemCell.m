//
//  ChatSystemCell.m
//  XZ_WeChat
//
//  Created by 郭现壮 on 16/6/7.
//  Copyright © 2016年 gxz All rights reserved.
//

#import "ChatSystemCell.h"
#import "ChatFrame.h"
#import "ChatModel.h"
#import "Message.h"
#import "GlobalDefines.h"
#import "NSString+Extension.h"

#define labelFont [UIFont systemFontOfSize:11.0]

@interface ChatSystemCell ()

@property (nonatomic, weak) UILabel *contentLabel;

@end

@implementation ChatSystemCell

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    ChatSystemCell *cell = [[ChatSystemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *contentLabel = [[UILabel alloc] init];
        [self addSubview:contentLabel];
        self.contentLabel = contentLabel;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentLabel.backgroundColor = kRGB(0xd3d2d2);
        self.contentLabel.textColor = [UIColor whiteColor];
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.font = [UIFont systemFontOfSize:11.0];
        self.contentLabel.layer.masksToBounds = YES;
        self.contentLabel.layer.cornerRadius = 4.0;
        CGRect contentF = self.contentLabel.frame;
        contentF.size.width = APP_WIDTH-40;
        self.contentLabel.frame = contentF;
        self.contentLabel.numberOfLines = 0;
    }
    return self;
}

- (void)setMessageF:(ChatFrame *)messageF
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGSize size = [messageF.model.message.content sizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width - 40 andFont:labelFont];
    if (size.width > width-40) {
        size.width = width - 40;
    }
    
    CGRect contentF = self.contentLabel.frame;
    contentF.size.width = size.width+20;
    contentF.size.height = size.height+3;
    self.contentLabel.frame = contentF;
    self.contentLabel.center = CGPointMake(width*0.5, (size.height+10)*0.5);
    _messageF = messageF;
    self.contentLabel.text = messageF.model.message.content;
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];
}


@end
