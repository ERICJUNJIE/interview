//
//  JJSQLiteManager.m
//  Demo
//
//  Created by Eric on 16/8/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "JJSQLiteManager.h"
#import <sqlite3.h>

@interface JJSQLiteManager ()

@property (nonatomic, assign) sqlite3 *db;

@end

@implementation JJSQLiteManager

static id _instance;

+ (instancetype)shareIntance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (BOOL)openDB
{
    // 数据库对象
    // sqlite3 *db = nil;
    
    // 数据库文件存放的路径
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    filePath = [filePath stringByAppendingPathComponent:@"demo.sqlite"];
    
    // 打开一个数据库文件:如果存在则直接打开,如果不存在,先创建在打开
    // 1> 参数一:文件路径+文件名字
    // 2> 参数二:数据库对象
    if (sqlite3_open(filePath.UTF8String, &_db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    
    // 创建表
    return [self createTable];
}

- (BOOL)createTable
{
    // 1.封装创建表的语句
    NSString *createTableSQL = @"CREATE TABLE IF NOT EXISTS 't_message' ( 'ID' INTEGER PRIMARY KEY AUTOINCREMENT,'CONTENT' TEXT,'USERNAME' TEXT,'IMAGE' TEXT);";
    
    // 2.执行sql语句
    return [self execSQL:createTableSQL];
}

- (BOOL)execSQL:(NSString *)sql
{
    // 1> 参数一:数据库对象
    // 2> 参数二:要执行的sql语句
    return sqlite3_exec(self.db, sql.UTF8String, nil, nil, nil) == SQLITE_OK;
}

- (NSArray *)querySQL:(NSString *)querySQL
{
    // 定义游标对象
    sqlite3_stmt *stmt = nil;
    
    // 准备查询
    // 1> 参数一:数据库对象
    // 2> 参数二:查询语句
    // 3> 参数三:查询语句的长度:-1
    // 4> 参数四:句柄(游标对象)
    if (sqlite3_prepare_v2(self.db, querySQL.UTF8String, -1, &stmt, nil) != SQLITE_OK) {
        NSLog(@"准备查询失败");
        return nil;
    };
    
    // 准备成功,开始查询数据
    NSMutableArray *dictArray = [NSMutableArray array];
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        // 获取一共多少列
        int count = sqlite3_column_count(stmt);
        
        // 定义字典
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (int i = 0; i < count; i++) {
            // 取出i位置列的字段名,作为字典的键
            const char *cKey = sqlite3_column_name(stmt, i);
            NSString *key = [NSString stringWithUTF8String:cKey];
            
            // 取出i位置的存储的值,作为字典的值
            const char *cValue = (const char *)sqlite3_column_text(stmt, i);
            NSString *value = [NSString stringWithUTF8String:cValue];
            
            // 将键值对一个一个放入字典中
            [dict setValue:value forKey:key];
        }
        
        // 将获取的字典放入数组中
        [dictArray addObject:dict];
    }
    
    // 返回取出所有数据的数组
    return dictArray.copy;
}


@end
