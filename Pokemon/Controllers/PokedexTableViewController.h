//
//  PokedexTableViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomTableViewController.h"

@interface PokedexTableViewController : CustomTableViewController
{
  NSArray * pokedex_;
  NSString * pokedexSequence_;
}

@property (nonatomic, copy) NSArray * pokedex;
@property (nonatomic, copy) NSString * pokedexSequence;

@end
