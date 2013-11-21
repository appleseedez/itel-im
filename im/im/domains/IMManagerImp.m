//
//  IMManagerImp.m
//  im
//
//  Created by Pharaoh on 13-11-20.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMManagerImp.h"

@interface IMManagerImp ()

//状态标识符，表明当前所处的状态。目前只有占用和空闲两种 占用：IN_USE，空闲：IDLE
@property (nonatomic) int state;

@end

@implementation IMManagerImp
#pragma mark - LOGIC
// 启动~
// 燥起来吧，董小姐
- (void) boot{
    //环境初始化
    [self.engine initNetwork];
    [self.engine initMedia];
    //连接信令服务器
    [self.communicator connect];
    [self.communicator keepAlive];
    //向信令服务器发验证请求
    [self auth:@"123446677" cert:@"chengjianjun"];
}


- (void) testSessionStart{
    // 通话查询开始
    [self startSession];
    // 构造通话查询信令
    NSDictionary* data = [self.messageBuilder buildWithParams:nil];
    // 发送信令数据到信令服务器
    [self.communicator send:data];
    // 转到 [self receive:];
}
// 向信令服务器做一次验证
- (void) auth:(NSString*) itelAccount
         cert:(NSString*) cert{
    self.messageBuilder = [[IMAuthMessageBuilder alloc] init];
    NSDictionary* data = [self.messageBuilder buildWithParams:@{
                                                                @"account":itelAccount,
                                                                @"keys":cert
                                                                }];
    [self.communicator send:data];
}

#pragma mark - PRIVATE

// 注册通知
- (void)registerNotifications {
    //网络通信器会在收到数据响应时，发出该通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receive:) name:DATA_RECEIVED_NOTIFICATION object:nil];
    //对收到的信令响应数据进行解析后，如果是通话查询请求的响应，则发出该通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionInited:) name:SESSION_INITED_NOTIFICATION object:nil];
    //对收到的信令响应数据进行解析后，如果是通话请求的接受响应，则发出该通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionPeriod:) name:SESSION_PERIOD_NOTIFICATION object:nil];
    //登录到信令服务器后，需要做一次验证，验证信息响应时，发出该通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authHasResult:) name:CMID_APP_LOGIN_SSS_NOTIFICATION object:nil];
}
//移除通知 防止leak
- (void) removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 依赖注入
- (void)injectDependency {
    self.engine = [[IMEngineImp alloc] init];// 引擎
    self.communicator = [[IMTCPCommunicator alloc] init];// 网络通信器
    self.messageBuilder = [[IMSessionInitMessageBuilder alloc] init]; //信令构造器
    self.messageParser = [[IMMessageParserImp alloc] init]; // 信令解析器
}

//根据数据的具体类型做操作路由
- (void) route:(NSDictionary*) data{
    // 获取头部数据
    NSDictionary* headSection = [data valueForKey:HEAD_SECTION_KEY];
    NSInteger type = [[headSection valueForKey:DATA_TYPE_KEY] integerValue];
    NSInteger status = [[headSection valueForKey:DATA_STATUS_KEY] integerValue];
    // 异常情况处理。
    if (status != NORMAL_STATUS) {
        [NSException exceptionWithName:@"500:data format error" reason:@"信令服务器返回数据状态不正常" userInfo:nil];
    }
    //路由
    switch (type) {
        case SESSION_INIT_RES_TYPE:
            // 通话查询请求正常返回，通知业务层
            [[NSNotificationCenter defaultCenter] postNotificationName:SESSION_INITED_NOTIFICATION object:nil userInfo:data];
            break;
        case SESSION_PERIOD_RES_TYPE:
            [[NSNotificationCenter defaultCenter] postNotificationName:SESSION_PERIOD_NOTIFICATION object:nil userInfo:data];
            break;
            
        case CMID_APP_LOGIN_SSS_RESP_TYPE: //信令服务器验证响应返回了，通知业务层
            [[NSNotificationCenter defaultCenter] postNotificationName:CMID_APP_LOGIN_SSS_NOTIFICATION object:nil userInfo:data];
            break;
        default:
            break;
    }
    
}

#pragma mark - NOTIFICATION HANDLE
// 信令回复数据的处理 采用通知来完成
- (void) receive:(NSNotification*) notify{
    NSLog(@"收到数据，开始解析");
    //数据解析。
    NSDictionary* parsedData = [self.messageParser parse:notify.userInfo];
    [self route:parsedData];
}
//收到信令服务器的通话查询响应，进行后续业务
- (void) sessionInited:(NSNotification*) notify{
    NSLog(@"收到通话查询响应~");
}
//收到peer端的通话接受响应，进行后续业务
- (void) sessionPeriod:(NSNotification*) notify{
    NSLog(@"收到通话响应，根据数据具体情况，是接受还是拒绝~");
}
//收到信令服务器的验证响应，
- (void) authHasResult:(NSNotification*) notify{
    NSLog(@"收到信令服务器端帐号验证响应~");
}


#pragma mark - INTERFACE


// IMManager 接口的实现
- (void)setup{
    [self injectDependency];
    [self registerNotifications];
    
    [self boot];
}

- (void) tearDown{
    [self removeNotifications];
    [self.communicator disconnect];
    
}
- (void)startSession{
    self.state = IN_USE;
}
- (void)endSession{
    self.state = IDLE;
}



@end
