//
//  AppDelegate.m
//  ZBDispatcher
//
//  Created by 张宝 on 2018/7/26.
//  Copyright © 2018年 zb. All rights reserved.
//

#import "AppDelegate.h"
#import "ZBDispatcher.h"
#import "WarnViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置允许调度的scheme
    [ZBDispatcher addAllowedScheme:@"app"];
    
    /***测试url
     1、app://Test/showName?name=dr.box          成功跳转
     2、app://Test/nativeShowName?name=dr.box    无权访问
     3、weixin://a/b?d=3                         scheme不允许访问
     4、app://Test2/showName?name=dr.box         未找到执行者
     5、app://abc/togo                           未找到执行方法
     ***/
    
    return YES;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    return [ZBDispatcher performActionWithURL:url
                                   completion:^(ZBRemoteDispatchState state, NSString * _Nonnull url)
            {
                if (state == ZBRemoteDispatchStateSuccess) {
                    return;
                }
                NSString *title = nil;
                if (state == ZBRemoteDispatchStateRejected) {
                    //无权限访问
                    title = @"你无权访问!";
                }
                if (state == ZBRemoteDispatchStateNotAllowScheme) {
                    //不被允许的scheme
                    title = @"该scheme不被允许!";
                }
                if (state == ZBRemoteDispatchStateNotFoundTarget) {
                    //调度对象未找到
                    title = @"未发现执行者";
                }
                if (state == ZBRemoteDispatchStateNotFoundAction) {
                    //调度方法未找到
                    title = @"未发现执行方法";
                }
                [self pushWarnPageByTitle:title url:url];
            }];
}

- (void)pushWarnPageByTitle:(NSString *)title url:(NSString *)url{
    WarnViewController *vc = [[WarnViewController alloc]
                              initWithNibName:@"WarnViewController" bundle:nil];
    vc.titleString = title;
    vc.url = url;
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
}


@end
