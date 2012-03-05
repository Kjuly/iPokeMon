//
//  AccountSettingViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/23/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingTableViewController;

@protocol AccountSettingViewControllerDelegate

- (void)cancelAccountSettingTableView;

@end

@interface SettingViewController : UIViewController
{
  id <AccountSettingViewControllerDelegate> delegate_;
  UIView * topBar_;
  SettingTableViewController * accountSettingTableViewController_;
}

@property (nonatomic, assign) id <AccountSettingViewControllerDelegate> delegate;
@property (nonatomic, retain) UIView * topBar;
@property (nonatomic, retain) SettingTableViewController * accountSettingTableViewController;

@end
