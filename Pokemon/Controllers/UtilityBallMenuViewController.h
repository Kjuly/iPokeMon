//
//  UtilityBallMenuViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomNavigationController.h"

@class PokedexTableViewController;

@interface UtilityBallMenuViewController : UIViewController <CustomNavigationControllerDelegate>
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
  
  PokedexTableViewController * pokedexTableViewController_;
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

@property (nonatomic, retain) PokedexTableViewController * pokedexTableViewController;

// Button Action
- (void)runButtonActions:(id)sender;
- (void)showPokedex:(id)sender;
- (void)showPokemon:(id)sender;
- (void)showBag:(id)sender;
- (void)showTrainerCard:(id)sender;
- (void)runHotkey:(id)sender;
- (void)setGame:(id)sender;
- (void)closeView:(id)sender;

@end
