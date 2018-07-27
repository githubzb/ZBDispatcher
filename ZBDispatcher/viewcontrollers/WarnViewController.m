//
//  WarnViewController.m
//  ZBDispatcher
//
//  Created by 张宝 on 2018/7/27.
//  Copyright © 2018年 zb. All rights reserved.
//

#import "WarnViewController.h"

@interface WarnViewController ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *urlLabel;

@end

@implementation WarnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.titleString;
    self.urlLabel.text = self.url;
}

- (IBAction)clickDismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
