//
//  Pokemon+DataController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/17/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "Pokemon+DataController.h"

#import "AppDelegate.h"
#import "PListParser.h"

@implementation Pokemon (DataController)

#pragma mark - Hard Initialize the DB data

// Hard Update the DB data
+ (void)hardUpdateData
{
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:@"Pokemon"
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSError * error;
  NSArray * pokemons = [managedObjectContext executeFetchRequest:fetchRequest
                                                           error:&error];
  [fetchRequest release];
  
  // Set Data
  NSArray * pokedex = [PListParser pokedex];
  
  int i = 0;
  for (Pokemon * pokemon in pokemons) {
    NSDictionary * pokemonDict = [pokedex objectAtIndex:i];
    pokemon.sid    = [NSNumber numberWithInt:++i];
    pokemon.name   = [pokemonDict objectForKey:@"name"];
    pokemon.height = [pokemonDict objectForKey:@"height"];
    pokemon.weight = [pokemonDict objectForKey:@"weight"];
    pokemon.info   = [pokemonDict objectForKey:@"description"];
    pokemon.image  = [UIImage imageNamed:[NSString stringWithFormat:@"%.3d", i]];
    pokemonDict = nil;
  }
  
  pokedex = nil;
  
  // Save data
  if (! [managedObjectContext save:&error])
    NSLog(@"!!! Couldn't save image data to %@. Error detail: %@", NSStringFromClass([self class]), error);
  
  error = nil;
  managedObjectContext = nil;
}

#pragma mark - Pokemon Data Query Mthods

// Get data from model
+ (NSArray *)queryAllData
{
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSError * error;
  NSArray * fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest
                                                                 error:&error];
  [fetchRequest release];
  
  return fetchedObjects;
}

// Get data of one Pokemon
+ (Pokemon *)queryPokemonDataWithID:(NSInteger)pokemonID
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
  Pokemon * pokemon = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
  [fetchRequest release];
  
  return pokemon;
}


@end
