//
//  ConstantHeader.h
//  im
//
//  Created by Pharaoh on 13-11-20.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#ifndef im_ConstantHeader_h
#define im_ConstantHeader_h

// 常量定义
#define PARSED_DATA_KEY @"PARSED_DATA_KEY" //数据暂存池的key

#define DATA_RECEIVED_NOTIFICATION @"DATA_RECEIVED_NOTIFICATION" // 收到通知标识
#define SESSION_INITED_NOTIFICATION @"SESSION_INITED_NOTIFICATION" // 收到通话查询响应
#define SESSION_PERIOD_NOTIFICATION @"SESSION_PERIOD_NOTIFICATION" // 收到通话接受
#define CMID_APP_LOGIN_SSS_NOTIFICATION @"CMID_APP_LOGIN_SSS_NOTIFICATION" // 收到信令服务器验证回复

#define HEAD_SECTION_KEY @"head"
#define BODY_SECTION_KEY @"body"
#define DATA_TYPE_KEY @"type"
#define DATA_STATUS_KEY @"status"
#define DATA_SEQ_KEY @"seq"

#define SEQ_BASE 0 // 发送包的序列号基底
#define HEART_BEAT_INTERVAL 15 // 心跳间隔15秒
#define HEART_BEAT_REQ_TYPE 0x00000000 //心跳包请求类型

#define SESSION_INIT_REQ_TYPE 0x00000003  // 通话查询请求
#define SESSION_INIT_RES_TYPE 0x00010003  // 通话查询响应

#define CMID_APP_LOGIN_SSS_REQ_TYPE 0x00000002 // app客户端登录业务服务器请求
#define CMID_APP_LOGIN_SSS_RESP_TYPE 0x00010002 // app客户端登录业务服务器应答

#define SESSION_PERIOD_REQ_TYPE 0x00000004 // 通话过程请求
#define SESSION_PERIOD_RES_TYPE 0x00010004 // 通话过程响应

#define SESSION_PERIOD_PROCEED_TYPE 0x00000040 //表明发送的是通话链接类型 是SESSION_PERIOD的子类型。因为会出现发送通话链接请求，而对方回复通话拒绝的情况
#define SESSION_PERIOD_HALT_TYPE 0x00000080 //表明发送的是通话终止类型

#define HEAD_REQ 0x01111111  // 是数据长度meta包
#define COMMON_PKG_RES 0x01111110 //这表明数据包是一个业务数据

#define NORMAL_STATUS 0

#define IN_USE 1
#define IDLE 0
#define SCREEN_WIDTH 144
#define SCREEN_HEIGHT 192

#define SIGNAL_SERVER_IP @"192.168.1.110"
#define SIGNAL_SERVER_PORT 9989
#define LOCAL_PORT 11111
#define PROBE_SERVER "118.123.7.92"
#define PROBE_PORT 11111

#define SELF_INTER_IP_KEY @"peerInterIP"
#define SELF_INTER_PORT_KEY @"peerInterPort"
#define SELF_LOCAL_IP_KEY @"peerLocalIP"
#define SELF_LOCAL_PORT_KEY @"peerLocalPort"
#define SELF_FORWARD_IP_KEY @"peerForwardIP"
#define SELF_FORWARD_PORT_KEY @"peerForwardPort"

#endif
