//
//  IMSessionPeriodResponseMessageBuilder.m
//  im
//
//  Created by Pharaoh on 13-11-22.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMSessionPeriodResponseMessageBuilder.h"
#import "ConstantHeader.h"
#import "IMSeqenceGen.h"
@implementation IMSessionPeriodResponseMessageBuilder
- (NSDictionary *)buildWithParams:(NSDictionary *)params{
    return @{
             HEAD_SECTION_KEY:@{
                     DATA_TYPE_KEY: [NSNumber numberWithInt:SESSION_PERIOD_RES_TYPE],
                     DATA_STATUS_KEY:[NSNumber numberWithInt:NORMAL_STATUS],
                     DATA_SEQ_KEY:[NSNumber numberWithInteger:[IMSeqenceGen seq]]
                     },
             BODY_SECTION_KEY:params
             
             };
}
@end
