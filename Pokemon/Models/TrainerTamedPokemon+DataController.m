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
#import "TrainerController.h"
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
      tamedPokemon.uid         = [NSNumber numberWithInt:[[tamedPokemonData valueForKey:@"uid"] intValue]];
      tamedPokemon.sid         = [NSNumber numberWithInt:[[tamedPokemonData valueForKey:@"sid"] intValue]];
      tamedPokemon.box         = [NSNumber numberWithInt:[[tamedPokemonData valueForKey:@"box"] intValue]];
      tamedPokemon.status      = [NSNumber numberWithInt:[[tamedPokemonData valueForKey:@"status"] intValue]];
      tamedPokemon.gender      = [NSNumber numberWithInt:[[tamedPokemonData valueForKey:@"gender"] intValue]];
      tamedPokemon.happiness   = [NSNumber numberWithInt:[[tamedPokemonData valueForKey:@"happiness"] intValue]];
      tamedPokemon.level       = [NSNumber numberWithInt:[[tamedPokemonData valueForKey:@"level"] intValue]];
      tamedPokemon.fourMoves   = [tamedPokemonData valueForKey:@"fourMoves"];
      tamedPokemon.maxStats    = [tamedPokemonData valueForKey:@"maxStats"];
      NSLog(@"~~~~~~~~~~~~~[tamedPokemonData valueForKey:@'masStats':%@", [tamedPokemonData valueForKey:@"maxStats"]);
      tamedPokemon.hp          = [NSNumber numberWithInt:[[tamedPokemonData valueForKey:@"hp"] intValue]];
      tamedPokemon.exp         = [NSNumber numberWithInt:[[tamedPokemonData valueForKey:@"exp"] intValue]];
      tamedPokemon.toNextLevel = [NSNumber numberWithInt:[[tamedPokemonData valueForKey:@"toNextLevel"] intValue]];
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

// CM: Sync data between Client & Server
+ (void)syncWithUserID:(NSInteger)userID
            pokemonUID:(NSInteger)pokemonUID
                  flag:(DataModifyFlag)flag {
  if (! (flag & kDataModifyTamedPokemon))
    return;
  
  NSLog(@"......|%@| - SVEING DATA......", [self class]);
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSError * error;
  if (! [managedObjectContext save:&error])
    NSLog(@"Couldn't save data to |%@|", NSStringFromClass([self class]));
  
  TrainerTamedPokemon * pokemon = [self queryPokemonDataWithUID:pokemonUID trainerUID:userID];
  [pokemon syncWithFlag:flag];
}

// IM: Sync data between Client & Server
- (void)syncWithFlag:(DataModifyFlag)flag {
  if (! (flag & kDataModifyTamedPokemon))
    return;
  
  NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
  
  // UID
  [data setValue:self.uid           forKey:@"uid"];
  
  if (flag & kDataModifyTamedPokemonNew) {
    [data setValue:self.sid         forKey:@"sid"];
    [data setValue:self.gender      forKey:@"gender"];
  }
  
  if (flag & kDataModifyTamedPokemonBasic) {
    [data setValue:self.status      forKey:@"status"];
    [data setValue:self.happiness   forKey:@"happiness"];
    [data setValue:self.level       forKey:@"level"];
    [data setValue:self.fourMoves   forKey:@"fourMoves"];
    [data setValue:self.maxStats    forKey:@"maxStats"];
    [data setValue:self.hp          forKey:@"hp"];
    [data setValue:self.exp         forKey:@"exp"];
    [data setValue:self.toNextLevel forKey:@"toNextLevel"];
  }
  if (flag & kDataModifyTamedPokemonExtra) {
    [data setValue:self.box         forKey:@"box"];
    [data setValue:self.memo        forKey:@"memo"];
  }
  
  // Block: |success| & |failure|
  void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"...Sync |%@| data done...Reset FLAG_", [self class]);
    // Reset |flag_| in |TrainerCoreDataController| after sync done & successed (response 'v' with value 1)
    if ([[responseObject valueForKey:@"v"] intValue])
      [[TrainerController sharedInstance] syncDoneWithFlag:kDataModifyTamedPokemon];
  };
  void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"!!! Sync |%@| data failed ERROR: %@", [self class], error);
  };
  
  NSLog(@"Sync Data:%@", data);
  [[ServerAPIClient sharedInstance] updateData:data forTarget:kDataFetchTargetTamedPokemon success:success failure:failure];
  [data release];
}

