//
//  ViewController.m
//  ZBDispatcher
//
//  Created by 张宝 on 2018/7/26.
//  Copyright © 2018年 zb. All rights reserved.
//

#import "ViewController.h"
#import "ZBDispatcher+test.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self doTest];
}

- (void)doTest{
    [ZBDispatcher say:@"hello!"];
    [ZBDispatcher notFound];
    NSString *str = @"abc";
    if ([ZBDispatcher hasStr:str]) {
        NSLog(@"-----:has %@", str);
    }else{
        NSLog(@"-----:no has %@", str);
    }
    NSInteger count = [ZBDispatcher sum:@[@1,@2,@3]];
    NSLog(@"----sum:%@",@(count));
    
    NSString *ss = @"ABC";
    ss = [ZBDispatcher lower:ss];
    NSLog(@"----lower:%@", ss);
    
    ss = @"abc/bcd/123/ddd";
    NSArray *arr = [ZBDispatcher separated:ss byString:@"/"];
    NSLog(@"----array:%@", arr);
    
    NSString *url = @"https://m.jk.com/a?a=12&b=df34&c=222";
    NSDictionary *params = [ZBDispatcher paramsByURL:url];
    NSLog(@"----params:%@", params);
}

@end
