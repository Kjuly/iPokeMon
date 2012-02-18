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

// Hard Initialize the DB data
+ (void)populateData
{
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  
  // Fetch data that store in |pokedex.plist|
  NSArray * pokedex = [PListParser pokedex];
  
  int i = 0;
  for (NSDictionary * pokemonDict in pokedex) {
    Pokemon * pokemon = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                                      inManagedObjectContext:managedObjectContext];
    
    pokemon.sid = [NSNumber numberWithInt:++i];
    pokemon.name  = [pokemonDict objectForKey:@"name"];
    pokemon.height = [pokemonDict objectForKey:@"height"];
    pokemon.weight = [pokemonDict objectForKey:@"weight"];
    pokemon.info = [pokemonDict objectForKey:@"description"];
    pokemon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%.3d", i]];
    
    pokemonDict = nil;
    pokemon = nil;
  }
  
  pokedex = nil;
  
  NSError * error;
  if (! [managedObjectContext save:&error])
    NSLog(@"!!! Couldn't save data to %@", NSStringFromClass([self class]));
}

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

// Get data from model
+ (NSArray *)queryAllData
{
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:@"Pokemon"
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSError * error;
  NSArray * fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest
                                                                 error:&error];
  [fetchRequest release];
  
  return fetchedObjects;
}


@end
