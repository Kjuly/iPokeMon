//
//  PokemonInfoViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SixPokemonsDetailViewController.h"

@interface SixPokemonsInfoViewController : SixPokemonsDetailViewController
{
  PokemonInfoLabelView * levelLabelView_;
  PokemonInfoLabelView * expLabelView_;
  PokemonInfoLabelView * toNextLevelLabelView_;
}

@property (nonatomic, retain) PokemonInfoLabelView * levelLabelView;
@property (nonatomic, retain) PokemonInfoLabelView * expLabelView;
@property (nonatomic, retain) PokemonInfoLabelView * toNextLevelLabelView;

@end
