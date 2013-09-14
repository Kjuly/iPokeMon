//
//  BagTableViewCell.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCellStyleSlider : UITableViewCell {
  UISlider * slider_;
}

@property (nonatomic, strong) UISlider * slider;

- (void)configureCellWithTitle:(NSString *)title
                   sliderValue:(float)value;

@end
