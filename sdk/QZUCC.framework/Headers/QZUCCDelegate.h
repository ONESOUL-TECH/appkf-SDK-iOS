//
//  QZKitDelegate.h
//  SDk
//
//  Created by tang.johannes on 15/1/23.
//  Copyright (c) 2015年 tang.johannes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class QUserInfo;
@class QAgentInfo;
@class QMessageRecvInfo;

typedef enum {
    ParamTypePhoneNumber, /**< 电话号码  */
    ParamTypeQZId         /**< 用户Id  */
} ParamType;

extern NSString * const AbilityIM;
extern NSString * const AbilityPhone;
extern NSString * const AbilityAgent;

extern NSString * const QAgentEventServiceStart;//客户分配给坐席，坐席开始振铃
extern NSString * const QAgentEventServicePickup;//客户分配给坐席，坐席摘机
extern NSString * const QAgentEventServiceEnd;//坐席服务结束
extern NSString * const QAgentEventServiceComplete;//坐席服务完成

extern NSString * const MessageInChatRecvRangeAll; //普通聊天消息范围涉及所有sender-id，不涉及群聊范围

@protocol QZUCCDelegate <NSObject>

@required

/**
 * 查询用户
 * @param paramString 参数字符串
 * @param type 参数类型，详见ParamType
 * @return 查询成功返回QUserInfo对象,否则返回nil
 */
- (QUserInfo *)getQUserInfo:(NSString *)paramString type:(ParamType)type;

/**
 * 各能力状态变化事件
 * @param ability 能力类型，参见Ability常量定义
 * @param state 状态值，取值0、1，其中1--初始化完成且连接成功，0则是断开连接
 * @return
 */
- (void)onAbilityStateChange:(NSString *)ability state:(int)state;

/**
 * 指定sender_id订阅来自其所发送的消息，当有指定Id后，sdk接收该sender_id的消息后执行<onRecvMessageFromSubscribeSenderIds:>回调方法
 * 其中sender_id的取值范围：
 * --   1.普通用户，则直接填写qz_id;
 * --   2.后台服务中消息中转代理模块的特定用户，则由后台开发人员指定;
 * 若返回 @[MessageInChatRecvRangeAll], 则订阅所有普通聊天, 但不涉及群聊天;其中MessageInChatRecvRangeAll为常量；
 */
- (NSArray *)subscribeMessageFromSenderIds;

/*
 * 接收subscribeMessageFromSenderIds中指定sender_id发来的消息
 * @param msgInfo 消息对象
 */
- (void)onRecvMessageFromSubscribeSenderIds:(QMessageRecvInfo *)msgInfo;


/**
 * 当前用户被强制踢出
 */
- (void)onUserForcedToQuit;

@end
