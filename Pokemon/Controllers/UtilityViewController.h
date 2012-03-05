//
//  UtilityViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SettingViewController.h"

@protocol UtilityViewControllerDelegate

- (void)actionForButtonLocateMe;
- (void)actionForButtonShowWorld;

@end


@interface UtilityViewController : UIViewController <AccountSettingViewControllerDelegate>
{
  id <UtilityViewControllerDelegate> delegate_;
  
  UIButton * buttonLocateMe_;
  UIButton * buttonShowWorld_;
  UIButton * buttonDiscover_;
  UIButton * buttonSetAccount_;
  
  SettingViewController * accountSettingViewController_;
}

@property (nonatomic, assign) id <UtilityViewControllerDelegate> delegate;

@property (nonatomic, retain) UIButton * buttonLocateMe;
@property (nonatomic, retain) UIButton * buttonShowWorld;
@property (nonatomic, retain) UIButton * buttonDiscover;
@property (nonatomic, retain) UIButton * buttonSetAccount;

@property (nonatomic, retain) SettingViewController * accountSettingViewController;

@end
