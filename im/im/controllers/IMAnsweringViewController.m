//
//  IMAnsweringViewController.m
//  im
//
//  Created by Pharaoh on 13-11-26.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMAnsweringViewController.h"

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
    self.peerAccountLabel.text =
    [NSString stringWithFormat:@"用户 %@ 来电...",
    [self.callingNotify.userInfo valueForKey:SESSION_INIT_REQ_FIELD_DEST_ACCOUNT_KEY]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)answerCall:(UIButton *)sender {
    [self.manager acceptSession:self.callingNotify];
}

- (IBAction)refuseCall:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
