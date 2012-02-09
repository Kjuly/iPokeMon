//
//  CustomNavigationViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavigationController : UINavigationController
{
  UIImage * navigationBarBackgroundImage_;
}

@property (nonatomic, retain) UIImage * navigationBarBackgroundImage;

+ (id)initWithRootViewController:(UIViewController *)rootViewController
    navigationBarBackgroundImage:(UIImage *)navigationBarBackgroundImage;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
