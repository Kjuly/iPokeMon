//
//  AccountSettingTableViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/10/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccountSettingTableViewControllerDelegate

- (void)cancelAccountSettingTableView;

@end

@interface AccountSettingTableViewController : UITableViewController
{
  id <AccountSettingTableViewControllerDelegate> delegate_;
  UIView * topBar_;
}

@property (nonatomic, assign) id <AccountSettingTableViewControllerDelegate> delegate;
@property (nonatomic, retain) UIView * topBar;

@end
