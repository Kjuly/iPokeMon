//
//  BagTableViewCell.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GlobalConstants.h"

@interface SettingTableViewCellStyleTitle : UITableViewCell

- (void)configureCellWithTitle:(NSString *)title
                         value:(NSString *)value
                 accessoryType:(UITableViewCellAccessoryType)accessoryType;

@end
