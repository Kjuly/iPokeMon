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
  NSInteger pokedexSequence_;
  NSArray * pokedex_;
  NSArray * pokedexImages_;
}

@property (nonatomic, assign) NSInteger pokedexSequence;
@property (nonatomic, copy) NSArray * pokedex;
@property (nonatomic, copy) NSArray * pokedexImages;

@end
