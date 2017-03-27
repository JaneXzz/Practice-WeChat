//
//  ChatMessageVideoCell.m
//  Practice-WeChat
//
//  Created by Jane on 2017/3/23.
//  Copyright © 2017年 Jane. All rights reserved.
//

#import "ChatMessageVideoCell.h"
#import "ChatModel.h"
#import "ChatFrame.h"
#import "MessageConst.h"
#import "MediaManager.h"
#import "VideoManager.h"
#import "ICAVPlayer.h"
#import "GlobalDefines.h"
#import "FileTool.h"

@interface ChatMessageVideoCell ()

@property (nonatomic, strong) UIButton *imageBtn;
@property (nonatomic, strong) UIImageView *playImageView;

@end



@implementation ChatMessageVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.imageBtn];
        [self.contentView addSubview:self.playImageView];
    }
    return self;
}

- (void)setModelFrame:(ChatFrame *)modelFrame
{
    [super setModelFrame:modelFrame];
    [self.imageBtn setImage:nil forState:UIControlStateNormal];

    MediaManager *manager = [MediaManager sharedManager];
    
    NSString *path = [[VideoManager shareManager] receiveVideoPathWithFileKey:[modelFrame.model.mediaPath.lastPathComponent stringByDeletingPathExtension]];
    UIImage *videoArrowImage = [manager videoConverPhotoWithVideoPath:path size:modelFrame.picViewF.size isSender:modelFrame.model.isSender];

    self.imageBtn.frame = modelFrame.picViewF;
    self.playImageView.frame = CGRectMake(0, 0, 30, 30);
    self.playImageView.center = self.imageBtn.center;
    self.bubbleView.userInteractionEnabled = videoArrowImage != nil;
    self.bubbleView.image = nil;
    [self.imageBtn setImage:videoArrowImage forState:UIControlStateNormal];
    
}


- (void)imageBtnClick:(UIButton *)btn
{
    [self videoPlay:self.modelFrame.model.mediaPath];
}

#pragma mark - videoPlay

- (void)videoPlay:(NSString *)path
{
    ICAVPlayer *player = [[ICAVPlayer alloc] initWithPlayerURL:[NSURL URLWithString:path]];
    [player presentFromVideoView:self.imageBtn toContainer:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES completion:nil];
}

#pragma mark - Getter

- (UIButton *)imageBtn
{
    if (nil == _imageBtn) {
        _imageBtn = [[UIButton alloc] init];
        [_imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _imageBtn.layer.masksToBounds = YES;
        _imageBtn.layer.cornerRadius = 5;
        _imageBtn.clipsToBounds = YES;
    }
    return _imageBtn;
}

-(UIImageView *)playImageView{
    if (nil == _playImageView) {
        _playImageView = [[UIImageView alloc] init];
        _playImageView.image = [UIImage imageNamed:@"App_video_play_btn_bg"];
    }
    return _playImageView;
}

@end
