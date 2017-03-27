//
//  MediaManager.m
//  Practice-WeChat
//
//  Created by Jane on 2017/3/22.
//  Copyright © 2017年 Jane. All rights reserved.
//

#import "MediaManager.h"
#import "UIImage+Extension.h"
#import "FileTool.h"
#import "NSString+Extension.h"

static UIImage *_failedImage;
@interface MediaManager ()
@property (nonatomic, strong) NSCache *videoImageCache;
@property (nonatomic, strong) NSCache *imageChacheMe;
@property (nonatomic, strong) NSCache *imageChacheYou;
@property (nonatomic, strong) NSCache *photoCache;

@end

@implementation MediaManager
+ (instancetype)sharedManager
{
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(clearCaches) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        _failedImage  = [UIImage imageNamed:@"icon_album_picture_fail_big"];
    });
    return _instance;
}

- (void)clearCaches
{
    [self.videoImageCache removeAllObjects];
    [self.imageChacheMe removeAllObjects];
    [self.imageChacheYou removeAllObjects];
    [self.photoCache removeAllObjects];
}

// 使用文件名为key
- (UIImage *)imageWithLocalPath:(NSString *)localPath
{
    if ([self.photoCache objectForKey:localPath.lastPathComponent]) {
        return [self.photoCache objectForKey:localPath.lastPathComponent];
    } else if (![localPath hasSuffix:@".png"]) {
        return nil;
    }
    UIImage *image = [UIImage imageWithContentsOfFile:localPath];
    if (image) {
        [self.photoCache setObject:image forKey:localPath.lastPathComponent];
    } else {
        image = _failedImage;
        [self.photoCache setObject:image forKey:localPath.lastPathComponent];
    }
    return image;
}

- (void)clearReuseImageMessage:(ChatModel *)message
{
    NSString *path = message.mediaPath;
    NSString *videoPath = message.mediaPath;// 这是整个路径
    [self.photoCache removeObjectForKey:path.lastPathComponent];
    [self.imageChacheMe removeObjectForKey:path.lastPathComponent];
    [self.imageChacheYou removeObjectForKey:path.lastPathComponent];
    [self.videoImageCache removeObjectForKey:[[[videoPath stringByDeletingPathExtension] stringByAppendingPathExtension:kVideoPic] lastPathComponent]];
}

// get and save arrow image
- (UIImage *)arrowMeImage:(UIImage *)image
                     size:(CGSize)imageSize
                mediaPath:(NSString *)mediaPath
                 isSender:(BOOL)isSender
{
    NSString *arrowPath = [self arrowMeImagePathWithOriginImagePath:mediaPath];
    if (!arrowPath) {
        return _failedImage;
    }
    if ([self.imageChacheMe objectForKey:arrowPath.lastPathComponent]) {
        return [self.imageChacheMe objectForKey:arrowPath.lastPathComponent];
    }
    UIImage *arrowImage = [UIImage imageWithContentsOfFile:arrowPath];
    if (arrowImage) {
        return arrowImage;
    }
    if ([image isEqual:_failedImage]) {
        return _failedImage;
    }
    arrowImage = [UIImage makeArrowImageWithSize:imageSize image:image isSender:isSender];
    [self.imageChacheMe setObject:arrowImage forKey:arrowPath.lastPathComponent];
    [self saveArrowMeImage:arrowImage withMediaPath:arrowPath.lastPathComponent];
    return arrowImage;
}

// me to you
- (NSString *)arrowMeImagePathWithOriginImagePath:(NSString  *)orgImgPath
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kArrowMe];
    [self fileManagerWithPath:path];
    NSString *arrowPath = [path stringByAppendingPathComponent:orgImgPath.lastPathComponent];
    return arrowPath;
}

- (void)fileManagerWithPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirExist = [fileManager fileExistsAtPath:path];
    if (!isDirExist) {
        BOOL isCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreateDir) {
            NSLog(@"create folder failed");
            return ;
        }
    }
}

- (void)saveArrowMeImage:(UIImage *)image
           withMediaPath:(NSString *)mediPath
{
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:mediPath atomically:NO];
}

// 路径cache/MyPic
- (NSString *)createFolderPahtWithMainFolder:(NSString *)mainFolder
                                 childFolder:(NSString *)childFolder
{
    NSString *path = [mainFolder stringByAppendingPathComponent:childFolder];
    [self fileManagerWithPath:path];
    return path;
}

// 使用文件名作为key
- (UIImage *)videoConverPhotoWithVideoPath:(NSString *)videoPath
                                      size:(CGSize)imageSize
                                  isSender:(BOOL)isSender
{
    if (!videoPath) return nil;
    NSString *trueFileName = [[[videoPath stringByDeletingPathExtension] stringByAppendingPathExtension:kVideoImageType] lastPathComponent];
    UIImage *videoImg = [self videoImageWithFileName:trueFileName];
    if (videoImg) {
        return videoImg;
    }
    UIImage *thumbnailImage = [UIImage videoFramerateWithPath:videoPath];
    if (thumbnailImage) {
        [self.videoImageCache setObject:thumbnailImage forKey:trueFileName];
        [self saveVideoImage:thumbnailImage fileName:trueFileName];
    }
    return thumbnailImage;
}

