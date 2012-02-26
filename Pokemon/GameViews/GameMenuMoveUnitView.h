//
//  GameMenuMoveUnitView.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameMenuMoveUnitView : UIView
{
  UILabel  * type1_;
  UILabel  * type2_;
  UILabel  * name_;
  UILabel  * pp_;
  UIButton * viewButton_;
}

@property (nonatomic, retain) UILabel  * type1;
@property (nonatomic, retain) UILabel  * type2;
@property (nonatomic, retain) UILabel  * name;
@property (nonatomic, retain) UILabel  * pp;
@property (nonatomic, retain) UIButton * viewButton;

@end
