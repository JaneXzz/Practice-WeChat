//
//  GlobalDefines.h
//  Practice-WeChat
//
//  Created by Jane on 2017/3/23.
//  Copyright © 2017年 Jane. All rights reserved.
//

#ifndef GlobalDefines_h
#define GlobalDefines_h

#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]
#define App_RootCtr  [UIApplication sharedApplication].keyWindow.rootViewController

#define APP_Frame_Height   [[UIScreen mainScreen] bounds].size.height
#define App_Frame_Width    [[UIScreen mainScreen] bounds].size.width

#define APP_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define APP_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define kAmrType @"amr"
#define kMinRecordDuration 1.0

#define shortRecord @"shortRecord"

#define kArrowMe @"Chat/ArrowMe"
#define kMyPic @"Chat/MyPic"
#define kVideoPic @"Chat/VideoPic"
#define kVideoImageType @"png"
#define kDeliver @"Deliver"
#define kDiscvoerVideoPath @"Download/Video"  // video子路径
#define kChatVideoPath @"Chat/Video"  // video子路径

#define kVideoType @".mp4"        // video类型
#define kRecoderType @".mp3"

#define kChatRecoderPath @"Chat/Recoder"
#define kRecodAmrType @".amr"

#endif /* GlobalDefines_h */
