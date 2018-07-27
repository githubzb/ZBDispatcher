//
//  SuccessViewController.m
//  ZBDispatcher
//
//  Created by 张宝 on 2018/7/27.
//  Copyright © 2018年 zb. All rights reserved.
//

#import "SuccessViewController.h"

@interface SuccessViewController ()

@property (nonatomic, weak) IBOutlet UILabel *textLabel;

@end

@implementation SuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"调度成功!";
    self.textLabel.text = self.name;
}

- (IBAction)clickDismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
