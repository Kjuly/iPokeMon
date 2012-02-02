//
//  MainViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapViewController;
@class UtilityViewController;
@class PoketchTabViewController;
@class CustomNavigationController;

@interface MainViewController : UIViewController
{
  MapViewController * mapViewController_;
  UtilityViewController * utilityViewController_;
  PoketchTabViewController * poketchViewController_;
  
  UIButton * buttonOpenBallMenu_;
  CustomNavigationController * utilityNavigationController_;
}

@property (nonatomic, retain) MapViewController * mapViewController;
@property (nonatomic, retain) UtilityViewController * utilityViewController;
@property (nonatomic, retain) PoketchTabViewController * poketchViewController;

@property (nonatomic, retain) UIButton * buttonOpenBallMenu;
@property (nonatomic, retain) CustomNavigationController * utilityNavigationController;

// Button Action
- (void)openBallMenuView:(id)sender;

@end
