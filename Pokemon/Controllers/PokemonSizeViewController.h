//
//  PokemonSizeViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PokemonSizeViewController : UIViewController
{
  NSInteger      pokemonID_;
  NSDictionary * pokemonInfoDict_;
}

@property (nonatomic, assign) NSInteger    pokemonID;
@property (nonatomic, copy) NSDictionary * pokemonInfoDict;

- (id)initWithPokemonID:(NSInteger)pokemonID;

@end
