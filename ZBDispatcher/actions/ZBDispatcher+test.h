//
//  ZBDispatcher+test.h
//  ZBDispatcher
//
//  Created by 张宝 on 2018/7/26.
//  Copyright © 2018年 zb. All rights reserved.
//

#import "ZBDispatcher.h"

@interface ZBDispatcher (test)

+ (void)say:(NSString *)str;
+ (void)notFound;
+ (BOOL)hasStr:(NSString *)str;
+ (NSInteger)sum:(NSArray<NSNumber *> *)ns;
+ (NSString *)lower:(NSString *)str;
+ (NSArray *)separated:(NSString *)str byString:(NSString *)sepStr;
+ (NSDictionary *)paramsByURL:(NSString *)url;

@end
