//
//  CustomNavigationViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomNavigationBar.h"

@interface CustomNavigationController : UINavigationController <
  CustomNavigationBarDelegate,
  CustomNavigationBarDataSource
>

// Overwrited |UINavigationController| Methods
- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated;

@end
