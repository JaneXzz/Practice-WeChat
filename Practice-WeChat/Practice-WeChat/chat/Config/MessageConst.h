//
//  MessageConst.h
//  Practice-WeChat
//
//  Created by Jane on 2017/3/22.
//  Copyright © 2017年 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define MessageFont [UIFont systemFontOfSize:16.0]


/************Const*************/

extern CGFloat const HEIGHT_STATUSBAR;
extern CGFloat const HEIGHT_NAVBAR;
extern CGFloat const HEIGHT_CHATBOXVIEW;


/************Name*************/

extern NSString *const MessageKey;
extern NSString *const VoiceIcon;
extern NSString *const RedView;
// 消息类型
extern NSString *const TypeSystem;
extern NSString *const TypeText;
extern NSString *const TypeVoice;
extern NSString *const TypePic;
extern NSString *const TypeVideo;
extern NSString *const TypeFile;
extern NSString *const TypePicText;

/** 消息类型的KEY */
extern NSString *const MessageTypeKey;
extern NSString *const VideoPathKey;

extern NSString *const GXSelectEmotionKey;


/************Event*************/

extern NSString *const GXRouterEventVoiceTapEventName;
extern NSString *const GXRouterEventImageTapEventName;
extern NSString *const GXRouterEventTextUrlTapEventName;
extern NSString *const GXRouterEventMenuTapEventName;
extern NSString *const GXRouterEventVideoTapEventName;
extern NSString *const GXRouterEventShareTapEvent;

extern NSString *const GXRouterEventVideoRecordExit;
extern NSString *const GXRouterEventVideoRecordCancel;
extern NSString *const GXRouterEventVideoRecordFinish;
extern NSString *const GXRouterEventVideoRecordStart;
extern NSString *const GXRouterEventURLSkip;
extern NSString *const GXRouterEventScanFile;
