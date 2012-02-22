//
//  PokemonMoveViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SixPokemonsDetailViewController.h"

@class PokemonMoveView;

@interface SixPokemonsMoveViewController : SixPokemonsDetailViewController
{
  NSArray         * fourMoves_;
  PokemonMoveView * moveOneView_;
  PokemonMoveView * moveTwoView_;
  PokemonMoveView * moveThreeView_;
  PokemonMoveView * moveFourView_;
}

@property (nonatomic, retain) NSArray         * fourMoves;
@property (nonatomic, retain) PokemonMoveView * moveOneView;
@property (nonatomic, retain) PokemonMoveView * moveTwoView;
@property (nonatomic, retain) PokemonMoveView * moveThreeView;
@property (nonatomic, retain) PokemonMoveView * moveFourView;

@end
