//
//  TrainerBadgesTableViewCell.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainerBadgesTableViewCell : UITableViewCell
{
  UIImageView * imageView_;
  UILabel     * labelTitle_;
  UILabel     * labelSubtitle_;
}

@property (nonatomic, retain) UIImageView * imageView;
@property (nonatomic, retain) UILabel     * labelTitle;
@property (nonatomic, retain) UILabel     * labelSubtitle;

@end
