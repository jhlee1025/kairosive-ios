//
//  GraphViewController.m
//  Kairosive Demo
//
//  Created by JC7 on 2/1/14.
//  Copyright (c) 2014 JC7. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController ()
{
    NSMutableArray *_slices;
    NSArray *_sliceColors;
    
    
    NSMutableArray *personal;
    NSUInteger personalDuration;
    
    NSMutableArray *family;
    NSUInteger familyDuration;
    
    NSMutableArray *work;
    NSUInteger workDuration;
    
    NSMutableArray *social;
    NSUInteger socialDuration;
    
    NSMutableArray *faith;
    NSUInteger faithDuration;
    
    NSMutableArray *misc;
    NSUInteger miscDuration;
    __weak IBOutlet UISegmentedControl *segCtrl;
    
    IBOutlet UIScrollView *scrollView;
    //    __weak IBOutlet UIPageControl *pageControl;
    __weak IBOutlet UISwitch *miscToggle;
    __weak IBOutlet UILabel *percentageLabel;
}
@property (weak, nonatomic) IBOutlet XYPieChart *pieChart;
@end

@implementation GraphViewController

- (IBAction)miscSwitch:(id)sender {
    

    
    if (miscToggle.on){
        [self showPieChartMiscOn:YES segment:[segCtrl selectedSegmentIndex]];
    } else {
        [self showPieChartMiscOn:NO segment:[segCtrl selectedSegmentIndex]];
    }
    
    [self.pieChart reloadData];
    
}
- (IBAction)toggleSegCtrl:(id)sender {
    
    if ([segCtrl selectedSegmentIndex] == 0) {
        [percentageLabel setText:@"%"];
    } else if ([segCtrl selectedSegmentIndex] == 1) {
        [percentageLabel setText:@"S"];
    } else {
        [percentageLabel setText:@"#"];
    }
    
    if (miscToggle.on){
        [self showPieChartMiscOn:YES segment:[segCtrl selectedSegmentIndex]];
    } else {
        [self showPieChartMiscOn:NO segment:[segCtrl selectedSegmentIndex]];
    }
    
    [self.pieChart reloadData];
    
    
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
    [scrollView setContentSize:CGSizeMake(320, 1000)];
    if (miscToggle.on){
        [self showPieChartMiscOn:YES segment:[segCtrl selectedSegmentIndex]];
    } else {
        [self showPieChartMiscOn:NO segment:[segCtrl selectedSegmentIndex]];
    }
    
    [self.pieChart reloadData];
    
    
}

- (void)showPieChartMiscOn:(BOOL)miscOn segment:(NSInteger)segment
{
    _slices = [NSMutableArray arrayWithCapacity:6];
    
    NSMutableArray *all = [JCDBHandler entries];
    
    personal = [[NSMutableArray alloc] init];
    family = [[NSMutableArray alloc] init];
    work = [[NSMutableArray alloc] init];
    social = [[NSMutableArray alloc] init];
    faith = [[NSMutableArray alloc] init];
    misc = [[NSMutableArray alloc] init];
    
    personalDuration = 0;
    familyDuration = 0;
    workDuration = 0;
    socialDuration = 0;
    faithDuration = 0;
    
    for (Activity *act in all) {
        
        switch([act category_id]) {
            case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7:
                [personal addObject:act];
                personalDuration += [act duration];
                break;
            case 8: case 9: case 10: case 11:
                [family addObject:act];
                familyDuration += [act duration];
                break;
            case 12: case 13: case 14:
                [work addObject:act];
                workDuration += [act duration];
                break;
            case 15: case 16: case 17:
                [social addObject:act];
                socialDuration += [act duration];
                break;
            case 18: case 19:
                [faith addObject:act];
                faithDuration += [act duration];
                break;
            default:
                [misc addObject:act];
                break;
        }
    }
    
    
    miscDuration = 60 * 60 * 24 - (personalDuration + familyDuration + workDuration + socialDuration + faithDuration);
    
    if (segment == 2) {
        [_slices addObject:[NSNumber numberWithInteger:[personal count]]];
        [_slices addObject:[NSNumber numberWithInteger:[family count]]];
        [_slices addObject:[NSNumber numberWithInteger:[work count]]];
        [_slices addObject:[NSNumber numberWithInteger:[social count]]];
        [_slices addObject:[NSNumber numberWithInteger:[faith count]]];
        
        if (miscOn) {
            [_slices addObject:[NSNumber numberWithInteger:[misc count]]];
        }
        

    } else {
        
        [_slices addObject:[NSNumber numberWithInteger:personalDuration]];
        [_slices addObject:[NSNumber numberWithInteger:familyDuration]];
        [_slices addObject:[NSNumber numberWithInteger:workDuration]];
        [_slices addObject:[NSNumber numberWithInteger:socialDuration]];
        [_slices addObject:[NSNumber numberWithInteger:faithDuration]];
        
        if (miscOn) {
            [_slices addObject:[NSNumber numberWithInteger:miscDuration]];
        }
        
    }
  
    
    
    [percentageLabel.layer setCornerRadius:45];
    
    
    [self.pieChart setDataSource:self];
    [self.pieChart setStartPieAngle:M_PI_2];
    [self.pieChart setAnimationSpeed:1.0];
    [self.pieChart setLabelFont:[UIFont fontWithName:@"Helvetica" size:24]];
    [self.pieChart setLabelRadius:90];
    
    
    if (segment == 0){
        [self.pieChart setShowPercentage:YES];
    } else {
        [self.pieChart setShowPercentage:NO];
        
    }
    
    [self.pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [self.pieChart setPieCenter:CGPointMake(273/2, 239/2)];
    [self.pieChart setUserInteractionEnabled:YES];
    [self.pieChart setLabelShadowColor:[UIColor blackColor]];
    
    _sliceColors =[NSArray arrayWithObjects:
                   [UIColor colorWithRed:196/255.0 green:77/255.0 blue:88/255.0 alpha:1],
                   [UIColor colorWithRed:255/255.0 green:139/255.0 blue:107/255.0 alpha:1],
                   [UIColor colorWithRed:255/255.0 green:180/255.0 blue:29/255.0 alpha:1],
                   [UIColor colorWithRed:0/255.0 green:135/255.0 blue:206/255.0 alpha:1],
                   [UIColor colorWithRed:142/255.0 green:239/255.0 blue:54/255.0 alpha:1],
                   [UIColor colorWithRed:1/255.0 green:95/255.0 blue:138/255.0 alpha:1],
                   nil];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pieChart reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return _slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[_slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [_sliceColors objectAtIndex:(index % _sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
//    NSLog(@"will select slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
//    NSLog(@"will deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
//    NSLog(@"did deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
//    NSLog(@"did select slice at index %d",index);
    //    self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[_slices objectAtIndex:index]];
}


@end
