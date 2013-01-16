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

@property (nonatomic, retain) UIImageView * imageView;
@property (nonatomic, retain) UILabel     * name;
@property (nonatomic, retain) UILabel     * quantity;

@end
