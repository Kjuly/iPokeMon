//
//  PokemonDetailTabViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/5/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CustomTabViewController.h"

@interface PokemonDetailTabViewController : CustomTabViewController
{
  NSDictionary * pokemonDataDict_;
}

// |copy| will cause error, why?
@property (nonatomic, retain) NSDictionary * pokemonDataDict;

- (id)initWithPokemonID:(NSInteger)pokemonID;

@end
