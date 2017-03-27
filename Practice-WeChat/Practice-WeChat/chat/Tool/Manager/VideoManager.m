//
//  VideoManager.m
//  Practice-WeChat
//
//  Created by Jane on 2017/3/22.
//  Copyright © 2017年 Jane. All rights reserved.
//

#import "VideoManager.h"
#import "GlobalDefines.h"


@implementation VideoManager

+ (instancetype)shareManager
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark  --- video的路径
- (NSString *)videoPathWithFileName:(NSString *)videoName
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kChatVideoPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirExist = [fileManager fileExistsAtPath:path];
    if (!isDirExist) {
        BOOL isCreatDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreatDir) {
            NSLog(@"create folder failed");
            return nil;
        }
    }
    return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",videoName,kVideoType]];
}

#pragma mark --- 接收到的视频保存路径(文件以fileKey为名字)
- (NSString *)receiveVideoPathWithFileKey:(NSString *)fileKey
{
    return [self videoPathWithFileName:fileKey];
}





@end
