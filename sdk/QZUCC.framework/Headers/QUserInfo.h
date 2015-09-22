//
//  QUserInfo.h
//  SDk
//
//  Created by tang.johannes on 15/2/6.
//  Copyright (c) 2015年 tang.johannes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QUserInfo : NSObject

@property(nonatomic, retain) NSString *qzId; //青芝Id
@property(nonatomic, retain) NSString *name; //名称
@property(nonatomic, retain) NSString *profileUrl; //头像url，其中图片：格式png,规格50*50

@end
