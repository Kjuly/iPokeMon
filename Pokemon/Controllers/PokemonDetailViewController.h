//
//  PokemonInfoViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Pokemon;

@interface PokemonDetailViewController : UIViewController
{
  Pokemon * pokemonDataDict_;
}

@property (nonatomic, retain) Pokemon * pokemonDataDict;

- (id)initWithPokemonDataDict:(Pokemon *)pokemonDataDict;

@end
