//
//  IMInSessionViewController.h
//  im
//
//  Created by Pharaoh on 13-11-26.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMManager.h"
@interface IMInSessionViewController : UIViewController
@property(nonatomic,weak) id<IMManager> manager;
- (IBAction)endSession:(UIButton *)sender;
@property(nonatomic,strong) NSNotification* inSessionNotify;
@end