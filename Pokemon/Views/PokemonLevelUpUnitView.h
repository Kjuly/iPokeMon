//
//  PokemonLevelUpUnitView.h
//  Pokemon
//
//  Created by Kaijie Yu on 4/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PokemonLevelUpUnitView : UIView
{
  UILabel * name_;
  UILabel * value_;
  UILabel * deltaValue_;
}

@property (nonatomic, retain) UILabel * name;
@property (nonatomic, retain) UILabel * value;
@property (nonatomic, retain) UILabel * deltaValue;

- (void)adjustNameLabelWidthWith:(CGFloat)deltaWidth;

@end
