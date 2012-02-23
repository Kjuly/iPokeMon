//
//  AccountSettingViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/23/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountSettingTableViewController;

@protocol AccountSettingViewControllerDelegate

- (void)cancelAccountSettingTableView;

@end

@interface AccountSettingViewController : UIViewController
{
  id <AccountSettingViewControllerDelegate> delegate_;
  UIView * topBar_;
  AccountSettingTableViewController * accountSettingTableViewController_;
}

@property (nonatomic, assign) id <AccountSettingViewControllerDelegate> delegate;
@property (nonatomic, retain) UIView * topBar;
@property (nonatomic, retain) AccountSettingTableViewController * accountSettingTableViewController;

@end
