//
//  BTAppDelegate.h
//  im
//
//  Created by Pharaoh on 13-11-6.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMManager.h"
@interface IMAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
//由applicationDelegate来管理manager
@property (nonatomic,strong) id<IMManager> manager;
@end
