//
//  BagTableViewCell.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GlobalConstants.h"


@interface BagTableViewCell : UITableViewCell
{
  UIImageView * imageView_;
  UILabel     * labelTitle_;
}

@property (nonatomic, retain) UIImageView * imageView;
@property (nonatomic, retain) UILabel     * labelTitle;
@end
