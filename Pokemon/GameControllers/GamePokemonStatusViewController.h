//
//  GamePokemonStatusViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 3/7/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PokemonHPBar;

@interface GamePokemonStatusViewController : UIViewController {
  PokemonHPBar * pokemonHPBar_;
  UILabel      * pokemonName_;
  UILabel      * pokemonLevel_;
  UIImageView  * pokemonGender_;
  UIImageView  * backgroundView_;
}

@property (nonatomic, retain) PokemonHPBar * pokemonHPBar;
@property (nonatomic, retain) UILabel      * pokemonName;
@property (nonatomic, retain) UILabel      * pokemonLevel;
@property (nonatomic, retain) UIImageView  * pokemonGender;
@property (nonatomic, retain) UIImageView  * backgroundView;

- (void)updatePokemonStatus:(NSDictionary *)statusInfo;

@end
