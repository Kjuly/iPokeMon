//
//  GamePokemonStatusViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 3/7/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PokemonHPBar.h"

@interface GamePokemonStatusViewController : UIViewController {
  PokemonHPBar * pokemonHPBar_;
  UILabel      * pokemonName_;
  UILabel      * pokemonLevel_;
  UIImageView  * pokemonGender_;
}

@property (nonatomic, strong) PokemonHPBar * pokemonHPBar;
@property (nonatomic, strong) UILabel      * pokemonName;
@property (nonatomic, strong) UILabel      * pokemonLevel;
@property (nonatomic, strong) UIImageView  * pokemonGender;

- (void)updatePokemonStatus:(NSDictionary *)statusInfo;
- (void)prepareForNewScene; // Overwrited by child
- (void)reset;

@end
