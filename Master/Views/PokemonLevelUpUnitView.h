//
//  PokemonLevelUpUnitView.h
//  iPokeMon
//
//  Created by Kaijie Yu on 4/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PokemonLevelUpUnitView : UIView {
  UILabel * name_;
  UILabel * value_;
  UILabel * deltaValue_;
}

@property (nonatomic, strong) UILabel * name;
@property (nonatomic, strong) UILabel * value;
@property (nonatomic, strong) UILabel * deltaValue;

- (void)adjustNameLabelWidthWith:(CGFloat)deltaWidth;

@end
