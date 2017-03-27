//
//  ChatType.h
//  Practice-WeChat
//
//  Created by Jane on 2017/3/22.
//  Copyright © 2017年 Jane. All rights reserved.
//

#ifndef ChatType_h
#define ChatType_h


// 消息发送状态
typedef enum {
    ICMessageDeliveryState_Pending = 0,  // 待发送
    ICMessageDeliveryState_Delivering,   // 正在发送
    ICMessageDeliveryState_Delivered,    // 已发送，成功
    ICMessageDeliveryState_Failure,      // 发送失败
    ICMessageDeliveryState_ServiceFaid   // 发送服务器失败(可能其它错,待扩展)
}MessageDeliveryState;


typedef enum {
    ICMessageStatus_unRead = 0,          // 消息未读
    ICMessageStatus_read,                // 消息已读
    ICMessageStatus_back                 // 消息撤回
}ICMessageStatus;

typedef enum {
    ICFileType_Other = 0,                // 其它类型
    ICFileType_Audio,                    //
    ICFileType_Video,                    //
    ICFileType_Html,
    ICFileType_Pdf,
    ICFileType_Doc,
    ICFileType_Xls,
    ICFileType_Ppt,
    ICFileType_Img,
    ICFileType_Txt
}ICFileType;


#endif /* ChatType_h */
