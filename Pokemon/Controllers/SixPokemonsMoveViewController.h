//
//  PokemonMoveViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SixPokemonsDetailViewController.h"

@class PokemonMoveView;
@class PokemonMoveDetailView;

@interface SixPokemonsMoveViewController : SixPokemonsDetailViewController
{
  NSArray               * fourMoves_;
  NSArray               * fourMovesPP_;
  UIView                * fourMovesView_;
  PokemonMoveView       * moveOneView_;
  PokemonMoveView       * moveTwoView_;
  PokemonMoveView       * moveThreeView_;
  PokemonMoveView       * moveFourView_;
  PokemonMoveDetailView * moveDetailView_;
}

@property (nonatomic, retain) NSArray               * fourMoves;
@property (nonatomic, retain) NSArray               * fourMovesPP;
@property (nonatomic, retain) UIView                * fourMovesView;
@property (nonatomic, retain) PokemonMoveView       * moveOneView;
@property (nonatomic, retain) PokemonMoveView       * moveTwoView;
@property (nonatomic, retain) PokemonMoveView       * moveThreeView;
@property (nonatomic, retain) PokemonMoveView       * moveFourView;
@property (nonatomic, retain) PokemonMoveDetailView * moveDetailView;

@end
