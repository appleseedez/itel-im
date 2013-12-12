//
//  IMFackItelUser.h
//  im
//
//  Created by Pharaoh on 13-12-12.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMFackItelUser : NSObject
@property (nonatomic,strong) NSString *itelNum;    //itel号码
@property (nonatomic,strong) NSString *telNum;     // 电话号码
@property (nonatomic,strong) NSString *imageurl;   //头像地址
@property (nonatomic)        BOOL sex;             //性别
@property (nonatomic)        BOOL countType;       //账号类型
@property (nonatomic,strong) NSString *nickName;   //昵称
@property (nonatomic,strong) NSString *remarkName; //备注
@property (nonatomic)        BOOL isFirend;    //好友关系
@property (nonatomic)        BOOL isBlack;     //黑名单关系
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *personalitySignature; //个性签名
@end
