//
//  BagTableViewCell.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCellStyleSwitch : UITableViewCell {
  UISwitch * switchButton_;
}

@property (nonatomic, strong) UISwitch * switchButton;

- (void)configureCellWithTitle:(NSString *)title
                      switchOn:(BOOL)switchOn;

@end
