//
//  RecordManager.m
//  Practice-WeChat
//
//  Created by Jane on 2017/3/23.
//  Copyright © 2017年 Jane. All rights reserved.
//

#import "RecordManager.h"
#import <UIKit/UIKit.h>
#import "GlobalDefines.h"
#import "FileTool.h"


@interface RecordManager ()
{
    NSDate *_startDate;
    NSDate *_endDate;
    void (^recordFinish)(NSString *recordPath);
}
@end

@implementation RecordManager

+ (id)shareManager
{
    static id _instance ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

// 录音文件主路径
- (NSString *)recorderMainPath
{
    return [FileTool createPathWithChildPath:kChatRecoderPath];
}

- (NSString *)recorderPathWithFileName:(NSString *)fileName
{
    NSString *path = [self recorderMainPath];
    return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",fileName,kRecoderType]];
}
- (NSTimeInterval)recordMinDuration
{
    return kMinRecordDuration;
}





#pragma mark - Player

- (void)startPlayRecorder:(NSString *)recorderPath
{
    [self.player stop];
    self.player = nil;  // clear previous player
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:recorderPath] error:nil];
    self.player.numberOfLoops = 0;
    [self.player prepareToPlay];
    self.player.delegate = self;
    [self.player play];
}

- (void)stopPlayRecorder:(NSString *)recorderPath
{
    [self.player stop];
    self.player = nil;
    self.player.delegate = nil;
}

- (void)pause
{
    [self.player pause];
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag
{
    [self.player stop];
    self.player = nil;
    if (self.playDelegate && [self.playDelegate respondsToSelector:@selector(voiceDidPlayFinished)]) {
        [self.playDelegate voiceDidPlayFinished];
    }
}





// 接收到的语音保存路径(文件以fileKey为名字)
- (NSString *)receiveVoicePathWithFileKey:(NSString *)fileKey
{
    return [self recorderPathWithFileName:fileKey];
}



// 获取语音时长
- (NSUInteger)durationWithVideo:(NSURL *)voiceUrl{
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:voiceUrl options:opts]; // 初始化视频媒体文件
    NSUInteger second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    return second;
}



@end
