//
//  Activity.h
//  DBTest
//
//  Created by JC7 on 1/29/14.
//  Copyright (c) 2014 JC7. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject

@property NSInteger uid;
@property NSInteger category_id;
@property NSInteger duration;
@property NSString *category_str;
@property NSString *start_date;
@property NSString *start_time;
@property NSString *end_date;
@property NSString *end_time;
@property NSString *details;

-(NSString *) tableDescription;

-(BOOL) hasDetail;

-(id) initWithCategoryID: (NSInteger) cat_id
                duration:(NSInteger) duration
               startDate:(NSString*) start_d
               startTime:(NSString*) start_t
                 endDate:(NSString*) end_d
                 endTime:(NSString*) end_t
                 details:(NSString*) det;

-(id) initWithUID:(NSInteger)u_id
       CategoryID: (NSInteger) cat_id
         duration:(NSInteger) duration
        startDate:(NSString*) start_d
        startTime:(NSString*) start_t
          endDate:(NSString*) end_d
          endTime:(NSString*) end_t
          details:(NSString*) det;

-(NSString *) sqlString;
-(NSString *)friendlyDescription;

@end
