//
//  JJMessageModel.h
//  Demo
//
//  Created by Eric on 16/8/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JJMessageModel : NSObject


@property (nonatomic, strong) NSArray *ID;

/**
 *  内容
 */
@property (nonatomic, copy) NSString *content;

/**
 *  用户名
 */
@property (nonatomic, copy) NSString *userName;

/**
 *  图片
 */
@property (nonatomic, strong) NSArray *imageArray;

/**
 *  Cell 的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
