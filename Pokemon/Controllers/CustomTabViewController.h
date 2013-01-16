//
//  PoketchViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomTabBar.h"

@interface CustomTabViewController : UIViewController <CustomTabBarDelegate> {
  NSArray * tabBarItems_;
  CGRect    viewFrame_;
}

@property (nonatomic, copy)   NSArray * tabBarItems;
@property (nonatomic, assign) CGRect    viewFrame;

- (void)toggleTabBar:(NSNotification *)notification;

@end
