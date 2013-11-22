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
- (void) startSession;
// 结束通话过程
- (void) endSession;
// 初始化&启动
- (void) setup;

- (void) tearDown;

@end
