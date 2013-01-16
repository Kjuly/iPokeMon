//
//  SixPokemonsDetailTabViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/21/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CustomTabViewController.h"

@class TrainerTamedPokemon;

@interface SixPokemonsDetailTabViewController : CustomTabViewController

- (id)initWithPokemon:(TrainerTamedPokemon *)pokemon withTopbar:(BOOL)withTopbar;

@end
