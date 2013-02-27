//
//  SixPokemonsDetailTabViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/21/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "KYArcTabViewController.h"

@class TrainerTamedPokemon;

@interface SixPokemonsDetailTabViewController : KYArcTabViewController

- (id)initWithPokemon:(TrainerTamedPokemon *)pokemon
           withTopbar:(BOOL)withTopbar;

@end
