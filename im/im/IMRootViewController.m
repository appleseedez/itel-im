//
//  BTViewController.m
//  im
//
//  Created by Pharaoh on 13-11-6.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMRootViewController.h"
#import "IMManager.h"
#import "IMManagerImp.h"
@interface IMRootViewController ()
@property(nonatomic) id<IMManager> manager;
@end

@implementation IMRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.manager = [[IMManagerImp alloc] init];
    [self.manager setup];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dial:(UIButton *)sender {
    NSString* itelNumber =  self.numberField.text;
    NSLog(@"号码是: %@",itelNumber);
    
}
@end
