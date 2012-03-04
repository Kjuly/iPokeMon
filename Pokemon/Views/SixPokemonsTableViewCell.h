//
//  SixPokemonsTableViewCell.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SixPokemonsTableViewCell : UITableViewCell
{
  UIImageView * imageView_;
  UILabel     * nameLabel_;
  UIImageView * genderImageView_;
  UILabel     * levelLabel_;
  UILabel     * HPLabel_;
  UIView      * HPBarTotal_;
  UIView      * HPBarLeft_;
}

@property (nonatomic, retain) UIImageView * imageView;
@property (nonatomic, retain) UILabel     * nameLabel;
@property (nonatomic, retain) UIImageView * genderImageView;
@property (nonatomic, retain) UILabel     * levelLabel;
@property (nonatomic, retain) UILabel     * HPLabel;
@property (nonatomic, retain) UIView      * HPBarTotal;
@property (nonatomic, retain) UIView      * HPBarLeft;

@end
