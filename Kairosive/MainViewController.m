//
//  MainViewController.m
//  Kairosive Demo
//
//  Created by JC7 on 1/26/14.
//  Copyright (c) 2014 JC7. All rights reserved.
//

#import "MainViewController.h"
#import "DCKakaoActivity.h"
@interface MainViewController () {
    NSArray *activityIcons;
    NSArray *activityTitles;
}
@end

@implementation MainViewController
- (IBAction)exportDatabase:(id)sender {

    NSString *exportString = @"";
    [JCDBHandler readTableWithSQLString:@"SELECT * FROM activities"];
    for (Activity *act in [JCDBHandler entries]) {
        NSString *actString = [NSString stringWithFormat:@"%@\n\n", [act friendlyDescription]];
        exportString = [exportString stringByAppendingString:actString];
    }
    
    
    DCKakaoActivity *kakao = [[DCKakaoActivity alloc] init];

    
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                            initWithActivityItems:@[exportString, [NSURL URLWithString:@""]]
                                            applicationActivities:@[kakao]];
    
  
//    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    activityIcons = [NSArray arrayWithObjects:@"icon01", @"icon02",@"icon03", @"icon04",@"icon05",@"icon06",@"icon07",@"icon08",@"icon09",@"icon10",@"icon11",@"icon12",@"icon13",@"icon14",@"icon15",@"icon16",@"icon17",@"icon18",@"icon19",@"icon20",@"icon21",nil];


    
    activityTitles = [NSArray arrayWithObjects:@"Time Planning", @"New Habit", @"Input", @"Internalizing", @"Output", @"Health", @"Sleep", @"Hobbies", @"Spouse", @"Kids", @"Relatives", @"Home Finance", @"Work Learning", @"Core Work", @"Future Work", @"Core Relationships", @"New Relationships", @"Relationship Planning", @"Worship", @"Serving", @"Misc", nil];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [activityIcons count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIImageView *iconImageView = (UIImageView *)[cell viewWithTag:100];
    iconImageView.image = [UIImage imageNamed:[activityIcons objectAtIndex:indexPath.row]];

    return cell;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"showRecordView"]) {
        RecordViewController *rvc = [segue destinationViewController];
        NSArray *array = [self.collectionView indexPathsForSelectedItems];
        NSIndexPath *ip = array[0];
        
        NSString *string = [NSString stringWithFormat:@"%@", activityTitles[ip.row]];
        [rvc setCategoryStr:string];
        [rvc setCategoryId:ip.row];
        
    } else if ([[segue identifier] isEqualToString:@"showHistoryView"]) {
        NSDate *date = [[NSDate alloc] init];
        JCAppDelegate *delegate = (JCAppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.date = date;

        [JCDBHandler readTableUsingDate:date];
    }

}

@end
