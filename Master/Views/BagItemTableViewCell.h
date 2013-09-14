//
//  BagTableViewCell.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BagItemTableViewCell : UITableViewCell {
  UIImageView * imageView_;
  UILabel     * name_;
  UILabel     * quantity_;
}

@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UILabel     * name;
@property (nonatomic, strong) UILabel     * quantity;

@end
