//
//  IMCallingViewController.m
//  im
//
//  Created by Pharaoh on 13-11-26.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMCallingViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ConstantHeader.h"
#import "IMInSessionViewController.h"
static int soundCount;
@interface IMCallingViewController ()
@end

@implementation IMCallingViewController

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
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self tearDown];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelCalling:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) setup{
    self.peerAccountLabel.text = [NSString stringWithFormat:@"呼叫用户 %@",[self.callingNotify.userInfo valueForKey:SESSION_INIT_REQ_FIELD_DEST_ACCOUNT_KEY]];
    //开始拨号了。播放声音
    soundCount = 0;//给拨号音计数，响八次就可以结束
    //系统声音播放是一个异步过程。要循环播放则必须借助回调
    AudioServicesAddSystemSoundCompletion(DIALING_SOUND_ID,NULL,NULL,soundPlayCallback,NULL);
    AudioServicesPlaySystemSound(DIALING_SOUND_ID);
    //监听 "PRESENT_INSESSION_VIEW_NOTIFICATION"// 通知加载“通话中界面”
    [self registerNotifications];
}

- (void) tearDown{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //用户取消了。终止声音播放
    AudioServicesRemoveSystemSoundCompletion(DIALING_SOUND_ID);
    AudioServicesDisposeSystemSoundID(DIALING_SOUND_ID);
}
-(void) registerNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(intoSession:) name:PRESENT_INSESSION_VIEW_NOTIFICATION object:nil];
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


#pragma mark - HANDLER
- (void)intoSession:(NSNotification*) notify{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    IMInSessionViewController* insessionController = [sb instantiateViewControllerWithIdentifier:INSESSION_VIEW_CONTROLLER_ID];
    insessionController.manager = self.manager;
    insessionController.inSessionNotify = notify;
    [self presentViewController:insessionController animated:YES completion:nil];
    
}
@end
