//
//  SixPokemonsTableViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomTableViewController.h"

@interface SixPokemonsTableViewController : CustomTableViewController
{
  NSArray * sixPokemons_;
}

@property (nonatomic, copy) NSArray * sixPokemons;

@end
