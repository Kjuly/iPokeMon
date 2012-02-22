//
//  PoketchSixPokemonsViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/12/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoketchSixPokemonsViewController : UIViewController
{
  NSArray * sixPokemons_;
  NSArray * imageArray_;
}

@property (nonatomic, copy) NSArray * sixPokemons;
@property (nonatomic, copy) NSArray * imageArray;

@end
