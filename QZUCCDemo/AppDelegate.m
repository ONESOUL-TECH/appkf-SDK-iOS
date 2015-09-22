//
//  AppDelegate.m
//  QZUCCDemo
//
//  Created by tang.johannes on 15/2/12.
//  Copyright (c) 2015年 tang.johannes. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"

#import <QZUCC/QZUCC.h>

#define kDemoServer @"os.qyucc.com:809"
#define kDemoUser @"200000211101"
#define kDemoUserToken @""

@interface AppDelegate () <QZUCCDelegate> {
    
}

@property (nonatomic, retain) MainViewController *tableCtrl;


@end

@implementation AppDelegate

@synthesize tableCtrl;

- (void)dealloc
{
    [tableCtrl release];
    
    [super dealloc];
}

- (void)configureRemoteNotification:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions
{
    //
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        //
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self configureRemoteNotification:application launchOptions:launchOptions];
    
    //
    [self configureUIStyle];
    
    //Step:1
    [QZUCC initWithAbility:@"[\"IM\",\"Phone\",\"Agent\"]" delegate:self];
    
    
    //Step:2
    //ps：注意有些设备可能无法获取token的情况
    //qingzhicall环境 - 测试帐号 - 200000110003
//    [[QZUCC getInstance] connectWithUCMUrl:kDemoServer qzId:kDemoUser authToken:kDemoUserToken deviceToken:nil completion:^{
//        
//        NSLog(@"======授权成功=========");
//        
//    } fail:^(NSError *error) {
//        NSLog(@"======授权失败=========%@", error);
//    }];
    
    //
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    self.tableCtrl = [[[MainViewController alloc] init] autorelease];
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:tableCtrl] autorelease];
    
    self.window.rootViewController = nav;
    //
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Remote Notifications

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    
    NSString *deviceToken = [[[[devToken description]
                               stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *bundleIdentifier = [bundle bundleIdentifier];
    
    deviceToken = [NSString stringWithFormat:@"%@:%@",bundleIdentifier,deviceToken];
    
    //Step:2
    //ps：注意有些设备可能无法获取token的情况
//    [[QZUCC getInstance] connectWithUCMUrl:kDemoServer qzId:kDemoUser authToken:kDemoUserToken deviceToken:deviceToken completion:^{
//        
//        NSLog(@"======授权成功=========");
//        
//    } fail:^(NSError *error) {
//        NSLog(@"======授权失败=========%@", error);
//    }];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设备不支持推送服务." delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [myAlert show];
    [myAlert release];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    BOOL isProcessed = [[QZUCC getInstance] parseReceiveRemoteNotification:userInfo];
    if (isProcessed) {
        return;
    }
}



#pragma mark - Local Notification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    BOOL isProcessed = [[QZUCC getInstance] parseReceiveLocalNotification:notification.userInfo];
    if (isProcessed) {
        return;
    }
}

#pragma mark - View

- (void)configureUIStyle
{
    //
    if ([UINavigationBar respondsToSelector: @selector(appearance)])
    {
        if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
            
            UIColor *blueColor =  [UIColor colorWithRed:83/255.0 green:173/255.0 blue:241/255.0 alpha:1];
            
            self.window.tintColor = blueColor;
            
            [[UINavigationBar appearance] setBarTintColor:blueColor];
            [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
            [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"transparent-point"]];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            
        } else {
            [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"QZUCC.bundle/nav_bar_bg"] forBarMetrics:UIBarMetricsDefault];
        }
    }
}

#pragma mark - QZUCCDelegate

/**
 * 获取AppDelegate下root view ctrl
 * @return self.window.rootViewController;
 */
- (UIViewController *)getAppRootViewController
{
    return self.window.rootViewController;
}

/**
 * 查询用户
 * @param paramString 参数字符串
 * @param type 参数类型，详见ParamType
 * @return 查询成功返回QUserInfo对象,否则返回nil
 */
- (QUserInfo *)getQUserInfo:(NSString *)paramString type:(ParamType)type
{
    
    QUserInfo *usrInfo = nil;
    if (type == ParamTypeQZId) {
        
        usrInfo = [[[QUserInfo alloc] init] autorelease];
        //TODO:第三方应用负责补充，QZUCC关联帐户信息查询
        
        usrInfo.qzId = @"1111";
        usrInfo.name = @"客服";
        usrInfo.profileUrl = nil;
        
    } else if (type == ParamTypePhoneNumber) {
        
        usrInfo = [[[QUserInfo alloc] init] autorelease];
        //TODO:第三方应用负责补充，如企业通讯录或客户通讯录中查询
        usrInfo.name = @"客服";
    }
    
    return usrInfo;
}

/**
 * 各能力状态变化事件
 * @param ability 能力类型，参见Ability常量定义
 * @param state 状态值，取值0、1，其中1--初始化完成且连接成功，0则是断开连接
 * @return
 */
- (void)onAbilityStateChange:(NSString *)ability state:(int)state
{
    NSLog(@"<onAbilityStateChange> - ability = %@ , state = %d", ability, state);
    
    if ([ability isEqualToString:AbilityAgent]) {
        BOOL status = [[QZUCC getInstance] getAbilityState:AbilityAgent];
        NSLog(@"AbilityAgent state = %d", status);
    }
}

/**
 * 指定sender_id订阅来自其所发送的消息，当有指定Id后，sdk接收该sender_id的消息后执行<onRecvMessageFromSubscribeSenderIds:>回调方法
 * 其中sender_id的取值范围：
 * --   1.普通用户，则直接填写qz_id;
 * --   2.后台服务中消息中转代理模块的特定用户，则由后台开发人员指定;
 * 若返回 @[MessageInChatRecvRangeAll], 则订阅所有普通聊天, 但不涉及群聊天;其中MessageInChatRecvRangeAll为常量；
 */
- (NSArray *)subscribeMessageFromSenderIds
{
    //1.普通用户，如：200000110004
    //2.特定用户，如：hs
    //return @[@"200000110004",@"hs"];
    
    //3.订阅所有用户
    return @[MessageInChatRecvRangeAll];
}

/*
 * 接收subscribeMessageFromSenderIds中指定sender_id发来的消息
 * @param msgInfo 消息对象
 */
- (void)onRecvMessageFromSubscribeSenderIds:(QMessageRecvInfo *)msgInfo
{
    NSLog(@"<onRecvMessageFromSubscribeSenderIds> - senderId = %@, content = %@", msgInfo.senderId, msgInfo.content);
}

/**
 * 当前用户被强制踢出
 */
- (void)onUserForcedToQuit
{
     NSLog(@"<onUserForcedToQuit> - 用户被踢出");
    [self.tableCtrl onUserForcedToQuit];
}


@end
