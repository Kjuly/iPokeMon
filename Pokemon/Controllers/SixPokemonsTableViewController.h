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
  NSMutableArray * sixPokemonsID_;
  NSMutableArray * sixPokemons_;
  NSArray * dataArray_;
}

@property (nonatomic, copy) NSMutableArray * sixPokemonsID;
@property (nonatomic, copy) NSMutableArray * sixPokemons;
@property (nonatomic, copy) NSArray * dataArray;

@end
