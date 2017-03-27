//
//  ChatVC.m
//  Practice-WeChat
//
//  Created by Jane on 2017/3/22.
//  Copyright © 2017年 Jane. All rights reserved.
//

#import "ChatVC.h"
#import "MessageConst.h"
#import "ChatMessageImageCell.h"
#import "ChatMessageTextCell.h"
#import "ChatMessageVideoCell.h"
#import "ChatMessageVoiceCell.h"
#import "ChatMessageBaseCell.h"
#import "MediaManager.h"
#import "MessageHelper.h"
#import "UIImage+Extension.h"
#import "UIResponder+Extension.h"
#import "FileTool.h"
#import "RecordManager.h"
#import "PhotoBrowserController.h"
#import "ChatFrame.h"
#import "GlobalDefines.h"


#define HEIGHT_TABBAR       49      // 就是chatBox的高度


@interface ChatVC ()<UITableViewDelegate,UITableViewDataSource,BaseCellDelegate,RecordManagerDelegate,UIViewControllerTransitioningDelegate>{
    CGRect _smallRect;
    CGRect _bigRect;
    
    UIMenuItem * _copyMenuItem;
    UIMenuItem * _deleteMenuItem;
    UIMenuItem * _forwardMenuItem;
    UIMenuItem * _recallMenuItem;
    NSIndexPath *_longIndexPath;
    
    BOOL   _isKeyBoardAppear;     // 键盘是否弹出来了
    ChatFrame *chatModel;//记录播放
}

@property (nonatomic, strong) UITableView *tableView;

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/** voice path */
@property (nonatomic, copy) NSString *voicePath;

/**  */
@property (nonatomic, strong) UIImageView *currentVoiceIcon;

/**  */
@property (nonatomic, strong) UIImageView *presentImageView;

/** 聊天框 */
//@property (nonatomic, strong) ChatBoxVC *chatBoxVC;


@end

@implementation ChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"聊天";
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(didClcik)];
    self.navigationItem.leftBarButtonItem = left1;
    
    [self setupUI];
    [self registerCell];
    self.dataSource = _messageArray;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(_dataSource.count-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
-(void)didClcik{
    NSInteger aa = arc4random_uniform(2) == 0?0:1;
    if (aa == 0) {
        NSUInteger bb = arc4random_uniform(4);
        switch (bb) {
            case 0:
                [self sendTextMessage];
                break;
            case 1:
                [self sendImageMessage];
                break;
            case 2:
                [self meSendVideoMessage];
                break;
            case 3:
                [self sendVoiceMessage];
                break;
        }
        
    }else{
        
        NSUInteger bb = arc4random_uniform(4);
        switch (bb) {
            case 0:
                [self otherSendTextMessageWithContent:@"他人的测试"];
                break;
            case 1:
                [self otherSendImageMessage];
                break;
            case 2:
                [self otherSendVideoMessage];
                break;
            case 3:
                [self otherVoiceMessage];
                break;
        }
        
    }
}
#pragma mark--- 发送文字
-(void)sendTextMessage{
    
    ChatFrame *messageF = [MessageHelper createMessageFrame:TypeText content:@"测试文字发送" path:nil from:@"gxz" to:@"" fileKey:nil isSender:YES receivedSenderByYourself:NO];
    [self addObject:messageF isSender:YES];
    
    [self messageSendSucced:messageF];
}

- (void)otherSendTextMessageWithContent:(NSString *)messageStr
{
    ChatFrame *messageF = [MessageHelper createMessageFrame:TypeText content:messageStr path:nil from:@"gxz" to:@"" fileKey:nil isSender:NO receivedSenderByYourself:NO];
    [self addObject:messageF isSender:YES];
    
    [self messageSendSucced:messageF];
}

- (void)messageSendSucced:(ChatFrame *)messageF
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        messageF.model.message.deliveryState = ICMessageDeliveryState_Delivered;
        [self.tableView reloadData];
    });
}

