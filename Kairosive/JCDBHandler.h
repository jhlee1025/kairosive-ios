//
//  JCDBHandler.h
//  Kairosive Demo
//
//  Created by JC7 on 1/30/14.
//  Copyright (c) 2014 JC7. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Activity.h"
#import "JCAppDelegate.h"

@interface JCDBHandler : NSObject


+ (NSString *)filePath;
+ (NSMutableArray *)entries;
+ (void)openDB;
+ (void)deleteByUID:(NSInteger)uid;
+ (void)readTable;
+ (void)readTableUsingDate:(NSDate *) date;
+ (void)readTableWithSQLString:(NSString *) sql;
+ (NSInteger)addActivity:(Activity *)act;
+ (void)createTable:(NSString *)tableName
         withField1:(NSString *)field1
         withField2:(NSString *)field2
         withField3:(NSString *)field3
         withField4:(NSString *)field4
         withField5:(NSString *)field5
         withField6:(NSString *)field6
         withField7:(NSString *)field7
         withField8:(NSString *)field8
         withField9:(NSString *)field9;

@end
