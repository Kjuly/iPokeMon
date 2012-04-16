//
//  UtilityBallMenuViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GlobalConstants.h"

@interface AbstractCenterMenuViewController : UIViewController {
  UIView * centerMenu_;
}

@property (nonatomic, retain) UIView * centerMenu;

- (void)releaseSubviews;
- (id)initWithButtonCount:(NSInteger)buttonCount;
- (void)runButtonActions:(id)sender;
- (void)pushViewController:(id)viewController;
- (void)checkDeviceSystemFor:(id)viewController;
- (void)openCenterMenuView;
- (void)changeCenterMainButtonStatusToMove:(CenterMainButtonStatus)centerMainButtonStatus;

@end
