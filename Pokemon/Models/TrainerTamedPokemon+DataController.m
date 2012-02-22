//
//  TrainerTamedPokemon+DataController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/21/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "TrainerTamedPokemon+DataController.h"

#import "PokemonServerAPI.h"
#import "Trainer+DataController.h"
#import "Pokemon+DataController.h"
#import "AppDelegate.h"
#import "AFJSONRequestOperation.h"

@implementation TrainerTamedPokemon (DataController)

// Update |TrainerTamedPokemon|
+ (BOOL)updateDataForTrainer:(NSInteger)trainerID
{
  // Success Block Method
  void (^blockPopulateData)(NSURLRequest *, NSHTTPURLResponse *, id) =
  ^(NSURLRequest * request, NSHTTPURLResponse * response, id JSON) {
    NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    // Get JSON Data Array from HTTP Response
    NSArray * tamedPokemonGroup = [JSON valueForKey:@"pokedex"];
    Trainer * trainer = [Trainer queryTrainerWithTrainerID:trainerID];
    
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
        
//        tamedPokemon.fourMoves   = [tamedPokemonData valueForKey:@"fourMoves"];
      }
      
      // Set data
      tamedPokemon.uid         = [tamedPokemonData valueForKey:@"uid"];
      tamedPokemon.sid         = [tamedPokemonData valueForKey:@"sid"];
      tamedPokemon.box         = [tamedPokemonData valueForKey:@"box"];
      tamedPokemon.state       = [tamedPokemonData valueForKey:@"state"];
      tamedPokemon.gender      = [tamedPokemonData valueForKey:@"gender"];
      tamedPokemon.happiness   = [tamedPokemonData valueForKey:@"happiness"];
      tamedPokemon.level       = [tamedPokemonData valueForKey:@"level"];
      tamedPokemon.maxStats    = [tamedPokemonData valueForKey:@"maxStats"];
      tamedPokemon.leftStats   = [tamedPokemonData valueForKey:@"leftStats"];
      tamedPokemon.currEXP     = [tamedPokemonData valueForKey:@"currEXP"];
      tamedPokemon.toNextLevel = [tamedPokemonData valueForKey:@"toNextLevel"];
      tamedPokemon.memo        = [tamedPokemonData valueForKey:@"memo"];
    }
    
    [fetchRequest release];
    
    if (! [managedObjectContext save:&error])
      NSLog(@"!!! Couldn't save data to %@", NSStringFromClass([self class]));
#if DEBUG
    NSLog(@"...Update |%@| data done...", [self class]);
#endif
  };
  
  // Failure Block Method
  void (^blockError)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id) =
  ^(NSURLRequest *request, NSHTTPURLResponse * response, NSError * error, id JSON) {
    NSLog(@"!!! ERROR: %@", error);
  };
  
  
  // Fetch data from server & populate the |teamedPokemon|
  NSURLRequest * request =
  [[NSURLRequest alloc] initWithURL:[PokemonServerAPI APIGetPokedexWithTrainerID:trainerID]];
  
  AFJSONRequestOperation * operation =
  [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                  success:blockPopulateData
                                                  failure:blockError];
  [request release];
  [operation start];
  
  return true;
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
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"state == %@ AND owner.sid == %@",
                              [NSNumber numberWithInt:3], [NSNumber numberWithInt:trainerID]]];
  [fetchRequest setFetchLimit:6];
  
  NSError * error;
  NSArray * sixPokemons = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  [fetchRequest release];
  
  return sixPokemons;
}

@end
