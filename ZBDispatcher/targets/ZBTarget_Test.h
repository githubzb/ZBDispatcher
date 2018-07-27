//
//  ZBTarget_Test.h
//  ZBDispatcher
//
//  Created by 张宝 on 2018/7/26.
//  Copyright © 2018年 zb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBTarget_Test : NSObject

- (void)ZBAction_say:(NSString *)str;
- (NSNumber *)ZBAction_hasStr:(NSString *)str;
- (NSNumber *)ZBAction_sum:(NSArray *)arr;
- (NSString *)ZBAction_lower:(NSString *)str;
- (NSArray *)ZBAction_separatedByString:(NSDictionary *)params;
- (NSDictionary *)ZBAction_paramsByURL:(NSURL *)url;
- (void)ZBAction_showName:(NSDictionary *)params;
- (void)ZBAction_nativeShowName:(NSDictionary *)params;

@end
