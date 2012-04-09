//
//  WildPokemon+DataController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "WildPokemon+DataController.h"

#import "PokemonServerAPI.h"
#import "AppDelegate.h"
#import "Pokemon+DataController.h"

#import "AFJSONRequestOperation.h"

@implementation WildPokemon (DataController)

// Query a Wild Pokemon Data
+ (WildPokemon *)queryPokemonDataWithID:(NSInteger)pokemonID
{
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sid == %d", pokemonID];
  [fetchRequest setPredicate:predicate];
  //  [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:@"", nil];
  [fetchRequest setFetchLimit:1];
  
  NSError * error;
  WildPokemon * pokemon = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
  [fetchRequest release];
  
  return pokemon;
}

// Get Pokemons that in |pokemonsID| array (for PokemonSelcetion)
+ (NSArray *)queryPokemonsWithID:(NSArray *)pokemonsID fetchLimit:(NSInteger)fetchLimit
{
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class])
                                      inManagedObjectContext:managedObjectContext]];
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"uid IN %@", pokemonsID]];
  [fetchRequest setFetchLimit:fetchLimit];
  
  NSError * error;
  NSArray * pokemons = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  [fetchRequest release];
  
  return pokemons;
}

#pragma mark - GET Base data dispatch
//
// |self.fourMoves|:
//    move1ID,move1currPP,move1maxPP, move2ID,move2currPP,move2maxPP,
//    move3ID,move3currPP,move3maxPP, move4ID,move4currPP,move4maxPP
//
- (Move *)moveWithIndex:(NSInteger)index {
  NSArray * fourMoves = [self.fourMoves componentsSeparatedByString:@","];
  Move * move = [Move queryMoveDataWithID:[[fourMoves objectAtIndex:(--index * 3)] intValue]];
  fourMoves = nil;
  return move;
}

- (Move *)move1 { return [self moveWithIndex:1]; }
- (Move *)move2 { return [self moveWithIndex:2]; }
- (Move *)move3 { return [self moveWithIndex:3]; }
- (Move *)move4 { return [self moveWithIndex:4]; }

- (NSArray *)fourMovesPPInArray {
  NSArray * fourMoves = [self.fourMoves componentsSeparatedByString:@","];
  NSArray * fourMovesPP = [NSArray arrayWithObjects:
                           [fourMoves objectAtIndex:1],
                           [fourMoves objectAtIndex:2],
                           [fourMoves objectAtIndex:4],
                           [fourMoves objectAtIndex:5],
                           [fourMoves objectAtIndex:7],
                           [fourMoves objectAtIndex:8],
                           [fourMoves objectAtIndex:10],
                           [fourMoves objectAtIndex:11], nil];
  fourMoves = nil;
  return fourMovesPP;
}

- (NSArray *)maxStatsInArray {
  return [self.maxStats componentsSeparatedByString:@","];
}

#pragma mark - SET Base data

- (void)setFourMovesPPWith:(NSArray *)newPPArray
{
  
}

@end
