//
//  UtilityViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UtilityBallMenuViewController;

@interface UtilityViewController : UIViewController
{
  UIView * utilityBar_;
  UIButton * buttonLocateMe_;
  UIButton * buttonShowWorld_;
  UIButton * buttonDiscover_;
  UIButton * buttonSetAccount_;
  
  UIButton * buttonOpenBallMenu_;
  UtilityBallMenuViewController * utilityBallMenuViewController_;
}

@property (nonatomic, retain) UIView * utilityBar;
@property (nonatomic, retain) UIButton * buttonLocateMe;
@property (nonatomic, retain) UIButton * buttonShowWorld;
@property (nonatomic, retain) UIButton * buttonDiscover;
@property (nonatomic, retain) UIButton * buttonSetAccount;

@property (nonatomic, retain) UIButton * buttonOpenBallMenu;
@property (nonatomic, retain) UtilityBallMenuViewController * utilityBallMenuViewController;

// Button Action
- (void)openBallMenuView:(id)sender;

@end
