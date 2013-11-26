//
//  IMAnsweringViewController.m
//  im
//
//  Created by Pharaoh on 13-11-26.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMAnsweringViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "IMInSessionViewController.h"
static int soundCount;
@interface IMAnsweringViewController ()

@end

@implementation IMAnsweringViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setup];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self tearDown];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setup{
    self.peerAccountLabel.text = [NSString stringWithFormat:@"用户 %@ 来电...", [self.callingNotify.userInfo valueForKey:SESSION_INIT_REQ_FIELD_DEST_ACCOUNT_KEY]];
    soundCount = 0;//给拨号音计数，响八次就可以结束
    //系统声音播放是一个异步过程。要循环播放则必须借助回调
    AudioServicesAddSystemSoundCompletion(DIALING_SOUND_ID,NULL,NULL,soundPlayCallback,NULL);
    AudioServicesPlaySystemSound(DIALING_SOUND_ID);
}
- (void) tearDown{
    //终止拨号音
    AudioServicesRemoveSystemSoundCompletion(DIALING_SOUND_ID);
    AudioServicesDisposeSystemSoundID(DIALING_SOUND_ID);
}
//循环播放声音
void soundPlayCallback(SystemSoundID soundId, void *clientData){
    if (soundCount>9) {
        AudioServicesRemoveSystemSoundCompletion(DIALING_SOUND_ID);
        AudioServicesDisposeSystemSoundID(DIALING_SOUND_ID);
    }
    soundCount++;
    AudioServicesPlaySystemSound(DIALING_SOUND_ID);
}

#pragma mark - USER INTERACT
- (IBAction)answerCall:(UIButton *)sender {
    [self.manager acceptSession:self.callingNotify];
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    IMInSessionViewController* inSessionController = [sb instantiateViewControllerWithIdentifier:INSESSION_VIEW_CONTROLLER_ID];
    inSessionController.manager = self.manager;
    inSessionController.inSessionNotify = self.callingNotify;
}

- (IBAction)refuseCall:(UIButton *)sender {
    //终止会话
    [self.manager haltSession:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
