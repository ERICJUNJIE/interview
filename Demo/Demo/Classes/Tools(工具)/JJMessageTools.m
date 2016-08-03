//
//  JJMessageTools.m
//  Demo
//
//  Created by Eric on 16/8/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "JJMessageTools.h"
#import "FMDB.h"
#import "JJSQLiteManager.h"
#import "JJMessageModel.h"

@implementation JJMessageTools

+ (instancetype)shareMessageTools {
    static JJMessageTools *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [[JJSQLiteManager shareIntance] openDB];
    });
    return instance;
}

- (BOOL)insertMessageWithContent:(NSString *)content imageArray:(NSArray *)imageArray username:(NSString *)username {
    NSMutableString *imageStr = @"".mutableCopy;
    for (NSURL *url in imageArray) {
        [imageStr appendString:url.absoluteString];
        [imageStr appendString:@"||"];
    }    
    // 1.封装插入的SQL语句
    //NSString *createTableSQL = @"CREATE TABLE IF NOT EXISTS 't_message' ( 'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'CONTENT' TEXT,'USERNAME' TEXT,'IMAGE' TEXT);";

    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO t_message (CONTENT, USERNAME, IMAGE) VALUES ('%@', '%@', '%@')", content, username,imageStr];
    // 2.执行SQL
    return [[JJSQLiteManager shareIntance] execSQL:insertSQL];
}

- (NSArray *)loadMessage {


    // 1.封装查询的语句
    NSString *querySQL = @"SELECT * FROM t_message;";
    
    // 2.执行查询语句
    NSArray *dictArray = [[JJSQLiteManager shareIntance] querySQL:querySQL];
    
    // 3.将字典数组转成模型对象数组
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dict in dictArray) {
        JJMessageModel *model = [[JJMessageModel alloc] init];
        model.userName = dict[@"USERNAME"];
        model.content = dict[@"CONTENT"];
        model.imageArray = [dict[@"IMAGE"] componentsSeparatedByString:@"||"];
        model.ID = dict[@"ID"];
        [tempArray addObject:model];
    }    
    return tempArray;
}

@end
