//
//  DateSelectViewController.m
//  Kairosive Demo
//
//  Created by JC7 on 1/31/14.
//  Copyright (c) 2014 JC7. All rights reserved.
//

#import "DateSelectViewController.h"
#import "JCAppDelegate.h"
@interface DateSelectViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@implementation DateSelectViewController

- (IBAction)dismiss:(id)sender {
    
    JCAppDelegate *delegate = (JCAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.date = _datePicker.date;
    [JCDBHandler readTable];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    JCAppDelegate *delegate = (JCAppDelegate *)[[UIApplication sharedApplication] delegate];
	[_datePicker setDate:delegate.date];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end