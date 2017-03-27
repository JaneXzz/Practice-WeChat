//
//  MediaManager.h
//  Practice-WeChat
//
//  Created by Jane on 2017/3/22.
//  Copyright © 2017年 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatFrame.h"
#import "ChatModel.h"
#import "GlobalDefines.h"



@interface MediaManager : NSObject
+ (instancetype)sharedManager;
/**
 *  get image from local path
 *
 *  @param localPath 路径
 *
 *  @return 图片
 */
- (UIImage *)imageWithLocalPath:(NSString *)localPath;

- (void)clearReuseImageMessage:(ChatModel *)message;

// me to you
- (UIImage *)arrowMeImage:(UIImage *)image
                     size:(CGSize)imageSize
                mediaPath:(NSString *)mediaPath
                 isSender:(BOOL)isSender;

- (void)saveArrowMeImage:(UIImage *)image
           withMediaPath:(NSString *)mediPath;

/**
 *  创建图片的保存路径
 *
 *  @param mainFolder  主地址
 *  @param childFolder 子地址
 *
 *  @return 地址
 */
- (NSString *)createFolderPahtWithMainFolder:(NSString *)mainFolder
                                 childFolder:(NSString *)childFolder;

/**
 *  保存图片到沙盒
 *
 *  @param image 图片
 *
 *  @return 图片路径
 */
- (NSString *)saveImage:(UIImage *)image;

- (void)clearCaches;

/// video first cover image
- (UIImage *)videoConverPhotoWithVideoPath:(NSString *)videoPath
                                      size:(CGSize)imageSize
                                  isSender:(BOOL)isSender;


// 保存接收到图片 small-fileKey.png
- (NSString *)receiveImagePathWithFileKey:(NSString *)fileKey
                                     type:(NSString *)type;


// 原图路径
- (NSString *)originImgPath:(ChatFrame *)messageF;


// get image with imgName
- (NSString *)imagePathWithName:(NSString *)imageName;

// get videoImage from sandbox
- (UIImage *)videoImageWithFileName:(NSString *)fileName;



- (NSString *)videoImagePath:(NSString *)fileName;



@end
