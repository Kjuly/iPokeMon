//
//  SixPokemonsTableViewCell.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SixPokemonsTableViewCell : UITableViewCell {
  UIImageView * imageView_;
  UILabel     * nameLabel_;
  UIImageView * genderImageView_;
  UILabel     * levelLabel_;
  UILabel     * HPLabel_;
  UIImageView * HPBarTotal_;
  UIImageView * HPBarLeft_;
}

@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UILabel     * nameLabel;
@property (nonatomic, strong) UIImageView * genderImageView;
@property (nonatomic, strong) UILabel     * levelLabel;
@property (nonatomic, strong) UILabel     * HPLabel;
@property (nonatomic, strong) UIImageView * HPBarTotal;
@property (nonatomic, strong) UIImageView * HPBarLeft;

@end
