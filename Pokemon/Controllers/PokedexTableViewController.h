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
  NSMutableArray * pokedex_;
}

@property (nonatomic, copy) NSMutableArray * pokedex;

@end
