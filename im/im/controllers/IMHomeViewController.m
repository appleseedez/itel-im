//
//  IMHomeViewController.m
//  im
//
//  Created by Pharaoh on 13-11-22.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import "IMHomeViewController.h"
#import "IMManager.h"
#import "IMManagerImp.h"
@interface IMHomeViewController ()
@property(nonatomic) id<IMManager> manager;
@end

@implementation IMHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

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

- (void) registerNotifications{
    
}

//收起键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)popDialPanel:(UIBarButtonItem *)sender {
    [self.itelNumberField becomeFirstResponder];
}

- (IBAction)dial:(UIButton *)sender {
    [self.manager dial:self.itelNumberField.text];
}

- (IBAction)answerDial:(UIButton *)sender {
}
@end
