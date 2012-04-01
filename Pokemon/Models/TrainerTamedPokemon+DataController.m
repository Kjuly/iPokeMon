//
//  TrainerTamedPokemon+DataController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/21/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "TrainerTamedPokemon+DataController.h"

#import "AppDelegate.h"
#import "ServerAPIClient.h"
#import "TrainerCoreDataController.h"
#import "Trainer+DataController.h"


@implementation TrainerTamedPokemon (DataController)

// Update |TrainerTamedPokemon|
+ (void)initWithUserID:(NSInteger)userID {
  if (userID <= 0) return;
  
  // Success Block Method
  void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id JSON) {
    NSManagedObjectContext * managedObjectContext =
      [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    // Get JSON Data Array from HTTP Response
    if ([[JSON valueForKey:@"pokedex"] isKindOfClass:[NSNull class]]) {
      NSLog(@"...Update |%@| data done...NO Pokemon Data", [self class]);
      return;
    }
    NSArray * tamedPokemonGroup = [JSON valueForKey:@"pokedex"];
    
    Trainer * trainer = [Trainer queryTrainerWithUserID:userID];
    
    NSError * error;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class])
                                        inManagedObjectContext:managedObjectContext]];
    [fetchRequest setFetchLimit:1];
    
    // Update the data for |tamedPokemmon|
    for (NSDictionary * tamedPokemonData in tamedPokemonGroup) {
      // Check the existence of the object
      [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"uid == %@", [tamedPokemonData valueForKey:@"uid"]]];
      
      // If exist, execute fetching request, otherwise, insert new object
      TrainerTamedPokemon * tamedPokemon;
      if ([managedObjectContext countForFetchRequest:fetchRequest error:&error])
        tamedPokemon = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
      else {
        tamedPokemon = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                                     inManagedObjectContext:managedObjectContext];
        // Set relationships
        tamedPokemon.owner = trainer;
        Pokemon * pokemon = [Pokemon queryPokemonDataWithID:[[tamedPokemonData valueForKey:@"sid"] intValue]];
        tamedPokemon.pokemon = pokemon;
        pokemon = nil;
        
//        NSArray * moveIDs = [[tamedPokemonData valueForKey:@"fourMovesID"] componentsSeparatedByString:@","];
//        NSArray * moves = [Move queryFourMovesDataWithIDs:moveIDs];
//        [tamedPokemon addFourMoves:[NSSet setWithArray:moves]];
//        moves = nil;
//        moveIDs = nil;
      }
      
      // Set data
      tamedPokemon.uid         = [tamedPokemonData valueForKey:@"uid"];
      tamedPokemon.sid         = [tamedPokemonData valueForKey:@"sid"];
      tamedPokemon.box         = [tamedPokemonData valueForKey:@"box"];
      tamedPokemon.status      = [tamedPokemonData valueForKey:@"status"];
      tamedPokemon.gender      = [tamedPokemonData valueForKey:@"gender"];
      tamedPokemon.happiness   = [tamedPokemonData valueForKey:@"happiness"];
      tamedPokemon.level       = [tamedPokemonData valueForKey:@"level"];
      tamedPokemon.fourMoves   = [tamedPokemonData valueForKey:@"fourMoves"];
      tamedPokemon.maxStats    = [tamedPokemonData valueForKey:@"maxStats"];
      tamedPokemon.currHP      = [tamedPokemonData valueForKey:@"currHP"];
      tamedPokemon.currEXP     = [tamedPokemonData valueForKey:@"currEXP"];
      tamedPokemon.toNextLevel = [tamedPokemonData valueForKey:@"toNextLevel"];
      tamedPokemon.memo        = [tamedPokemonData valueForKey:@"memo"];
    }
    
    [fetchRequest release];
    
    if (! [managedObjectContext save:&error])
      NSLog(@"!!! Couldn't save data to %@", NSStringFromClass([self class]));
    NSLog(@"...Update |%@| data done...", [self class]);
  };
  
  // Failure Block Method
  void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError * error) {
    NSLog(@"!!! ERROR: %@", error);
  };
  
  // Fetch data from server & populate the |teamedPokemon|
  [[ServerAPIClient sharedInstance] fetchDataFor:kDataFetchTargetTamedPokemon success:success failure:failure];
}

// Sync data between Client & Server
+ (void)syncWithUserID:(NSInteger)userID flag:(DataModifyFlag)flag {
  TrainerTamedPokemon * pokemon = [self queryPokemonDataWithID:1];
  NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
  if (! (flag & kDataModifyTamedPokemon))
    return;
  
  if (flag & kDataModifyTamedPokemonBasic) {
    [data setValue:pokemon.status forKey:@"status"];
    [data setValue:pokemon.happiness forKey:@"happiness"];
    [data setValue:pokemon.level forKey:@"level"];
    [data setValue:pokemon.fourMoves forKey:@"fourMoves"];
    [data setValue:pokemon.maxStats forKey:@"maxStats"];
    [data setValue:pokemon.currHP forKey:@"currHP"];
    [data setValue:pokemon.currEXP forKey:@"currEXP"];
    [data setValue:pokemon.toNextLevel forKey:@"toNextLevel"];
  }
  if (flag & kDataModifyTamedPokemonExtra) {
    [data setValue:pokemon.box forKey:@"box"];
    [data setValue:pokemon.memo forKey:@"memo"];
  }
  
  // Block: |success| & |failure|
  void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"...Sync |%@| data done...Reset FLAG_", [self class]);
    // Reset |flag_| in |TrainerCoreDataController| after sync done & successed (response 'v' with value 1)
    if ([[responseObject valueForKey:@"v"] intValue])
      [[TrainerCoreDataController sharedInstance] syncDoneWithFlag:kDataModifyTamedPokemon];
  };
  void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"!!! Sync |%@| data failed ERROR: %@", [self class], error);
  };
  
  NSLog(@"Sync Data:%@", data);
  [[ServerAPIClient sharedInstance] updateData:data forTarget:kDataFetchTargetTamedPokemon success:success failure:failure];
  [data release];
}

// Get Six Pokemons that trainer brought
// State: 0 - Unknown; 1 - Seen; 2 - Caught; 3 - Brought; 4 - Foster Care.
+ (NSArray *)sixPokemonsForTrainer:(NSInteger)trainerID
{
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class])
                                      inManagedObjectContext:managedObjectContext]];
//  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"status == %@ AND owner.sid == %@",
//                              [NSNumber numberWithInt:3], [NSNumber numberWithInt:trainerID]]];
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"status == %d AND owner.sid == %d", 3, trainerID]];
  [fetchRequest setFetchLimit:6];
  
  NSError * error;
  NSArray * sixPokemons = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  [fetchRequest release];
  
  return sixPokemons;
}

// Get pokemons that in pokemons ID array
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

// Get one Pokemon that trainer brought
+ (TrainerTamedPokemon *)queryPokemonDataWithID:(NSInteger)pokemonID
{
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"status == %d AND sid == %d", 3, pokemonID];
  [fetchRequest setPredicate:predicate];
  //  [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:@"", nil];
  [fetchRequest setFetchLimit:1];
  
  NSError * error;
  TrainerTamedPokemon * pokemon = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
  [fetchRequest release];
  
  return pokemon;
}

#pragma mark - Base data dispatch
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

- (NSArray *)fourMovesPP {
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

- (void)setFourMovesPPWith:(NSArray *)newPPArray
{
  
}

@end
