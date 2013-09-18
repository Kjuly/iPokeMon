//
//  GameMenuSixPokemonViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 3/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameMenuSixPokemonsUnitView.h"

@interface PokemonSelectionViewController : UIViewController <
  GameMenuSixPokemonsUnitViewDelegate
> {
  NSInteger selectedPokemonSID_;
  BOOL      isSelectedPokemonInfoViewOpening_;
}

@property (nonatomic, assign) NSInteger selectedPokemonSID;
@property (nonatomic, assign) BOOL      isSelectedPokemonInfoViewOpening;

- (void)initWithPokemonsWithSIDs:(NSArray *)pokemonSIDs;
- (void)unloadPokemonSelectionViewAnimated:(BOOL)animated;
- (void)unloadSelcetedPokemonInfoView;

@end
