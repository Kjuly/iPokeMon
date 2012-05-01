//
//  BagTableViewCell.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseTableViewCell : UITableViewCell {
  UIButton * exchangeButton_;
}

@property (nonatomic, retain) UIButton * exchangeButton;

- (void)configureCellWithTitle:(NSString *)title
                         price:(NSString *)price
                          icon:(UIImage *)icon
                           odd:(BOOL)odd;

@end
