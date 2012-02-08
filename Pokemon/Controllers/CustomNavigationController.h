//
//  CustomNavigationViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomNavigationControllerDelegate <UINavigationControllerDelegate>

- (BOOL)hasNavigationBar;
- (UIImage *)navigationBarBackgroundImage;

@end

@interface CustomNavigationController : UINavigationController
{
  id <CustomNavigationControllerDelegate> delegate_;
}

@property (nonatomic, assign) id <CustomNavigationControllerDelegate> delegate;

+ (id)initWithNibAndRootViewController:(UIViewController *)rootViewController;

@end
