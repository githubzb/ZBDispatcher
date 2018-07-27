//
//  ZBDispatcher.m
//  ZBDispatcher
//
//  Created by 张宝 on 2018/7/26.
//  Copyright © 2018年 zb. All rights reserved.
//

#import "ZBDispatcher.h"

NSString *const ZBDispatchNotFoundTarget = @"ZBTargetNotFound";
NSString *const ZBDispatchNotFoundAction = @"ZBActionNotFound";

NSNumber * zbtransformNumber(id value){
    if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    }
    return nil;
}
BOOL zbtransformBool(id value){
    return [zbtransformNumber(value) boolValue];
}
NSString * zbtransformString(id value){
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    return nil;
}
NSArray * zbtransformArray(id value){
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return nil;
}
NSDictionary * zbtransformDictionary(id value){
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return nil;
}

@interface ZBDispatcher ()

@end
@implementation ZBDispatcher

+ (instancetype)shareDispatcher{
    static ZBDispatcher *dispatcher;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatcher = [[ZBDispatcher alloc] init];
    });
    return dispatcher;
}

+ (BOOL)performActionWithURL:(NSURL *)url
                  completion:(ZBDispatchCompletion)completion{
    return [[self shareDispatcher] performActionWithURL:url
                                             completion:completion];
}

+ (id)performTarget:(NSString *)targetName
             action:(NSString *)actionName object:(id)object{
    id res = [[self shareDispatcher] performTarget:targetName
                                            action:actionName
                                            object:object];
    if ([res isKindOfClass:[NSString class]] &&
        ([res isEqualToString:ZBDispatchNotFoundTarget]||
         [res isEqualToString:ZBDispatchNotFoundAction]))
    {
        return nil;
    }
    return res;
}

+ (void)addAllowedScheme:(NSString *)scheme{
    [[[self shareDispatcher] schemes] addObject:scheme];
}

- (NSMutableArray *)schemes{
    if (!_schemes) {
        _schemes = [[NSMutableArray alloc] init];
    }
    return _schemes;
}

#pragma mark - private
- (NSString *)join:(NSString *)key val:(NSString *)val hasParams:(BOOL)has{
    NSString *prefix = self.prefix?:@"ZB";
    return [NSString stringWithFormat:@"%@%@_%@%@", prefix, key, val, has?@":":@""];
}
- (id)performTarget:(NSString *)targetName
             action:(NSString *)actionName object:(id)object{
    NSString *targetClsString = [self join:@"Target" val:targetName hasParams:NO];
    NSString *actionString = [self join:@"Action" val:actionName hasParams:YES];
    NSString *actionNoParamsString = [self join:@"Action" val:actionName hasParams:NO];
    Class cls = NSClassFromString(targetClsString);
    id target = [[cls alloc] init];
    if (target == nil) {
        return ZBDispatchNotFoundTarget;
    }
    SEL action = NSSelectorFromString(actionString);
    if ([target respondsToSelector:action]) {
        return [self sendTarget:target performSelector:action withObject:object];
    }
    action = NSSelectorFromString(actionNoParamsString);
    if ([target respondsToSelector:action]) {
        return [self sendTarget:target performSelector:action withObject:nil];
    }
    NSString *methodName = [self join:@"Action" val:@"notFound" hasParams:YES];
    action = NSSelectorFromString(methodName);
    if ([target respondsToSelector:action]) {
        return [self sendTarget:target performSelector:action withObject:object];
    }
    methodName = [self join:@"Action" val:@"notFound" hasParams:NO];
    action = NSSelectorFromString(methodName);
    if ([target respondsToSelector:action]) {
        return [self sendTarget:target performSelector:action withObject:nil];
    }
    return ZBDispatchNotFoundAction;
}
- (id)sendTarget:(id)target
 performSelector:(SEL)selector withObject:(id)object{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([self isReturnVoidForTarget:target action:selector]) {
        [target performSelector:selector withObject:object];
        return nil;
    }
    id ret;
    @try{
        ret = [target performSelector:selector withObject:object];
    }@catch(NSException *exc){
        ret = nil;
    }
#pragma clang diagnostic pop
    return ret;
}
//判断返回值类型是void
- (BOOL)isReturnVoidForTarget:(id)target action:(SEL)action{
    NSMethodSignature *signature = [target methodSignatureForSelector:action];
    if (!signature) {
        return NO;
    }
    NSString *type = [NSString stringWithUTF8String:signature.methodReturnType];
    return [type isEqualToString:@"v"];
}
//判断当前URL scheme是否被允许调用
- (BOOL)allowedScheme:(NSString *)scheme{
    if ([self.schemes count]>0) {
        return [self.schemes containsObject:scheme];
    }
    return NO;
}
- (void)safeCompletion:(ZBDispatchCompletion)completion
                 state:(ZBRemoteDispatchState)state
                   url:(NSString *)url
{
    if (completion) {
        completion(state, url);
    }
}
- (BOOL)performActionWithURL:(NSURL *)url
                  completion:(ZBDispatchCompletion)completion{
    NSString *urlStr = [url absoluteString];
    if (![self allowedScheme:url.scheme]) {
        [self safeCompletion:completion
                       state:ZBRemoteDispatchStateNotAllowScheme
                         url:urlStr];
        return NO;
    }
    // 安全处理，远程APP只能调度非native的方法
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/"
                                                               withString:@""];
    if ([actionName hasPrefix:self.safeActionPrefix?:@"native"]) {
        [self safeCompletion:completion
                       state:ZBRemoteDispatchStateRejected
                         url:urlStr];
        return NO;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *query = [url query];
    for (NSString *param in [query componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        id value = [elts lastObject];
        [params setObject:[value stringByRemovingPercentEncoding]
                   forKey:[elts firstObject]];
    }
    NSDictionary *pms = [NSDictionary dictionaryWithDictionary:params];
    id res = [self performTarget:url.host
                          action:actionName
                          object:pms];
    if ([res isKindOfClass:[NSString class]]) {
        if ([res isEqualToString:ZBDispatchNotFoundTarget]) {
            [self safeCompletion:completion
                           state:ZBRemoteDispatchStateNotFoundTarget
                             url:urlStr];
            return NO;
        }
        if ([res isEqualToString:ZBDispatchNotFoundAction]) {
            [self safeCompletion:completion
                           state:ZBRemoteDispatchStateNotFoundAction
                             url:urlStr];
            return NO;
        }
    }
    [self safeCompletion:completion
                   state:ZBRemoteDispatchStateSuccess url:urlStr];
    return YES;
}

@end
