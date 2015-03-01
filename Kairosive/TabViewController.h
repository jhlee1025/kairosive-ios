//
//  TabViewController.h
//  Kairosive Demo
//
//  Created by JC7 on 2/1/14.
//  Copyright (c) 2014 JC7. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabViewController : UITabBarController
- (void)navigationController:(UINavigationController *)navigationController;
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end
