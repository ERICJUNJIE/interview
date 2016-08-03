//
//  JJMessageTools.h
//  Demo
//
//  Created by Eric on 16/8/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJMessageTools : NSObject

+ (instancetype)shareMessageTools;

/**
 *  将数据插入本地数据库
 *
 *  @param content  内容
 *  @param imageArray 图片
 *  @param username 用户名
 */
- (BOOL)insertMessageWithContent:(NSString *)content imageArray:(NSArray *)imageArray username:(NSString *)username;

/**
 *  加载失败
 *
 *  @return 
 */
- (NSArray *)loadMessage;

@end
