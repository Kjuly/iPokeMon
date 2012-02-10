//
//  PoketchViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomTabBar.h"

@interface CustomTabViewController : UIViewController <CustomTabBarDelegate>
{
  CustomTabBar * tabBar_;
  NSArray      * tabBarItems_;
  
  CGFloat viewHeight_;
  CGFloat viewWidth_;
}

@property (nonatomic, retain) CustomTabBar * tabBar;
@property (nonatomic, copy) NSArray        * tabBarItems;

@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat viewWidth;

@end
