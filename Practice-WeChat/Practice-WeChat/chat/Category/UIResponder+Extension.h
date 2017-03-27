//
//  UIResponder+Extension.h
//  Practice-WeChat
//
//  Created by Jane on 2017/3/23.
//  Copyright © 2017年 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Extension)

//事件和响应连接
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;
@end
