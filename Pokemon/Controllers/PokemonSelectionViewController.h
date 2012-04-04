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
}

@property (nonatomic, assign) NSInteger selectedPokemonUID;

- (void)initWithPokemonsWithUID:(NSArray *)pokemonsUID;

@end
