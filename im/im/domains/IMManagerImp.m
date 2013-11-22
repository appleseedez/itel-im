//
//  IMManagerImp.m
//  im
//
//  Created by Pharaoh on 13-11-20.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMManagerImp.h"
#import  "ConstantHeader.h"
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


- (void) testSessionStart:(NSString*) destAccount{
    // 通话查询开始
    [self startSession];
    // 构造通话查询信令
    self.messageBuilder = [[IMSessionInitMessageBuilder alloc] init];
    //通话查询请求数据的构造
    NSDictionary* data = [self.messageBuilder buildWithParams:@{SESSION_INIT_REQ_FIELD_DEST_ACCOUNT_KEY: destAccount}];
    // 发送信令数据到信令服务器
    [self.communicator send:data];
    // 转到 [self receive:];
}
// 向信令服务器做一次验证
- (void) auth:(NSString*) selfAccount
         cert:(NSString*) cert{
    self.messageBuilder = [[IMAuthMessageBuilder alloc] init];
    NSDictionary* data = [self.messageBuilder buildWithParams:@{
                                                                CMID_APP_LOGIN_SSS_REQ_FIELD_ACCOUNT_KEY:selfAccount,
                                                                CMID_APP_LOGIN_SSS_REQ_FIELD_CERT_KEY:cert
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
    //对收到的信令响应数据进行解析后，如果是请求类型，则发出该通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionPeriodRequest:) name:SESSION_PERIOD_REQ_NOTIFICATION object:nil];
    //收到信令响应数据进行解析后，如果是响应类型，则发出该通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionPeriodResponse:) name:SESSION_PERIOD_RES_NOTIFICATION object:nil];
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
        return;
    }
    //业务模块只关心body部分的数据。
    NSDictionary* bodySection = [data valueForKey:BODY_SECTION_KEY];
    //路由
    switch (type) {
        case SESSION_INIT_RES_TYPE:
            // 通话查询请求正常返回，通知业务层
            // [self sessionInited:]
            [[NSNotificationCenter defaultCenter] postNotificationName:SESSION_INITED_NOTIFICATION object:nil userInfo:bodySection];
            break;
        case SESSION_PERIOD_RES_TYPE:
            [[NSNotificationCenter defaultCenter] postNotificationName:SESSION_PERIOD_RES_NOTIFICATION object:nil userInfo:bodySection];
            break;
            
        case CMID_APP_LOGIN_SSS_RESP_TYPE: //信令服务器验证响应返回了，通知业务层
            [[NSNotificationCenter defaultCenter] postNotificationName:CMID_APP_LOGIN_SSS_NOTIFICATION object:nil userInfo:bodySection];
            break;
        default:
            break;
    }
    
}

//封装了构造和发送通话请求和回复的过程。 用过使用不同的信令构造器，就可以做到用一套逻辑处理请求和回复两种
- (void) sessionPeriodNegotiation:(NSDictionary*) negotiationData{
    NSDictionary* parsedData =  [self.messageParser parse:negotiationData];
    // 获取本机natType
    NatType natType = [self.engine natType];
    // 获取本机的链路列表
    NSDictionary* communicationAddress = [self.engine endPointAddress];
    //此处我需要做的是字典的数据融合！！！
    NSMutableDictionary* mergeData = [communicationAddress copy];
    [mergeData addEntriesFromDictionary:parsedData];
    [mergeData addEntriesFromDictionary:@{SESSION_PERIOD_FIELD_PEER_NAT_TYPE_KEY: [NSNumber numberWithInt:natType]}];
    // 构造通话数据请求
    NSDictionary* data = [self.messageBuilder buildWithParams:mergeData];
    [self.communicator send:data];
}

#pragma mark - NOTIFICATION HANDLE

// 信令回复数据的处理 采用通知来完成
- (void) receive:(NSNotification*) notify{
    NSLog(@"收到数据，路由给处理逻辑");
    [self route:notify.userInfo];
}

//收到信令服务器的通话查询响应，进行后续业务
- (void) sessionInited:(NSNotification*) notify{
    NSLog(@"收到通话查询响应~");

    self.messageBuilder = [[IMSessionPeriodRequestMessageBuilder alloc] init];
    [self sessionPeriodNegotiation:notify.userInfo];
    // TODO 设置10秒超时，如果没有收到接受通话的回复则转到拒绝流程
    
}

//收到peer端的请求类型，则首先检查自己是否是被占用状态。
//在非占用状态下，10秒内用户主动操作接听，则开始构造响应类型数据，同时本机设置为占用状态，然后开始获取p2p的后续操作
- (void) sessionPeriodRequest:(NSNotification*) notify{
    NSLog(@"收到通话请求，根据数据具体情况，是接受还是拒绝~");
    if (self.state == IN_USE) { // 如果是状态已经是占线了就自动拒绝。
     //TODO构造拒绝信令
        return;
    }
    //首先，开启会话，设置处于占线状态
    [self startSession];
    //既然是接受通话，则信令构造器要换成回复的类型
    self.messageBuilder = [[IMSessionPeriodResponseMessageBuilder alloc] init];
    // 把自身的链路信息作为响应发出，表明本机接受通话请求
    [self sessionPeriodNegotiation:notify.userInfo];
    // 开始获取p2p通道
    [self.engine tunnelWith:notify.userInfo];
    [self.engine startTransport];
}
//如果是处理的peer端的响应类型。那么，有可能是接受通话，则接下来开始进行p2p通道获取; 也有可能是拒绝通话，则通话请求终止
- (void) sessionPeriodResponse:(NSNotification*) notify{
    NSLog(@"收到通话响应，看其中是接受还是拒绝，决定下一步操作~");
    if ([[notify.userInfo valueForKey:@"action"] isEqualToString:@"refuse"]) {
       //被拒绝了。
        [self endSession];
        return;
    }
    //开始获取p2p通道
    [self.engine tunnelWith:notify.userInfo];
    [self.engine startTransport];
    
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
    //启动
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

- (void)dial:(NSString *)account{
    [self testSessionStart:account];
}

@end
