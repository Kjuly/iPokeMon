//
//  PokemonDetailTabViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/5/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "KYArcTabViewController.h"

@interface PokemonDetailTabViewController : KYArcTabViewController

- (id)initWithPokemonSID:(NSInteger)pokemonSID
              withTopbar:(BOOL)withTopbar;

@end
