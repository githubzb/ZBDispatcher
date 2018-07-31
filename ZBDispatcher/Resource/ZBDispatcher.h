//
//  ZBDispatcher.h
//  ZBDispatcher
//
//  Created by 张宝 on 2018/7/26.
//  Copyright © 2018年 zb. All rights reserved.
//

#import <Foundation/Foundation.h>

///远程调度状态
typedef NS_ENUM(NSInteger, ZBRemoteDispatchState){
    
    ///调度成功
    ZBRemoteDispatchStateSuccess =         0,
    ///不符合scheme的调度
    ZBRemoteDispatchStateNotAllowScheme =  1,
    ///调度不合法
    ZBRemoteDispatchStateRejected =        2,
    ///未找到执行者
    ZBRemoteDispatchStateNotFoundTarget =  3,
    ///未找到执行方法
    ZBRemoteDispatchStateNotFoundAction =  4
};

//类型转换的方法
NSNumber * zbtransformNumber(id value);
BOOL zbtransformBool(id value);
NSString * zbtransformString(id value);
NSArray * zbtransformArray(id value);
NSDictionary * zbtransformDictionary(id value);

//快捷调用
#undef ZBDispatchAction
#define ZBDispatchAction(tName, aName, p) \
([ZBDispatcher performTarget:tName action:aName object:p])

#undef ZBReturnBoolAction
#define ZBReturnBoolAction(tn, an, pm) \
(zbtransformBool(ZBDispatchAction(tn, an, pm)))

#undef ZBReturnNumberAction
#define ZBReturnNumberAction(tn, an, pm) \
(zbtransformNumber(ZBDispatchAction(tn, an, pm)))

#undef ZBReturnStringAction
#define ZBReturnStringAction(tn, an, pm) \
(zbtransformString(ZBDispatchAction(tn, an, pm)))

#undef ZBReturnArrayAction
#define ZBReturnArrayAction(tn, an, pm) \
(zbtransformArray(ZBDispatchAction(tn, an, pm)))

#undef ZBReturnDictionary
#define ZBReturnDictionary(tn, an, pm) \
(zbtransformDictionary(ZBDispatchAction(tn, an, pm)))

NS_ASSUME_NONNULL_BEGIN

typedef void (^ZBDispatchCompletion)(ZBRemoteDispatchState state, NSString *url);

@interface ZBDispatcher : NSObject
///调用者和执行方法的前缀（默认：ZB）
@property (nonatomic, copy) NSString *prefix;
///安全的方法名前缀（默认：native）
@property (nonatomic, copy) NSString *safeActionPrefix;
///允许调度的schemes
@property (nonatomic, strong) NSMutableArray<NSString *> *schemes;

+ (instancetype)shareDispatcher;

/**
 执行远程调度

 @param url         scheme://[targetName]/[actionName]?[parameter]
 @param completion  remote dispatch perform finish return block
 @return            (allowed scheme return YES else NO)
 */
+ (BOOL)performActionWithURL:(NSURL *)url
                  completion:(nullable ZBDispatchCompletion)completion;

/**
 事件调度（如果action找不到，会执行target的前缀+Action_notFound:方法）

 @param targetName  调用者名称(不包括前缀)
 @param actionName  执行方法名(不包括前缀)
 @param object      传入参数
 @return            执行方法返回值
 */
+ (id)performTarget:(NSString *)targetName
             action:(NSString *)actionName
             object:(nullable id)object;

/**
 添加允许调度的scheme

 @param scheme a scheme
 */
+ (void)addAllowedScheme:(NSString *)scheme;

@end
NS_ASSUME_NONNULL_END

typedef ZBDispatcher zb;
