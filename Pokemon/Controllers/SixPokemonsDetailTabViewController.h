//
//  SixPokemonsDetailTabViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/21/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CustomTabViewController.h"

@class TrainerTamedPokemon;

@interface SixPokemonsDetailTabViewController : CustomTabViewController
{
  TrainerTamedPokemon * pokemon_;
}

@property (nonatomic, retain) TrainerTamedPokemon * pokemon;

- (id)initWithPokemon:(TrainerTamedPokemon *)pokemon;

@end
