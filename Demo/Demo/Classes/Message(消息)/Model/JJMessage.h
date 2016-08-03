//
//  JJMessage.h
//  Demo
//
//  Created by Eric on 16/8/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWPhoto.h"


@interface JJMessage : NSObject

/**
 *  内容
 */
@property (nonatomic, copy) NSString *content;

/**
 *  图片
 */
@property (nonatomic, strong) NSMutableArray *imageArray;

/**
 *  将图片转换为photo
 */
@property (nonatomic, strong, readonly) NSArray *photoArray;

@end
