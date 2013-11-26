//
//  IMInSessionViewController.m
//  im
//
//  Created by Pharaoh on 13-11-26.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMInSessionViewController.h"

@interface IMInSessionViewController ()

@end

@implementation IMInSessionViewController

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
    //开启视频窗口，调整摄像头
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setup{
    
}

- (void) tearDown{
    
}

- (IBAction)endSession:(UIButton *)sender {
    [self.manager haltSession:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
