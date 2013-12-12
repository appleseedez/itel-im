//
//  IMFakeItelAction.m
//  im
//
//  Created by Pharaoh on 13-12-12.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMFakeItelAction.h"
#import "IMFackItelUser.h"
static IMFakeItelAction* _instance;
@implementation IMFakeItelAction
+ (void)initialize{
    _instance = [IMFakeItelAction new];
}
+ (IMFakeItelAction *)action{
    return _instance;
}
- (NSArray *)searchInFirendBook:(NSString *)search{
    NSMutableArray* result = [NSMutableArray new];
    for (NSUInteger index = 0; index<10; index++) {
        IMFackItelUser* user = [IMFackItelUser new];
        user.itelNum = @"100002";
        user.nickName = @"永胖";
        [result addObject:user];
    }
    return [result copy];
}
@end
