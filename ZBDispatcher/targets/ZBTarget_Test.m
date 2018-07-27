//
//  ZBTarget_Test.m
//  ZBDispatcher
//
//  Created by 张宝 on 2018/7/26.
//  Copyright © 2018年 zb. All rights reserved.
//

#import "ZBTarget_Test.h"
#import "SuccessViewController.h"

@implementation ZBTarget_Test

- (void)ZBAction_say:(NSString *)str{
    NSLog(@"-----say:%@", str);
}

- (void)ZBAction_notFound:(NSDictionary *)params{
    NSLog(@"-----notfound:%@", params);
}

- (NSNumber *)ZBAction_hasStr:(NSString *)str{
    return [NSNumber numberWithBool:[str isEqualToString:@"abc"]];
}

- (NSNumber *)ZBAction_sum:(NSArray *)arr{
    return [arr valueForKeyPath:@"@sum.integerValue"];
}

- (NSString *)ZBAction_lower:(NSString *)str{
    return str.lowercaseString;
}

- (NSArray *)ZBAction_separatedByString:(NSDictionary *)params{
    NSString *str = params[@"str"];
    NSString *sepStr = params[@"sepStr"];
    return [str componentsSeparatedByString:sepStr];
}

- (NSDictionary *)ZBAction_paramsByURL:(NSURL *)url{
    NSString *query = url.query;
    NSArray *arr = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:arr.count];
    for (NSString *str in arr) {
        NSArray *list = [str componentsSeparatedByString:@"="];
        if (list.count>1) {
            [dic setValue:list.lastObject forKey:list.firstObject];
        }
    }
    return [NSDictionary dictionaryWithDictionary:dic];
}

- (void)ZBAction_showName:(NSDictionary *)params{
    SuccessViewController *vc = [[SuccessViewController alloc] initWithNibName:@"SuccessViewController" bundle:nil];
    vc.name = params[@"name"];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)ZBAction_nativeShowName:(NSDictionary *)params{
    [self ZBAction_showName:params];
}

@end
