//
//  GameMenuSixPokemonViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 3/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameMenuSixPokemonsUnitView.h"

@interface PokemonSelectionViewController : UIViewController <GameMenuSixPokemonsUnitViewDelegate>
{
  BOOL isSelectedPokemonInfoViewOpening_;
}

@property (nonatomic, assign) BOOL isSelectedPokemonInfoViewOpening;

- (void)initWithPokemonsWithUID:(NSArray *)pokemonsUID;
- (void)loadViewAnimated:(BOOL)animated;
- (void)unloadViewAnimated:(BOOL)animated;
- (void)unloadSelcetedPokemonInfoView;

@end
