//
//  Activity.m
//  DBTest
//
//  Created by JC7 on 1/29/14.
//  Copyright (c) 2014 JC7. All rights reserved.
//

#import "Activity.h"

@implementation Activity


- (id)init
{
    return [self initWithUID:-1 CategoryID:-1 duration:0 startDate:@"NULL" startTime:@"NULL" endDate:@"NULL" endTime:@"NULL" details:@"NULL"];
}



-(id)initWithCategoryID:(NSInteger)cat_id
               duration:(NSInteger)duration
              startDate:(NSString *)start_d
              startTime:(NSString *)start_t
                endDate:(NSString *)end_d
                endTime:(NSString *)end_t
                details:(NSString *)det {
    
    return [self initWithUID:-1 CategoryID:cat_id duration:duration startDate:start_d startTime:start_t endDate:end_d endTime:end_t details:det];
}


-(id)initWithUID:(NSInteger)u_id CategoryID:(NSInteger)cat_id duration:(NSInteger)duration startDate:(NSString *)start_d startTime:(NSString *)start_t endDate:(NSString *)end_d endTime:(NSString *)end_t details:(NSString *)det {
    
    self = [super init];
    
    if (self) {
        self.uid = u_id;
        self.category_id = cat_id;
        self.duration = duration;
        self.category_str = [self categoryStringFrom:cat_id];
        self.start_date = start_d;
        self.start_time = start_t;
        self.end_date = end_d;
        self.end_time = end_t;
        self.details = det;
    }
    
    return self;

    
}


+ (NSArray *)catStrings
{
    static NSArray *_catStrings;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _catStrings = @[@"Time Planning", @"New Habit", @"Input", @"Internalizing", @"Output", @"Health", @"Sleep", @"Hobbies", @"Spouse", @"Kids", @"Relatives", @"Home Finance", @"Work Learning", @"Core Work", @"Future Work", @"Core Relationships", @"New Relationship", @"Relationship Planning", @"Worship", @"Serving", @"Misc."];
    });
    return _catStrings;
}

-(NSString *) categoryStringFrom:(NSInteger) cat_id{
    if (cat_id == -1) {
        return @"NULL";
    }
    return [[[self class] catStrings] objectAtIndex:cat_id];
}

-(NSString *)sqlString
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO activities('category_id', 'duration', 'category_str', 'start_date', 'start_time', 'end_date', 'end_time', 'details') VALUES ('%ld', '%ld', '%@', '%@', '%@', '%@', '%@', '%@')", (long) self.category_id, (long) self.duration, self.category_str, self.start_date, self.start_time, self.end_date, self.end_time, self.details];
    

    return sql;
}

-(NSString *)tableDescription
{
    return [NSString stringWithFormat:@"%@: %@ - %@", self.category_str, self.start_time, self.end_time];
}

-(BOOL)hasDetail
{
    return [self.details length] != 0;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"UID: %ld CatID: %ld CatStr: %@ SDST: %@ %@ EDET: %@ %@ Details: %@ Duration %ld", (long) self.uid, (long) self.category_id, self.category_str, self.start_date, self.start_time, self.end_date, self.end_time, self.details, (long) self.duration];
}

-(NSString *)friendlyDescription
{
    NSString *details = self.details;

    if ([self.details length] == 0) {
        details = @"none";
    }
    
    return [NSString stringWithFormat:@"Entry #%ld; Category: %@; Start Date: %@; Start Time: %@; End Date: %@; End Time: %@; Details: %@;", (long)self.uid, self.category_str, self.start_date, self.start_time, self.end_date, self.end_time, details];
}

@end
