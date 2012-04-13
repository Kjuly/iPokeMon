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

// Pokemon SIDs for type of Habitat
+ (NSArray *)SIDsForHabitat:(PokemonHabitat)habitat {
  /*/
  // For TESTING
  //
  // Set
  PokemonHabitat habitatForTesting = kPokemonHabitatWatersEdge;
  
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"habitat == %d", habitatForTesting];
  [fetchRequest setPredicate:predicate];
  //  [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:@"", nil];
  
  NSError * error;
  NSArray * pokemons = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  [fetchRequest release];
  NSMutableArray * pokemonSIDsInArray = [NSMutableArray array];
  for (Pokemon *pokemon in pokemons)
    [pokemonSIDsInArray addObject:pokemon.sid];
  NSLog(@"!!!TESTING - PokemonSIDs:<< %@ >>, forType:%d",
        [pokemonSIDsInArray componentsJoinedByString:@","], habitatForTesting);
  // END For TESTING
  /*/
  
  
  NSString * pokemonSIDsInString;
  switch (habitat) {
    case kPokemonHabitatCave:
      pokemonSIDsInString = @"51,92,42,94,50,93,41,95";
      break;
      
    case kPokemonHabitatForest:
      pokemonSIDsInString = @"46,70,13,10,18,26,48,16,69,47,71,14,11,127,102,12,17,25,103,49,15";
      break;
      
    case kPokemonHabitatGrassland:
      pokemonSIDsInString = @"2,58,123,20,37,83,44,125,33,85,78,128,31,96,115,40,24,59,38,45,1,29,84,19,43,32,34,108,77,30,97,114,39,3,23";
      break;
      
    case kPokemonHabitatMountain:
      pokemonSIDsInString = @"105,68,56,35,74,76,104,67,5,142,126,57,36,75,4,6,143,66";
      break;
      
    case kPokemonHabitatRare:
      pokemonSIDsInString = @"144,145,151,146,150";
      break;
      
    case kPokemonHabitatRoughTerrain:
      pokemonSIDsInString = @"21,111,28,81,112,82,22,27";
      break;
      
    case kPokemonHabitatSea:
      pokemonSIDsInString = @"90,139,117,87,73,120,140,91,86,116,131,121,141,138,72";
      break;
      
    case kPokemonHabitatUrban:
      pokemonSIDsInString = @"133,63,107,135,101,110,122,52,137,89,132,109,64,106,65,124,113,53,136,134,88,100";
      break;
      
    case kPokemonHabitatWatersEdge:
      pokemonSIDsInString = @"9,80,119,147,54,61,130,149,98,7,148,79,118,55,62,129,8,99,60";
      break;
      
    default:
      pokemonSIDsInString = @"";
      break;
  }
  return [pokemonSIDsInString componentsSeparatedByString:@","];
}

#pragma mark - Basic Data

// Calculate EXP based on |baseEXP| with |level|
// y:return value:|result|
// x:|level|
//
// TODO:
//   The formular is not suit now!!
//
- (NSInteger)expAtLevel:(NSInteger)level {
  NSInteger result;
  result = (10000000 - 100) / (100 - 1) * level + [self.baseEXP intValue];
  return result;
}

// EXP to next level
- (NSInteger)expToNextLevel:(NSInteger)nextLevel {
  NSInteger result;
  result = [self expAtLevel:nextLevel] - [self expAtLevel:(nextLevel - 1)];
  return result;
}

@end
