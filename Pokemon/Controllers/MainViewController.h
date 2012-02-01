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
@class UtilityBallMenuViewController;

@interface MainViewController : UIViewController
{
  MapViewController * mapViewController_;
  UtilityViewController * utilityViewController_;
  PoketchTabViewController * poketchViewController_;
  
  UIButton * buttonOpenBallMenu_;
  UtilityBallMenuViewController * utilityBallMenuViewController_;
}

@property (nonatomic, retain) MapViewController * mapViewController;
@property (nonatomic, retain) UtilityViewController * utilityViewController;
@property (nonatomic, retain) PoketchTabViewController * poketchViewController;

@property (nonatomic, retain) UIButton * buttonOpenBallMenu;
@property (nonatomic, retain) UtilityBallMenuViewController * utilityBallMenuViewController;

// Button Action
- (void)openBallMenuView:(id)sender;

@end
