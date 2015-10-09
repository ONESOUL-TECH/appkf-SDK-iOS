//
//  QMessageRecvInfo.h
//  QZUCC
//
//  Created by tang.johannes on 15/3/20.
//  Copyright (c) 2015年 tang.johannes. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const MessageInChatRecvRangeAll; //所有sender-id，不涉及群聊范围，仅普通chat

@interface QMessageRecvInfo : NSObject

@property (nonatomic, copy) NSString *senderId;   //发送者Id
@property (nonatomic, copy) NSString *senderName; //发送者名称，若发送者不提供时为nil
@property (nonatomic, copy) NSString *content;    //消息内容
@property (nonatomic, copy) NSDate *sendTime;     //发送时间

@property (nonatomic, copy) NSString *contentOriginal;//原始内容，格式为xml

//TODO:多媒体消息等相关属性，待补充...

@end
