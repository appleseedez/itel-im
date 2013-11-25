//
//  IMManager.h
//  im
//
//  Created by Pharaoh on 13-11-20.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConstantHeader.h"
@protocol IMManager <NSObject>
//拨号
- (void) dial:(NSString*) account;
// 开始通话过程
- (void) startSession:(NSString*) destAccount;
// 结束通话过程
- (void) endSession;
// 初始化&启动
- (void) setup;
//销毁
- (void) tearDown;
//接受通话请求
- (void) acceptSession:(NSNotification*) notify;
// 拒绝通话请求
- (void) refuseSession:(NSNotification*) notify;
@end
