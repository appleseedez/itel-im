//
//  IMFakeItelAction.h
//  im
//
//  Created by Pharaoh on 13-12-12.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMFakeItelAction : NSObject
+(IMFakeItelAction*)action;
//模糊查找好友
-(NSArray*)searchInFirendBook:(NSString*)search;
@end
