//
//  PokemonInfoViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GlobalRender.h"
#import "Pokemon.h"
#import "TrainerTamedPokemon+DataController.h"
#import "PokemonInfoLabelView.h"

@class TrainerTamedPokemon;

@interface SixPokemonsDetailViewController : UIViewController {
  TrainerTamedPokemon * pokemon_;
}

@property (nonatomic, strong) TrainerTamedPokemon * pokemon;

- (id)initWithPokemon:(TrainerTamedPokemon *)pokemon;

@end
