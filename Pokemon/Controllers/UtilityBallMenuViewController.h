//
//  UtilityBallMenuViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AbstractCenterMenuViewController.h"

@class PokedexTableViewController;
@class SixPokemonsTableViewController;
@class BagTableViewController;
@class TrainerCardViewController;
@class GameSettingTableViewController;

@interface UtilityBallMenuViewController : AbstractCenterMenuViewController
{
  PokedexTableViewController     * pokedexTableViewController_;
  SixPokemonsTableViewController * sixPokemonsTableViewController_;
  BagTableViewController         * bagTableViewController_;
  TrainerCardViewController      * trainerCardViewController_;
  GameSettingTableViewController * gameSettingTableViewController_;
}

@property (nonatomic, retain) PokedexTableViewController     * pokedexTableViewController;
@property (nonatomic, retain) SixPokemonsTableViewController * sixPokemonsTableViewController;
@property (nonatomic, retain) BagTableViewController         * bagTableViewController;
@property (nonatomic, retain) TrainerCardViewController      * trainerCardViewController;
@property (nonatomic, retain) GameSettingTableViewController * gameSettingTableViewController;

// Button Action
- (void)showPokedex:(id)sender;
- (void)showPokemon:(id)sender;
- (void)showBag:(id)sender;
- (void)showTrainerCard:(id)sender;
- (void)runHotkey:(id)sender;
- (void)setGame:(id)sender;

@end
