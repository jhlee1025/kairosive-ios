//
//  JCDBHandler.m
//  Kairosive Demo
//
//  Created by JC7 on 1/30/14.
//  Copyright (c) 2014 JC7. All rights reserved.
//

#import "JCDBHandler.h"

@implementation JCDBHandler
static NSString* dbName;
static sqlite3 *db;
static NSMutableArray *_entries;

static BOOL debug;

+(void)initialize {
    
    if (self == [JCDBHandler class]) {
        dbName = @"kairosive1111.sql";
        debug = NO;
        [self openDB];
        [self createTable:@"activities" withField1:@"uid" withField2:@"category_id" withField3:@"duration" withField4:@"category_str" withField5:@"start_date" withField6:@"start_time" withField7:@"end_date" withField8:@"end_time" withField9:@"details"];
        
        _entries = [[NSMutableArray alloc] init];
        
        
    }
}

+(NSMutableArray *) entries {
    return _entries;
}

+(NSString *) filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:dbName];
}


+(void)deleteByUID:(NSInteger)uid
{
    
    sqlite3_stmt *statement;
    
    if (sqlite3_open([[self filePath] UTF8String], &db) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"delete from activities where uid = '%ld'", (long)uid];
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_prepare_v2(db, query_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            if (debug) {
                NSLog(@"deleted record");
                
            }
            //return YES;
        } else {
            if (debug) {
                NSLog(@"Failed to delete record");
                
            }

            // return NO;
        }
        sqlite3_reset(statement);
    }
    
    [self readTable];
    
    
}

+ (void) readTable
{
    JCAppDelegate *delegate = (JCAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDate *date = delegate.date;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/yyyy"];
    NSString *dateString = [format stringFromDate:date];
    
    
	NSString *sql = [NSString stringWithFormat:@"SELECT * FROM activities where start_date = '%@'", dateString];
    [self readTableWithSQLString:sql];
    
}

+ (void) readTableUsingDate:(NSDate *)date
{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/yyyy"];
    NSString *dateString = [format stringFromDate:date];
    

	NSString *sql = [NSString stringWithFormat:@"SELECT * FROM activities where start_date = '%@'", dateString];
    [self readTableWithSQLString:sql];
}

+ (void) readTableWithSQLString:(NSString *) sql
{
    
    sqlite3_stmt *statement;
    _entries = [[NSMutableArray alloc] init];
    
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *field1 = (char *) sqlite3_column_text(statement, 0);
            NSString *uid = [[NSString alloc] initWithUTF8String:field1];
            
            char *field2 = (char *) sqlite3_column_text(statement, 1);
            NSString *catId = [[NSString alloc] initWithUTF8String:field2];
            
            char *field3 = (char *) sqlite3_column_text(statement, 2);
            NSString *duration = [[NSString alloc] initWithUTF8String:field3];
            
            //   char *field4 = (char *) sqlite3_column_text(statement, 3);
            //   NSString *catStr = [[NSString alloc] initWithUTF8String:field4];
            
            char *field5 = (char *) sqlite3_column_text(statement, 4);
            NSString *startDate = [[NSString alloc] initWithUTF8String:field5];
            
            char *field6 = (char *) sqlite3_column_text(statement, 5);
            NSString *startTime = [[NSString alloc] initWithUTF8String:field6];
            
            char *field7 = (char *) sqlite3_column_text(statement, 6);
            NSString *endDate = [[NSString alloc] initWithUTF8String:field7];
            
            char *field8 = (char *) sqlite3_column_text(statement, 7);
            NSString *endTime = [[NSString alloc] initWithUTF8String:field8];
            
            char *field9 = (char *) sqlite3_column_text(statement, 8);
            NSString *details = [[NSString alloc] initWithUTF8String:field9];
            
            
            
            Activity *act = [[Activity alloc] initWithUID:uid.integerValue CategoryID:catId.integerValue duration:duration.integerValue startDate:startDate startTime:startTime endDate:endDate endTime:endTime details:details];
            
            [_entries addObject:act];
            
        }
    }
    
}


+(void)openDB {
    if (sqlite3_open([[self filePath] UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"Database failed to open");
    } else {
        if (debug)
        NSLog(@"Database has opened!");
    }
}



+ (void)createTable:(NSString *)tableName
         withField1:(NSString *)field1
         withField2:(NSString *)field2
         withField3:(NSString *)field3
         withField4:(NSString *)field4
         withField5:(NSString *)field5
         withField6:(NSString *)field6
         withField7:(NSString *)field7
         withField8:(NSString *)field8
         withField9:(NSString *)field9


{
    
    
    
    char *err;
    NSString *sql = [NSString stringWithFormat:
                     @"CREATE TABLE IF NOT EXISTS '%@'('%@' INTEGER PRIMARY KEY, '%@' INTEGER, '%@' INTEGER, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);", tableName, field1, field2, field3, field4, field5, field6, field7, field8, field9];
    if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"Could not create table");
    } else {
        if (debug)
        NSLog(@"Table created");
    }
    
}

+(NSInteger)addActivity:(Activity *)act {
    
    NSString *sql = [act sqlString];
    
    char *err;
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"COULD NOT UPDATE TABLE");
    } else {
        if (debug)
        NSLog(@"Table updated");
    }
    
    [self readTable];
    
    Activity *lastAdded = [_entries objectAtIndex:[_entries count] - 1];
    return [lastAdded uid];
}


@end
