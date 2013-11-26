//
//  IMAnsweringViewController.h
//  im
//
//  Created by Pharaoh on 13-11-26.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMAnsweringViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *peerAvatarImageView;
- (IBAction)answerCall:(UIButton *)sender;
- (IBAction)refuseCall:(UIButton *)sender;

@end