// 增加数据源并刷新
- (void)addObject:(ChatFrame *)messageF
         isSender:(BOOL)isSender
{
    [self.dataSource addObject:messageF];
    [self.tableView reloadData];
    [self scrollToBottom];
}
#pragma mark - 滑动到底层

- (void) scrollToBottom
{
    if (self.dataSource.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

#pragma mark --- 发送图片

-(void)sendImageMessage{
    UIImage *simpleImg = [UIImage simpleImage:[UIImage imageNamed:@"3"]];
    NSString *filePath = [[MediaManager sharedManager] saveImage:simpleImg];
    [self sendImageMessageWithImgPath:filePath];

}
-(void)otherSendImageMessage{
    UIImage *simpleImg = [UIImage simpleImage:[UIImage imageNamed:@"2"]];
    NSString *filePath = [[MediaManager sharedManager] saveImage:simpleImg];
    ChatFrame *messageF = [MessageHelper createMessageFrame:TypePic content:@"[图片]" path:filePath from:@"gxz" to:@"" fileKey:nil isSender:NO receivedSenderByYourself:NO];
    [self addObject:messageF isSender:YES];
    [self messageSendSucced:messageF];
    
}
- (void)sendImageMessageWithImgPath:(NSString *)imgPath{
    ChatFrame *messageF = [MessageHelper createMessageFrame:TypePic content:@"[图片]" path:imgPath from:@"gxz" to:@"" fileKey:nil isSender:YES receivedSenderByYourself:NO];
    [self addObject:messageF isSender:YES];
    [self messageSendSucced:messageF];
    
}


#pragma mark --- 发送视频
-(void)sendVideoMessage{
    
}

-(void)meSendVideoMessage{
    
    ChatFrame *messageFrame = [MessageHelper createMessageFrame:TypeVideo content:@"[视频]" path:[[NSBundle mainBundle] pathForResource:@"text" ofType:@"mp4"] from:@"gxz" to:@"" fileKey:nil isSender:YES receivedSenderByYourself:NO]; // 创建本地消息
    [self addObject:messageFrame isSender:YES];
    [self messageSendSucced:messageFrame];
}

-(void)otherSendVideoMessage{
    ChatFrame *messageFrame = [MessageHelper createMessageFrame:TypeVideo content:@"[视频]" path:[[NSBundle mainBundle] pathForResource:@"text" ofType:@"mp4"] from:@"gxz" to:@"" fileKey:nil isSender:NO receivedSenderByYourself:NO]; // 创建本地消息
    [self addObject:messageFrame isSender:YES];
    [self messageSendSucced:messageFrame];
}

-(void)sendVoiceMessage{
    ChatFrame *messageF = [MessageHelper createMessageFrame:TypeVoice content:@"[语音]" path:[[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"] from:@"gxz" to:@"" fileKey:nil isSender:YES receivedSenderByYourself:NO];
    [self addObject:messageF isSender:YES];
    [self messageSendSucced:messageF];
}

-(void)otherVoiceMessage{
    ChatFrame *messageF = [MessageHelper createMessageFrame:TypeVoice content:@"[语音]" path:[[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"] from:@"gxz" to:@"" fileKey:nil isSender:NO receivedSenderByYourself:NO];
    [self addObject:messageF isSender:YES];
    [self messageSendSucced:messageF];
}

-(void)registerCell{
    [self.tableView registerClass:[ChatMessageTextCell class] forCellReuseIdentifier:TypeText];
    [self.tableView registerClass:[ChatMessageImageCell class] forCellReuseIdentifier:TypePic];
    [self.tableView registerClass:[ChatMessageVideoCell class] forCellReuseIdentifier:TypeVideo];
    [self.tableView registerClass:[ChatMessageVoiceCell class] forCellReuseIdentifier:TypeVoice];
}
#pragma mark -- UI设置
-(void)setupUI{
    self.view.backgroundColor = kColor(240, 237, 237);
    // 注意添加顺序
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = kColor(240, 237, 237);
    // self.view的高度有时候是不准确的
    self.tableView.frame = CGRectMake(0, HEIGHT_NAVBAR+HEIGHT_STATUSBAR, self.view.frame.size.width, APP_Frame_Height-HEIGHT_TABBAR-HEIGHT_NAVBAR-HEIGHT_STATUSBAR);
}
#pragma mark - Tableview data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatFrame *modelFrame = self.dataSource[indexPath.row];
    NSString *ID = modelFrame.model.message.type;
//        if ([ID isEqualToString:TypeSystem]) {
//            ICChatSystemCell *cell = [ICChatSystemCell cellWithTableView:tableView reusableId:ID];
//            cell.messageF = modelFrame;
//            return cell;
//        }
    ChatMessageBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.clickDelegate = self;
    cell.modelFrame = modelFrame;

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatFrame *messageF = [self.dataSource objectAtIndex:indexPath.row];
    return messageF.cellHight;
}

#pragma mark - baseCell delegate

- (void)longPress:(UILongPressGestureRecognizer *)longRecognizer
{
    if (longRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location       = [longRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        _longIndexPath         = indexPath;
        id object              = [self.dataSource objectAtIndex:indexPath.row];
        if (![object isKindOfClass:[ChatFrame class]]) return;
        ChatMessageBaseCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self showMenuViewController:cell.bubbleView andIndexPath:indexPath message:cell.modelFrame.model];
    }
}
- (void)showMenuViewController:(UIView *)showInView andIndexPath:(NSIndexPath *)indexPath message:(ChatModel *)messageModel
{
    if (_copyMenuItem   == nil) {
        _copyMenuItem   = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMessage:)];
    }
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage:)];
    }
    if (_forwardMenuItem == nil) {
        _forwardMenuItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(forwardMessage:)];
    }
    NSInteger currentTime = [MessageHelper currentMessageTime];
    NSInteger interval    = currentTime - messageModel.message.date;
    if (messageModel.isSender) {
        if ((interval/1000) < 5*60 && !(messageModel.message.deliveryState == ICMessageDeliveryState_Failure)) {
            if (_recallMenuItem == nil) {
                _recallMenuItem = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(recallMessage:)];
            }
            [[UIMenuController sharedMenuController] setMenuItems:@[_copyMenuItem,_deleteMenuItem,_recallMenuItem,_forwardMenuItem]];
        } else {
            [[UIMenuController sharedMenuController] setMenuItems:@[_copyMenuItem,_deleteMenuItem,_forwardMenuItem]];
        }
    } else {
        [[UIMenuController sharedMenuController] setMenuItems:@[_copyMenuItem,_deleteMenuItem,_forwardMenuItem]];
    }
    [[UIMenuController sharedMenuController] setTargetRect:showInView.frame inView:showInView.superview ];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
#pragma mark --- 复制
- (void)copyMessage:(UIMenuItem *)copyMenuItem
{
    UIPasteboard *pasteboard  = [UIPasteboard generalPasteboard];
    ChatFrame * messageF = [self.dataSource objectAtIndex:_longIndexPath.row];
    pasteboard.string         = messageF.model.message.content;
}

#pragma mark --- 删除
- (void)deleteMessage:(UIMenuItem *)deleteMenuItem
{
    // 这里还应该把本地的消息附件删除
   ChatFrame * messageF = [self.dataSource objectAtIndex:_longIndexPath.row];
   [self statusChanged:messageF];
}

- (void)statusChanged:(ChatFrame *)messageF
{
    [self.dataSource removeObject:messageF];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[_longIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)forwardMessage:(UIMenuItem *)forwardItem
{
    NSLog(@"需要用到的数据库，等添加了数据库再做转发...");
}

#pragma mark --- 撤回消息
- (void)recallMessage:(UIMenuItem *)recallMenuItem
{
    NSLog(@"2分钟内的消息可以撤回");
}
-(void)didSelectLinkTextOperationLink:(NSString *)link type:(MLEmojiLabelLinkType)type{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"点击了链接%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
}
#pragma mark - ChatBoxVCDelegate




#pragma mark - Getter and Setter
-(UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIImageView *)presentImageView
{
    if (!_presentImageView) {
        _presentImageView = [[UIImageView alloc] init];
    }
    return _presentImageView;
}



- (void)routerEventWithName:(NSString *)eventName
                   userInfo:(NSDictionary *)userInfo
{
    ChatFrame *modelFrame = [userInfo objectForKey:MessageKey];
    if ([eventName isEqualToString:GXRouterEventTextUrlTapEventName]) {
    } else if ([eventName isEqualToString:GXRouterEventImageTapEventName]) {
        _smallRect             = [[userInfo objectForKey:@"smallRect"] CGRectValue];
        _bigRect               =  [[userInfo objectForKey:@"bigRect"] CGRectValue];
        NSString *imgPath      = modelFrame.model.mediaPath;
        NSString *orgImgPath = [[MediaManager sharedManager] originImgPath:modelFrame];
        if ([FileTool fileExistsAtPath:orgImgPath]) {
            modelFrame.model.mediaPath = orgImgPath;
            imgPath                    = orgImgPath;
        }
        [self showLargeImageWithPath:imgPath withMessageF:modelFrame];
    } else if ([eventName isEqualToString:GXRouterEventVoiceTapEventName]) {
        
        UIImageView *imageView = (UIImageView *)userInfo[VoiceIcon];
        UIView *redView        = (UIView *)userInfo[RedView];
        [self chatVoiceTaped:modelFrame voiceIcon:imageView redView:redView];
    }
}

// tap image
- (void)showLargeImageWithPath:(NSString *)imgPath
                  withMessageF:(ChatFrame *)messageF
{
    UIImage *image = [[MediaManager sharedManager] imageWithLocalPath:imgPath];
    if (image == nil) {
        NSLog(@"image is not existed");
        return;
    }
    PhotoBrowserController *photoVC = [[PhotoBrowserController alloc] initWithImage:image];
    self.presentImageView.image = image;
    photoVC.transitioningDelegate = self;
    photoVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:photoVC animated:YES completion:nil];
}


// play voice
- (void)chatVoiceTaped:(ChatFrame *)messageFrame
             voiceIcon:(UIImageView *)voiceIcon
               redView:(UIView *)redView
{
    if (chatModel) {
        [self.currentVoiceIcon stopAnimating];
        self.currentVoiceIcon = nil;
        chatModel.model.isPlayVoice = NO;
    }
    self.currentVoiceIcon = nil;
    chatModel = nil;
    RecordManager *recordManager = [RecordManager shareManager];
    recordManager.playDelegate = self;
    // 文件路径
    NSString *voicePath = [self mediaPath:messageFrame.model.mediaPath];
    if (messageFrame.model.message.status == 0){
        messageFrame.model.message.status = 1;
        redView.hidden = YES;
    }
    if (self.voicePath) {
        if ([self.voicePath isEqualToString:voicePath]) { // the same recoder
            self.voicePath = nil;
            [[RecordManager shareManager] stopPlayRecorder:voicePath];
            [voiceIcon stopAnimating];
            self.currentVoiceIcon = nil;
            messageFrame.model.isPlayVoice = NO;
            return;
        }
    }
    messageFrame.model.isPlayVoice = YES;
    chatModel = messageFrame;
    [[RecordManager shareManager] startPlayRecorder:voicePath];
    [voiceIcon startAnimating];
    self.voicePath = voicePath;
    self.currentVoiceIcon = voiceIcon;
}

#pragma mark - ICRecordManagerDelegate

- (void)voiceDidPlayFinished
{
    self.voicePath = nil;
    [self.currentVoiceIcon stopAnimating];
    self.currentVoiceIcon = nil;
    if (chatModel) {
        chatModel.model.isPlayVoice = NO;
    }
}

// 文件路径
- (NSString *)mediaPath:(NSString *)originPath
{
    // 这里文件路径重新给，根据文件名字来拼接
    NSString *name = [[originPath lastPathComponent] stringByDeletingPathExtension];
    return [[RecordManager shareManager] receiveVoicePathWithFileKey:name];
}
@end
