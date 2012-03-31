//
//  PokedexTableViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomTableViewController.h"

@interface PokedexTableViewController : CustomTableViewController <NSFetchedResultsControllerDelegate>
{
  NSMutableArray             * pokedexSequence_; 
  NSFetchedResultsController * fetchedResultsController_;
}

@property (nonatomic, copy)   NSMutableArray             * pokedexSequence;
@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsController;

@end
