//
//  RecordViewController.m
//  Kairosive Demo
//
//  Created by JC7 on 1/26/14.
//  Copyright (c) 2014 JC7. All rights reserved.
//

#import "RecordViewController.h"
#import "DCKakaoActivity.h"

@interface RecordViewController (){
    NSDate *start;
    NSTimeInterval startTime;
    __weak IBOutlet UILabel *startTimeLabel;
    __weak IBOutlet UILabel *secsLabel;
    __weak IBOutlet UILabel *minsLabel;
    __weak IBOutlet UILabel *hoursLabel;
    __weak IBOutlet UITextField *detailsField;
    __weak IBOutlet UILabel *description;
    
    NSString *startDate;
    NSString *startTimeStr;
    
    BOOL minsChanged;
    BOOL hoursChanged;
    
    
    BOOL recorded;
    NSInteger activityUID;
    
}

@end

@implementation RecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)dismiss:(id)sender {
    
    if (recorded) {
        [JCDBHandler deleteByUID:activityUID];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
- (IBAction)shareActivity:(id)sender {
    NSString *shareString = [NSString stringWithFormat:@"%@: %@: [%@] %@", startDate, [startTimeLabel text], _categoryStr, [detailsField text]];
    
    DCKakaoActivity *kakao = [[DCKakaoActivity alloc] init];
    
    
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:@[shareString, [NSURL URLWithString:@""]]
                                                        applicationActivities:@[kakao]];
    
    
    //    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:activityViewController animated:YES completion:nil];

}
- (IBAction)finish:(id)sender {
    
    [self saveActivity];
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)saveActivity {
    
    if (recorded) {
        [JCDBHandler deleteByUID:activityUID];
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    NSDate *now = [[NSDate alloc] init];
    [format setDateFormat:@"MM/dd/yyyy"];
    NSString *endDate = [format stringFromDate:now];
    
    [format setDateFormat:@"h:mm:ss a"];
    NSString *endTime = [format stringFromDate:now];
    
    int duration = ceil([now timeIntervalSinceDate:start]);
    
    Activity *act = [[Activity alloc] initWithCategoryID:_categoryId duration:duration startDate:startDate startTime:startTimeStr endDate:endDate endTime:endTime details:[detailsField text]];
    
    recorded = YES;
    activityUID = [JCDBHandler addActivity:act];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {

    [textField resignFirstResponder];
    
    return YES;
}

- (void)saveData{
    [self saveActivity];
}

- (void)reloadData{

}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveData) name:@"enteredBackground" object:nil];

      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"enteredForeground" object:nil];
    
    [JCDBHandler readTableWithSQLString:@"SELECT * FROM activities"];
    [description setText:_categoryStr];
    
    startTime = [NSDate timeIntervalSinceReferenceDate];
    minsChanged = NO;
    hoursChanged = NO;
    recorded = NO;
    activityUID = -1;
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"h:mm:ss a"];
    start = [[NSDate alloc] init];
    startTimeStr = [format stringFromDate:start];
    
    [format setDateFormat:@"MM/dd/yyyy"];
    startDate = [format stringFromDate:start];

    [format setDateFormat:@"h:mm a"];
    NSString * startTimeMins = [format stringFromDate:start];

    
    
    [startTimeLabel setText:startTimeMins];
    [self updateTime];
}


- (void) updateTime
{
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsed = currentTime - startTime;
    
    int hours = (int) (elapsed/3600);
    elapsed -= hours * 3600;
    
    int mins = (int) (elapsed/60);
    elapsed -= mins * 60;
    
    int secs = (int) elapsed;
    
    
    NSString *hoursText = [NSString stringWithFormat:@"%02u:", hours];
    NSString *minsText = [NSString stringWithFormat:@"%02u:", mins];
    NSString *secsText = [NSString stringWithFormat:@"%02u", secs];
    
    if (mins == 1 && !minsChanged) {
        minsChanged = YES;
        [minsLabel setTextColor:[UIColor whiteColor]];
    }
    
    if (hours == 1 && !hoursChanged) {
        hoursChanged = YES;
        [hoursLabel setTextColor:[UIColor whiteColor]];
    }
    
    [hoursLabel setText:hoursText];
    [minsLabel setText:minsText];
    [secsLabel setText:secsText];
    
    [self performSelector:@selector(updateTime) withObject:self afterDelay:1.0];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
