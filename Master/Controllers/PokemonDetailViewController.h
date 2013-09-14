//
//  PokemonInfoViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GlobalRender.h"
#import "PokemonInfoLabelView.h"
#import "Pokemon.h"

@class Pokemon;

@interface PokemonDetailViewController : UIViewController {
  Pokemon * pokemon_;
}

@property (nonatomic, strong) Pokemon * pokemon;

- (id)initWithPokemon:(Pokemon *)pokemon;

@end
