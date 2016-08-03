//
//  JJSQLiteManager.h
//  Demo
//
//  Created by Eric on 16/8/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJSQLiteManager : NSObject

+ (instancetype)shareIntance;

- (BOOL)openDB;

- (BOOL)execSQL:(NSString *)sql;

- (NSArray *)querySQL:(NSString *)querySQL;

@end
