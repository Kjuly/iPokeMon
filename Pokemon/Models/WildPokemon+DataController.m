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

// Query a Wild Pokemon Data with UID
+ (WildPokemon *)queryPokemonDataWithUID:(NSInteger)pokemonUID
{
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"uid == %d", pokemonUID];
  [fetchRequest setPredicate:predicate];
  //  [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:@"", nil];
  [fetchRequest setFetchLimit:1];
  
  NSError * error;
  WildPokemon * pokemon = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
  [fetchRequest release];
  
  return pokemon;
}

// Query a Wild Pokemon Data wit SID
+ (WildPokemon *)queryPokemonDataWithSID:(NSInteger)pokemonSID
{
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sid == %d", pokemonSID];
  [fetchRequest setPredicate:predicate];
  //  [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:@"", nil];
  [fetchRequest setFetchLimit:1];
  
  NSError * error;
  WildPokemon * pokemon = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
  [fetchRequest release];
  
  return pokemon;
}

// Get Pokemons that in |pokemonUIDs| array (for PokemonSelcetion)
+ (NSArray *)queryPokemonsWithUIDs:(NSArray *)pokemonUIDs
                        fetchLimit:(NSInteger)fetchLimit {
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class])
                                      inManagedObjectContext:managedObjectContext]];
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"uid IN %@", pokemonUIDs]];
  [fetchRequest setFetchLimit:fetchLimit];
  
  NSError * error;
  NSArray * pokemons = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  [fetchRequest release];
  
  return pokemons;
}

// Get Pokemons that in |pokemonSIDs| array (for generate Wild Pokemon)
+ (NSArray *)queryPokemonsWithSIDs:(NSArray *)pokemonSIDs
                        fetchLimit:(NSInteger)fetchLimit {
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class])
                                      inManagedObjectContext:managedObjectContext]];
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"sid IN %@", pokemonSIDs]];
  [fetchRequest setFetchLimit:fetchLimit];
  
  NSError * error;
  NSArray * pokemons = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  [fetchRequest release];
  
  return pokemons;
}

#pragma mark - GET Base data dispatch

// Number of Moves in |fourMoves|
- (NSInteger)numberOfMoves {
  return [[self.fourMoves componentsSeparatedByString:@","] count] / 3;
}

//
// |self.fourMoves|:
//    move1ID,move1currPP,move1maxPP, move2ID,move2currPP,move2maxPP,
//    move3ID,move3currPP,move3maxPP, move4ID,move4currPP,move4maxPP
//
- (Move *)moveWithIndex:(NSInteger)index {
  NSArray * fourMoves = [self.fourMoves componentsSeparatedByString:@","];
  if (index > [fourMoves count] / 3 || index <= 0)
    return nil;
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
  NSInteger fourMovesCount = [fourMoves count] / 3;
  if (fourMovesCount <= 0)
    return nil;
  NSMutableArray * fourMovesPP = [NSMutableArray arrayWithCapacity:(fourMovesCount * 2)];
  for (NSInteger i = 0; i < fourMovesCount; ++i) {
    [fourMovesPP addObject:[fourMoves objectAtIndex:(i * 3 + 1)]];
    [fourMovesPP addObject:[fourMoves objectAtIndex:(i * 3 + 2)]];
  }
  fourMoves = nil;
  return fourMovesPP;
}

- (NSArray *)maxStatsInArray {
  return [self.maxStats componentsSeparatedByString:@","];
}

#pragma mark - SET Base data

@end
