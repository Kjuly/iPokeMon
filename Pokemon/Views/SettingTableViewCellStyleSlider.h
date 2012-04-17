//
//  BagTableViewCell.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GlobalConstants.h"

@interface SettingTableViewCellStyleSlider : UITableViewCell

- (void)configureCellWithTitle:(NSString *)title
                   sliderValue:(float)value;

@end
