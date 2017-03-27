//
//  ChatModel.h
//  Practice-WeChat
//
//  Created by Jane on 2017/3/22.
//  Copyright © 2017年 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface ChatModel : NSObject

// 是否是发送者
@property (nonatomic, assign) BOOL isSender;
// 是否是群聊

@property (nonatomic, strong) Message * message;

// 包含voice，picture，video的路径;有大图时就是大图路径
// 不用这些路径了，只用里面的名字重新组成路径
@property (nonatomic, copy) NSString *mediaPath;

//是否正在播放录音
@property (nonatomic, assign) BOOL isPlayVoice;

@end
