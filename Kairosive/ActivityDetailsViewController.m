//
//  ActivityDetailsViewController.m
//  Kairosive Demo
//
//  Created by JC7 on 1/31/14.
//  Copyright (c) 2014 JC7. All rights reserved.
//

#import "ActivityDetailsViewController.h"

@interface ActivityDetailsViewController (){
    Activity *currentActivity;
    __weak IBOutlet UILabel *categoryLabel;
    __weak IBOutlet UILabel *startDateLabel;
    __weak IBOutlet UILabel *startTimeLabel;
    __weak IBOutlet UILabel *endDateLabel;
    __weak IBOutlet UILabel *endTimeLabel;
    __weak IBOutlet UILabel *detailsLabel;
}
@property (weak, nonatomic) IBOutlet UILabel *detailedLabel;

@end

@implementation ActivityDetailsViewController

-(void)setCurrentActivity:(id)act
{
    currentActivity = act;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    categoryLabel.text = currentActivity.category_str;
    startDateLabel.text = currentActivity.start_date;
    startTimeLabel.text = currentActivity.start_time;
    endDateLabel.text = currentActivity.end_date;
    endTimeLabel.text = currentActivity.end_time;
    if ([currentActivity hasDetail]) {
        detailsLabel.text = currentActivity.details;
    } else {
        detailsLabel.text = @"none";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
