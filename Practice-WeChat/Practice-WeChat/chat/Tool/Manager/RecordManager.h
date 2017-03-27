//
//  RecordManager.h
//  Practice-WeChat
//
//  Created by Jane on 2017/3/23.
//  Copyright © 2017年 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@protocol RecordManagerDelegate <NSObject>

// 录音播放完成
- (void)voiceDidPlayFinished;

@end

@interface RecordManager : NSObject<AVAudioPlayerDelegate,AVAudioRecorderDelegate>

@property (nonatomic, weak)id <RecordManagerDelegate>playDelegate;

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;

+ (id)shareManager;

/*********-------播放----------************/

- (void)startPlayRecorder:(NSString *)recorderPath;

- (void)stopPlayRecorder:(NSString *)recorderPath;

- (void)pause;


// 接收到的语音保存路径(文件以fileKey为名字)
- (NSString *)receiveVoicePathWithFileKey:(NSString *)fileKey;

// 获取语音时长
- (NSUInteger)durationWithVideo:(NSURL *)voiceUrl;



@end
