//
//  IMDailViewController.m
//  im
//
//  Created by Pharaoh on 13-11-26.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMDailViewController.h"
#import "ConstantHeader.h"
@interface IMDailViewController ()

@end

@implementation IMDailViewController

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
    if (![self.peerAccount.text length]) {
        self.backspaceButton.hidden = YES;
    }else{
        self.backspaceButton.hidden = NO;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)voiceDialing:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:PRESENT_CALLING_VIEW_NOTIFICATION object:nil userInfo:nil];
}

- (IBAction)videoDialing:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:PRESENT_ANSWERING_VIEW_NOTIFICATION object:nil userInfo:nil];
}
- (IBAction)dialNumber:(UIButton *)sender {
    if ([self.peerAccount.text length] >=13) {
        return;
    }
    NSString* currentDig = sender.titleLabel.text;
    NSMutableString* currentSequence =[self.peerAccount.text mutableCopy];
    [currentSequence appendString:currentDig];
    self.peerAccount.text = [currentSequence copy];
    if ([self.peerAccount.text length] > 0) {
        self.backspaceButton.hidden = NO;
    }else{
        self.backspaceButton.hidden = YES;
    }


}

- (IBAction)backspace:(UIButton *)sender {
    NSLog(@"pressed!");
    NSInteger length = [self.peerAccount.text length];
    if (length == 1) {
        self.backspaceButton.hidden = YES;
    }
    NSString* temp = [self.peerAccount.text substringToIndex:length-1];
    self.peerAccount.text = temp;
}
@end
