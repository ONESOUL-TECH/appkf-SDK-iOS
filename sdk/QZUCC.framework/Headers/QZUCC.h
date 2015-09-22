//
//  QZKit.h
//  SDk
//
//  Created by tang.johannes on 15/1/23.
//  Copyright (c) 2015年 tang.johannes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class QCallViewController;

#import "QUserInfo.h"
#import "QMessageRecvInfo.h"
#import "QZUCCDelegate.h"

extern NSString * const ErrorDomainQZUCCSDK;

extern NSString * const AbilityIM;
extern NSString * const AbilityPhone;
extern NSString * const AbilityAgent;

@interface QZUCC : NSObject

#pragma mark - init

/**
 * 获取QZUCC实例对象
 */
+ (id)getInstance;

/**
 * 查询各能力状态
 * @param abilityOption 能力值组合，json组数形式字符串，如：[AbilityIM, AbilityPhone, AbilityAgent]
 * @param delete 回调delegate
 * @return
 */
+ (void)initWithAbility:(NSString *)abilityOption delegate:(id<QZUCCDelegate>)theDelegate;

/**
 * 权限校验，连接各能力模块
 * @param ucmUrl ucm主服务地址
 * @param qzId   用户Id
 * @param authToken  用户Id相关的校验token
 * @param completion  连接权限校验成功回调该block
 * @param fail 连接权限校验失败回调该block
 * @return 
 */
- (void)connectWithUCMUrl:(NSString *)ucmUrl qzId:(NSString *)qzId authToken:(NSString *)authToken completion:(void (^)(void))completion fail:(void (^)(NSError *error))fail;

/**
 * 断开连接以及清理相关资源
 */
- (void)disconnect;

/**
 * 查询各能力状态
 * @param ability 能力值，取值参见ability常量
 * @return int 状态值，取值0、1，其中1--初始化完成且连接成功，0则是断开连接
 */
- (int)getAbilityState:(NSString *)ability;

/**
 * 查询是否已正常登录
 * @return isLogged 取值：true - 正常登录
 */
@property(nonatomic, readonly, getter=isLogged) BOOL logged;

#pragma mark - Notification

/**
 * 设置唤醒所需的device token
 * @param devToken
 * @param completion  连接权限校验成功回调该block
 * @param fail 连接权限校验失败回调该block
 * @return
 */
- (void)setDeviceToken:(NSString *)devToken completion:(void (^)(void))completion fail:(void (^)(NSError *error))fail;

/**
 * 解析Apns唤醒内容
 * 应用在-application:didReceiveRemoteNotification:系统回调方法内
 * @param userInfo
 * @return int 是否是QZUCC内容，若返回YES则是QZUCC内容，反之则不是，则需要第三方应用自身做后续解析；
 */
- (BOOL)parseReceiveRemoteNotification:(NSDictionary *)userInfo;

/**
 * 解析本地通知内容
 * 应用在-application:didReceiveLocalNotification:系统回调方法内
 * @param userInfo
 * @return int 是否是QZUCC内容，若返回YES则是QZUCC内容，反之则不是，则需要第三方应用自身做后续解析；
 */
- (BOOL)parseReceiveLocalNotification:(NSDictionary *)userInfo;

#pragma mark - 消息

//进入聊天窗口
- (void)pushChatFromViewController:(UIViewController *)viewController target:(QUserInfo *)targetQUsrInfo;
- (void)presentChatFromViewController:(UIViewController *)viewController target:(QUserInfo *)targetQUsrInfo completion:(void(^)(void))completion;

/**
 * 发送普通文本消息
 * @param targetId 接收者Id
 *        -- 取值范围：
 *        --   1.普通用户，则直接填写qz_id;
 *        --   2.后台服务中消息中转代理模块的特定用户，则由后台开发人员指定;
 * @param content 消息内容
 *		  -- 其中特殊用户使用场景时，可用于传递自定义数据格式内容
 * @param xElementXml 扩展xml元素内容
 *        -- 该部分可未nil或xml。若xml则必须是well-form的，建议使用x，并设置相应的名空间
 *        -- 例如：<x xmlns="hundsun.cc">{'a':'bbb', 'b':'ccc"}</x>
 * @param completion
 * @param fail
 */
- (void)sendTextMessage:(NSString *)targetId content:(NSString *)content xElementXml:(NSString *)xElementXml completion:(void(^)(void))completion fail:(void (^)(NSError *error))fail;


@end
