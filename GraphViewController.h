//
//  GraphViewController.h
//  Kairosive Demo
//
//  Created by JC7 on 2/1/14.
//  Copyright (c) 2014 JC7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "JCDBHandler.h"
#import "Activity.h"
@interface GraphViewController : UIViewController <XYPieChartDelegate, XYPieChartDataSource,  UIScrollViewDelegate>

@end
