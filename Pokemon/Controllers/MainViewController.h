//
//  MainViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameMainViewController;

@interface MainViewController : UIViewController
{
  UIButton * centerMainButton_;
  UIButton * mapButton_;
  GameMainViewController * gameMainViewController_;
}

@property (nonatomic, retain) UIButton * centerMainButton;
@property (nonatomic, retain) UIButton * mapButton;
@property (nonatomic, retain) GameMainViewController * gameMainViewController;

@end
