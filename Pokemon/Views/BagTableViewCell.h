//
//  BagTableViewCell.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BagTableViewCell : UITableViewCell

- (void)configureCellWithTitle:(NSString *)title
                          icon:(UIImage *)icon
                 accessoryType:(UITableViewCellAccessoryType)accessoryType;

@end
