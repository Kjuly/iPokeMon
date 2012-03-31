//
//  TrainerInfoViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrainerCoreDataController;

@interface TrainerInfoViewController : UIViewController
{
  TrainerCoreDataController * trainer_;
  
  UIImageView * imageView_;
  UIView  * IDView_;
  UILabel * IDLabel_;
  UILabel * nameLabel_;
  UIView  * dataView_;
  UILabel * moneyLabel_;
  UILabel * moneyValue_;
  UILabel * pokedexLabel_;
  UILabel * pokedexValue_;
  UILabel * badgesLabel_;
  UILabel * badgesValue_;
  UILabel * adventureStartedTimeLabel_;
  UILabel * adventureStartedTimeValue_;
}

@property (nonatomic, retain) TrainerCoreDataController * trainer;

@property (nonatomic, retain) UIImageView * imageView;
@property (nonatomic, retain) UIView  * IDView;
@property (nonatomic, retain) UILabel * IDLabel;
@property (nonatomic, retain) UILabel * nameLabel;
@property (nonatomic, retain) UIView  * dataView;
@property (nonatomic, retain) UILabel * moneyLabel;
@property (nonatomic, retain) UILabel * moneyValue;
@property (nonatomic, retain) UILabel * pokedexLabel;
@property (nonatomic, retain) UILabel * pokedexValue;
@property (nonatomic, retain) UILabel * badgesLabel;
@property (nonatomic, retain) UILabel * badgesValue;
@property (nonatomic, retain) UILabel * adventureStartedTimeLabel;
@property (nonatomic, retain) UILabel * adventureStartedTimeValue;


@end
