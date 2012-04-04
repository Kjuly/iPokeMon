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
  NSInteger selectedPokemonUID_;
  BOOL      isSelectedPokemonInfoViewOpening_;
}

@property (nonatomic, assign) NSInteger selectedPokemonUID;
@property (nonatomic, assign) BOOL      isSelectedPokemonInfoViewOpening;

- (void)initWithPokemonsWithUID:(NSArray *)pokemonsUID;
- (void)unloadPokemonSelectionViewAnimated:(BOOL)animated;
- (void)unloadSelcetedPokemonInfoView;

@end
