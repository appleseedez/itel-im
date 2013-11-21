//
//  BTViewController.h
//  im
//
//  Created by Pharaoh on 13-11-6.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMRootViewController : UIViewController
- (IBAction)dial:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *numberField;

@end
