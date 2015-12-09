//
//  ViewController.m
//  SQLite
//
//  Created by 陈高健 on 15/12/9.
//  Copyright © 2015年 陈高健. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>

@interface ViewController ()
@property (nonatomic,assign)sqlite3 *db;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //连接数据库
    [self connectionDB];
}

//连接数据库
- (void)connectionDB{
    NSLog(@"%@",NSHomeDirectory());
    //获取路径
    NSString *path=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"data.sqlite"];
    //判断数据库是否打开成功
    int success=sqlite3_open(path.UTF8String, &_db);
    //如果数据库打开成功
    if (success==SQLITE_OK) {
        //创建表SQL语句,并且设置ID为主键,且自动增长
        NSString *sql=@"CREATE TABLE IF NOT EXISTS t_test (ID INTEGER PRIMARY KEY AUTOINCREMENT,NAME TEXT,AGE INTEGER)";
        //判断创建表是否成功
        int success_t=sqlite3_exec(_db, sql.UTF8String, NULL, NULL, NULL);
        //如果创建表成功
        if (success_t==SQLITE_OK) {
            NSLog(@"创建表成功!");
        }else{
            NSLog(@"创建表失败");
        }
    }else{
        NSLog(@"数据库创建失败");
    }
    //关闭数据库
    //sqlite3_close(_db);
}

//增加数据
- (IBAction)addClick:(id)sender {
    
    //往表中循环插入100条数据
    for (int i = 0; i < 100 ; i++) {
        //名称设置为J_mailbox
        NSString *name = [NSString stringWithFormat:@"J_mailbox-%d",i];
        //随机生成20岁~25岁之间的记录
        NSInteger age = arc4random_uniform(5) + 20;
        
        //sql插入语句的拼接
        NSString *resultStr = [NSString stringWithFormat:@"INSERT INTO t_test (NAME,AGE) VALUES('%@',%zd) ",name,age];
        //执行sql插入语句
        int success =  sqlite3_exec(_db, resultStr.UTF8String, NULL, NULL, NULL);
        //判断是否插入成功
        if (success == SQLITE_OK) {
            NSLog(@"添加数据成功!");
        }else{
            NSLog(@"添加数据失败!");
        }
        
    }

}

//删除数据
- (IBAction)deleteClick:(id)sender {
    
    //sql删除语句
    NSString *sqlStr = @"DELETE FROM t_test WHERE AGE > 22 ;";
    //执行删除语句操作
    int success =  sqlite3_exec(_db, sqlStr.UTF8String, NULL, NULL, NULL);
    
    if (success == SQLITE_OK) {
        NSLog(@"删除数据成功!");
    }else{
        NSLog(@"删除数据失败!");
    }

}

//修改数据数据
- (IBAction)updateClick:(id)sender {
    
    //sql修改语句
    NSString *sqlStr = @"UPDATE t_test SET AGE = 30 WHERE AGE <25;";
    //执行修改语句操作
    int success =  sqlite3_exec(_db, sqlStr.UTF8String, NULL, NULL, NULL);
    
    if (success == SQLITE_OK) {
        NSLog(@"修改数据成功!");
    }else{
        NSLog(@"修改数据失败!");
    }
}

//查询数据
- (IBAction)selectClick:(id)sender {
    
    //sql查询语句
    NSString *sqlStr = @"SELECT NAME,AGE FROM t_test WHERE AGE = 30;";
    //定义存放结果数据stmt
    sqlite3_stmt *stmt = NULL;
    //取一条记录
    int success = sqlite3_prepare_v2(_db, sqlStr.UTF8String,-1, &stmt, NULL);
    if (success == SQLITE_OK) {
        NSLog(@"查询数据成功!");
        //拿数据 step 一步 拿一条记录
        while (sqlite3_step(stmt) == SQLITE_ROW) { //证明取到了一条记录
            //查询到得NAME
            const char *name = (const char *)sqlite3_column_text(stmt, 0);
            //查询到得AGE
            int age = sqlite3_column_int(stmt, 1);
            //打印结果
            NSLog(@"NAME = %@ AGE = %d",[NSString stringWithUTF8String:name],age);
        }
        
    }else{
        NSLog(@"查询数据失败!");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
