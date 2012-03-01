//
//  UtilityBallMenuViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbstractCenterMenuViewController : UIViewController
{
  UIView * ballMenu_;
}

@property (nonatomic, retain) UIView * ballMenu;

- (id)initWithButtonCount:(NSInteger)buttonCount;
- (void)runButtonActions:(id)sender;
- (void)pushViewController:(id)viewController;
- (void)checkDeviceSystemFor:(id)viewController;
- (void)recoverButtonsLayoutInCenterView;

@end