/**
 *  保存图片到沙盒
 *
 *  @param image 图片
 *
 *  @return 图片路径
 */
- (NSString *)saveImage:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *chachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // 图片名称
    NSString *fileName = [NSString stringWithFormat:@"%@%@",[NSString currentName],@".png"];
    NSString *mainFilePath = [self createFolderPahtWithMainFolder:chachePath childFolder:kMyPic];
    NSString *filePath = [mainFilePath stringByAppendingPathComponent:fileName];
    [imageData writeToFile:filePath atomically:NO];
    return filePath;
}

// 发送图片的地址
- (NSString *)sendImagePath:(NSString *)imgName
{
    NSString *chachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [NSString stringWithFormat:@"%@",imgName];
    NSString *mainFilePath = [self createFolderPahtWithMainFolder:chachePath childFolder:kMyPic];
    NSString *filePath = [mainFilePath stringByAppendingPathComponent:fileName];
    return filePath;
    
}

/// save video image in sandbox
- (void)saveVideoImage:(UIImage *)image
              fileName:(NSString *)fileName
{
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *chachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *mainFilePath = [self createFolderPahtWithMainFolder:chachePath childFolder:kVideoPic];
    NSString *filePath = [mainFilePath stringByAppendingPathComponent:fileName];
    [imageData writeToFile:filePath atomically:NO];
}

// get videoImage from sandbox
- (UIImage *)videoImageWithFileName:(NSString *)fileName
{
    return [UIImage imageWithContentsOfFile:[self videoImagePath:fileName]];
}

- (NSString *)videoImagePath:(NSString *)fileName
{
    NSString *path = [[FileTool cacheDirectory] stringByAppendingPathComponent:kVideoPic];
    [self fileManagerWithPath:path];
    NSString *fullPath = [path stringByAppendingPathComponent:fileName];
    return fullPath;
}


// 保存接收到图片   fileKey-small.png
- (NSString *)receiveImagePathWithFileKey:(NSString *)fileKey
                                     type:(NSString *)type
{
    // 目前是png，以后说不定要改
    NSString *fileName = [NSString stringWithFormat:@"%@-%@%@",fileKey,type,@".png"];
    NSString *mainFilePath = [self createFolderPahtWithMainFolder:[FileTool cacheDirectory] childFolder:kMyPic];
    return [mainFilePath stringByAppendingPathComponent:fileName];
}

// get image with imgName
- (NSString *)imagePathWithName:(NSString *)imageName
{
    return [[[FileTool cacheDirectory] stringByAppendingPathComponent:kMyPic] stringByAppendingPathComponent:imageName];
}


// origin image path
- (NSString *)originImgPath:(ChatFrame *)messageF
{
    return [[MediaManager sharedManager] receiveImagePathWithFileKey:messageF.model.message.fileKey type:@"origin"];
}

// small image path
- (NSString *)smallImgPath:(NSString *)fileKey
{
    return [[MediaManager sharedManager] receiveImagePathWithFileKey:fileKey type:@"small"];
}


- (NSString *)delieveImagePath:(NSString *)fileKey
{
    NSString *fileName = [NSString stringWithFormat:@"%@%@",fileKey,@".png"];
    NSString *mainFilePath = [self createFolderPahtWithMainFolder:[FileTool cacheDirectory] childFolder:kDeliver];
    return [mainFilePath stringByAppendingPathComponent:fileName];
}

- (NSString *)deliverFilePath:(NSString *)name
                         type:(NSString *)type
{
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",name,type];
    NSString *mainFilePath = [self createFolderPahtWithMainFolder:[FileTool cacheDirectory] childFolder:kDeliver];
    return [mainFilePath stringByAppendingPathComponent:fileName];
}


#pragma mark - Getter and Setter

- (NSCache *)videoImageCache
{
    if (nil == _videoImageCache) {
        _videoImageCache = [[NSCache alloc] init];
    }
    return _videoImageCache;
}

- (NSCache *)imageChacheMe
{
    if (nil == _imageChacheMe) {
        _imageChacheMe = [[NSCache alloc] init];
    }
    return _imageChacheMe;
}

- (NSCache *)imageChacheYou
{
    if (nil == _imageChacheYou) {
        _imageChacheYou = [[NSCache alloc] init];
    }
    return _imageChacheYou;
}

- (NSCache *)photoCache
{
    if (nil == _photoCache) {
        _photoCache = [[NSCache alloc] init];
    }
    return _photoCache;
}




@end
