//
//  VideoManager.h
//  Practice-WeChat
//
//  Created by Jane on 2017/3/22.
//  Copyright © 2017年 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void(^RecordingFinished)(NSString *path);

@interface VideoManager : NSObject

+ (instancetype)shareManager;

// 接收到的视频保存路径(文件以fileKey为名字)
- (NSString *)receiveVideoPathWithFileKey:(NSString *)fileKey;



@end
