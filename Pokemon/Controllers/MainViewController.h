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
@class GameMainViewController;

@interface MainViewController : UIViewController
{
  UIButton * centerMainButton_;
  UIButton * mapButton_;
  
  UtilityViewController * utilityViewController_;
  PoketchTabViewController * poketchViewController_;
  GameMainViewController * gameMainViewController_;
}

@property (nonatomic, retain) UIButton * centerMainButton;
@property (nonatomic, retain) UIButton * mapButton;

@property (nonatomic, retain) UtilityViewController * utilityViewController;
@property (nonatomic, retain) PoketchTabViewController * poketchViewController;
@property (nonatomic, retain) GameMainViewController * gameMainViewController;

@end
