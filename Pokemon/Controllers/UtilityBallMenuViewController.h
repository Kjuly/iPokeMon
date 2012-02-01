//
//  UtilityBallMenuViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UtilityBallMenuViewController : UIViewController
{
  UIButton * buttonOpen_;
  
  UIView   * ballMenu_;
  UIButton * buttonShowPokedex_;
  UIButton * buttonShowPokemon_;
  UIButton * buttonShowBag_;
  UIButton * buttonShowTrainerCard_;
  UIButton * buttonHotkey_;
  UIButton * buttonSetGame_;
  UIButton * buttonClose_;
}

@property (nonatomic, retain) UIButton * buttonOpen;

@property (nonatomic, retain) UIView   * ballMenu;
@property (nonatomic, retain) UIButton * buttonShowPokedex;
@property (nonatomic, retain) UIButton * buttonShowPokemon;
@property (nonatomic, retain) UIButton * buttonShowBag;
@property (nonatomic, retain) UIButton * buttonShowTrainerCard;
@property (nonatomic, retain) UIButton * buttonHotkey;
@property (nonatomic, retain) UIButton * buttonSetGame;
@property (nonatomic, retain) UIButton * buttonClose;

@end
