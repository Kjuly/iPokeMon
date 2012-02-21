//
//  SixPokemonsDetailTabViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/21/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CustomTabViewController.h"

@class TrainerTamedPokemon;
@class SixPokemonsInfoViewController;
@class SixPokemonsMemoViewController;
@class SixPokemonsSkillViewController;
@class SixPokemonsMoveViewController;

@interface SixPokemonsDetailTabViewController : CustomTabViewController
{
  TrainerTamedPokemon * pokemon_;
  SixPokemonsInfoViewController  * sixPokemonsInfoViewController_;
  SixPokemonsMemoViewController  * sixPokemonsMemoViewController_;
  SixPokemonsSkillViewController * sixPokemonsSkillViewController_;
  SixPokemonsMoveViewController  * sixPokemonsMoveViewController_;
}

@property (nonatomic, retain) TrainerTamedPokemon * pokemon;
@property (nonatomic, retain) SixPokemonsInfoViewController  * sixPokemonsInfoViewController;
@property (nonatomic, retain) SixPokemonsMemoViewController  * sixPokemonsMemoViewController;
@property (nonatomic, retain) SixPokemonsSkillViewController * sixPokemonsSkillViewController;
@property (nonatomic, retain) SixPokemonsMoveViewController  * sixPokemonsMoveViewController;

- (id)initWithPokemon:(TrainerTamedPokemon *)pokemon;

@end
