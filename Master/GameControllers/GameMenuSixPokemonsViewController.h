//
//  GameMenuSixPokemonViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 3/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameMenuSixPokemonsUnitView.h"

@interface GameMenuSixPokemonsViewController : UIViewController <
  GameMenuSixPokemonsUnitViewDelegate
> {
  BOOL isSelectedPokemonInfoViewOpening_;
  NSInteger currBattlePokemon_;
}

@property (nonatomic, assign) BOOL isSelectedPokemonInfoViewOpening;
@property (nonatomic, assign) NSInteger currBattlePokemon;

- (void)initWithSixPokemonsForReplacing:(BOOL)forReplacing;
- (void)loadSixPokemonsAnimated:(BOOL)animated;
- (void)unloadSixPokemonsAnimated:(BOOL)animated;
- (void)unloadSelcetedPokemonInfoView;
- (void)prepareForNewScene;

@end
