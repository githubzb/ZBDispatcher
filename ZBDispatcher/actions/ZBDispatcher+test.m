//
//  ZBDispatcher+test.m
//  ZBDispatcher
//
//  Created by 张宝 on 2018/7/26.
//  Copyright © 2018年 zb. All rights reserved.
//

#import "ZBDispatcher+test.h"

@implementation ZBDispatcher (test)

+ (void)say:(NSString *)str{
    ZBDispatchAction(@"Test", @"say", str);
}

+ (void)notFound{
    ZBDispatchAction(@"Test", @"say2", nil);
}

+ (BOOL)hasStr:(NSString *)str{
    return ZBReturnBoolAction(@"Test", @"hasStr", str);
}

+ (NSInteger)sum:(NSArray<NSNumber *> *)ns{
    return ZBReturnNumberAction(@"Test", @"sum", ns).integerValue;
}

+ (NSString *)lower:(NSString *)str{
    return ZBReturnStringAction(@"Test", @"lower", str);
}

+ (NSArray *)separated:(NSString *)str byString:(NSString *)sepStr{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    [params setValue:str forKey:@"str"];
    [params setValue:sepStr forKey:@"sepStr"];
    return ZBReturnArrayAction(@"Test", @"separatedByString", params);
}

+ (NSDictionary *)paramsByURL:(NSString *)url{
    return ZBReturnDictionary(@"Test", @"paramsByURL", [NSURL URLWithString:url]);
}

@end