#pragma mark -
#pragma mark - GET Data

// Get Six Pokemons that trainer brought
// State: 0 - Unknown; 1 - Seen; 2 - Caught; 3 - Brought; 4 - Foster Care.
+ (NSArray *)sixPokemonsForTrainer:(NSInteger)trainerID
{
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class])
                                      inManagedObjectContext:managedObjectContext]];
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"owner.uid == %d", trainerID]];
  [fetchRequest setFetchLimit:6];
  
  NSError * error;
  NSArray * sixPokemons = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  [fetchRequest release];
  
  return sixPokemons;
}

// Get pokemons that in pokemons ID array
+ (NSArray *)queryPokemonsWithUID:(NSArray *)pokemonsUID
                       trainerUID:(NSInteger)trainerUID
                       fetchLimit:(NSInteger)fetchLimit
{
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class])
                                      inManagedObjectContext:managedObjectContext]];
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"owner.uid == %d AND uid IN %@", trainerUID, pokemonsUID]];
  [fetchRequest setFetchLimit:fetchLimit];
  
  NSError * error;
  NSArray * pokemons = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  [fetchRequest release];
  
  return pokemons;
}

// Number of Tamed Pokemons owned by trainer
+ (NSInteger)numberOfTamedPokemonsWithTraienrUID:(NSInteger)trainerUID {
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class])
                                      inManagedObjectContext:managedObjectContext]];
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"owner.uid == %d", trainerUID]];
    
  NSError *error;
  NSInteger result = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
  [fetchRequest release];
  return result;
}

// Get one Pokemon that trainer brought
+ (TrainerTamedPokemon *)queryPokemonDataWithUID:(NSInteger)pokemonUID
                                      trainerUID:(NSInteger)trainerUID {
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"owner.uid == %d AND uid == %d", trainerUID, pokemonUID];
  [fetchRequest setPredicate:predicate];
  //  [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:@"", nil];
  [fetchRequest setFetchLimit:1];
  
  NSError * error;
  TrainerTamedPokemon * pokemon = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
  [fetchRequest release];
  
  return pokemon;
}

// Add new Tamed Pokemon with a Wild Pokemon
+ (void)addPokemonWithWildPokemon:(WildPokemon *)wildPokemon
                         withMemo:(NSString *)memo
                            toBox:(NSInteger)box
                       forTrainer:(Trainer *)trainer {
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  TrainerTamedPokemon * tamedPokemon;
  tamedPokemon = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                               inManagedObjectContext:managedObjectContext];
  
  // Set data
  NSLog(@"New TamedPokemon UID:%d", [self numberOfTamedPokemonsWithTraienrUID:[trainer.uid intValue]] + 1);
  tamedPokemon.uid         = [NSNumber numberWithInt:([self numberOfTamedPokemonsWithTraienrUID:[trainer.uid intValue]] + 1)];
  tamedPokemon.sid         = wildPokemon.sid;
  tamedPokemon.box         = [NSNumber numberWithInt:box];
  tamedPokemon.status      = wildPokemon.status;
  tamedPokemon.gender      = wildPokemon.gender;
  tamedPokemon.happiness   = wildPokemon.pokemon.happiness;
  tamedPokemon.level       = wildPokemon.level;
  tamedPokemon.fourMoves   = wildPokemon.fourMoves;
  tamedPokemon.maxStats    = wildPokemon.maxStats;
  tamedPokemon.hp          = wildPokemon.hp;
  tamedPokemon.exp         = wildPokemon.exp;
  tamedPokemon.toNextLevel = wildPokemon.toNextLevel;
  tamedPokemon.memo        = memo;
  
  // Set relationships
  tamedPokemon.owner   = trainer;
  tamedPokemon.pokemon = [Pokemon queryPokemonDataWithID:[wildPokemon.sid intValue]];
  
  NSError * error;
  if (! [managedObjectContext save:&error])
    NSLog(@"!!! Couldn't save data to |%@| :: %@", [self class], error);
  tamedPokemon = nil;
  
  // Sync new Pokemon data to Server
  [tamedPokemon syncWithFlag:kDataModifyTamedPokemon
                            |kDataModifyTamedPokemonNew
                            |kDataModifyTamedPokemonBasic
                            |kDataModifyTamedPokemonExtra];
}

#pragma mark - GET Base data
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

- (NSArray *)fourMovesPP {
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

#pragma mark - SET Base data

- (void)setFourMovesPPWith:(NSArray *)newPPArray
{
  
}

@end
