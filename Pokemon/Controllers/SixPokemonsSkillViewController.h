//
//  PokemonStatsViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SixPokemonsDetailViewController.h"

@interface SixPokemonsSkillViewController : SixPokemonsDetailViewController
{
  PokemonInfoLabelView * hpLabelView_;
  PokemonInfoLabelView * attackLabelView_;
  PokemonInfoLabelView * defenseLabelView_;
  PokemonInfoLabelView * spAttackLabelView_;
  PokemonInfoLabelView * spDefenseLabelView_;
  PokemonInfoLabelView * speedLabelView_;
  PokemonInfoLabelView * abilityLabelView_;
}

@property (nonatomic, retain) PokemonInfoLabelView * hpLabelView;
@property (nonatomic, retain) PokemonInfoLabelView * attackLabelView;
@property (nonatomic, retain) PokemonInfoLabelView * defenseLabelView;
@property (nonatomic, retain) PokemonInfoLabelView * spAttackLabelView;
@property (nonatomic, retain) PokemonInfoLabelView * spDefenseLabelView;
@property (nonatomic, retain) PokemonInfoLabelView * speedLabelView;
@property (nonatomic, retain) PokemonInfoLabelView * abilityLabelView;

@end
