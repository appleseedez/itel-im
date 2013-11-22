//
//  IMEngineImp.m
//  im
//
//  Created by Pharaoh on 13-11-20.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMEngineImp.h"
#import "AVInterface.h"
#import "NatTypeImpl.h"
#import "ConstantHeader.h"
UIImageView* _pview_local;

@interface IMEngineImp ()
@property(nonatomic) CAVInterfaceAPI* pInterfaceApi;
@property(nonatomic) InitType m_type;
@end

@implementation IMEngineImp
- (id)init{
    if (self = [super init]) {
        if (_pInterfaceApi == nil) {
            _pInterfaceApi = new CAVInterfaceAPI();
        }
    }
    return self;
}

+ (NSString*) localAddress{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6) {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                //NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
                
                if([name isEqualToString:@"en0"]) {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                } else
                    if([name isEqualToString:@"pdp_ip0"]) {
                        // Interface is the cell connection on the iPhone
                        cellAddress = addr;
                    }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    
    NSLog(@"本机ip地址: %@",addr);
    return addr;
}

// IMEngine接口 见接口定义
- (void)initNetwork{
    if (false == self.pInterfaceApi->NetWorkInit(LOCAL_PORT)) {
        [NSException exceptionWithName:@"400: init network failed" reason:@"引擎初始化网络失败" userInfo:nil];
    }
}

- (void)initMedia{
    self.m_type = self.pInterfaceApi->MediaInit(SCREEN_WIDTH,SCREEN_HEIGHT,InitTypeNone);
    NSLog(@"媒体类型：%d",self.m_type);
}

- (NatType)natType{
    NatTypeImpl nat;
    return nat.GetNatType("stunserver.org");
}

- (NSDictionary*)endPointAddress{
    char self_inter_ip[16];
    uint16_t self_inter_port;
    //获取本机外网ip和端口
    self.pInterfaceApi->GetSelfInterAddr(PROBE_SERVER, PROBE_PORT, self_inter_ip, self_inter_port);
    return @{
            SESSION_PERIOD_FIELD_PEER_INTER_IP_KEY: [NSString stringWithUTF8String:self_inter_ip],
             SESSION_PERIOD_FIELD_PEER_INTER_PORT_KEY:[NSNumber numberWithInt:self_inter_port],
             SESSION_PERIOD_FIELD_PEER_LOCAL_IP_KEY:[[self class] localAddress],
             SESSION_PERIOD_FIELD_PEER_LOCAL_PORT_KEY:[NSNumber numberWithInt:22222]
             };
}

- (int)tunnelWith:(NSDictionary*) params{
     TP2PPeerArgc argc;
    
    
    // 外网地址
    ::strncpy(argc.otherInterIP, [[params valueForKey:SESSION_PERIOD_FIELD_PEER_INTER_IP_KEY] UTF8String], sizeof(argc.otherInterIP));
    argc.otherInterPort = [[params valueForKey:SESSION_PERIOD_FIELD_PEER_INTER_PORT_KEY] intValue];
    // 内网地址
    ::strncpy(argc.otherLocalIP, [[params valueForKey:SESSION_PERIOD_FIELD_PEER_LOCAL_IP_KEY] UTF8String], sizeof(argc.otherLocalIP));
    argc.otherLocalPort =  [[params valueForKey:SESSION_PERIOD_FIELD_PEER_LOCAL_PORT_KEY] intValue];
    // 转发地址
    ::strncpy(argc.otherForwardIP,[[params valueForKey:SESSION_INIT_RES_FIELD_FORWARD_IP_KEY] UTF8String], sizeof(argc.otherForwardIP));
    argc.otherForwardPort = [[params valueForKey:SESSION_INIT_RES_FIELD_FORWARD_PORT_KEY] intValue];
    
    // 对方的ssid
    argc.otherSsid = [[params valueForKey:SESSION_INIT_RES_FIELD_SSID_KEY] intValue]+1;
    // 自己的ssid
    argc.selfSsid = [[params valueForKey:SESSION_INIT_RES_FIELD_SSID_KEY] intValue];
    
    
    return 0;
}
- (BOOL)startTransport{
    return NO;
}

- (void)stopTransport{
    
}
- (void)openScreen{
}
- (void)closeScreen{
    
}
@end
