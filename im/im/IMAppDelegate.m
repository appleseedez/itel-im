//
//  BTAppDelegate.m
//  im
//
//  Created by Pharaoh on 13-11-6.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMAppDelegate.h"
#import "IMManagerImp.h"
#import "IMRootTabBarViewController.h"
@interface IMAppDelegate()

@end

@implementation IMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //初始化
#if APP_DELEGATE_DEBUG
    NSLog(@"调用 didFinishLaunchingWithOptions");
#endif
    self.manager = [[IMManagerImp alloc] init];
    [self.manager setup];
    IMRootTabBarViewController* rootController =(IMRootTabBarViewController*) self.window.rootViewController;
    rootController.manager = self.manager;
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
#if APP_DELEGATE_DEBUG
    NSLog(@"调用 applicationWillResignActive");
#endif
    [self.manager disconnectToSignalServer];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
#if APP_DELEGATE_DEBUG
    NSLog(@"调用 applicationDidEnterBackground");
#endif
    [self.manager tearDown];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
#if APP_DELEGATE_DEBUG
    NSLog(@"调用 applicationWillEnterForeground ");
#endif
    [self.manager setup];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
#if APP_DELEGATE_DEBUG
    NSLog(@"调用 applicationDidBecomeActive ");
#endif
    [self.manager connectToSignalServer];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
#if APP_DELEGATE_DEBUG
    NSLog(@"调用 applicationWillTerminate");
#endif
    [self.manager tearDown];
}

@end
