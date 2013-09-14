//
//  WildPokemon+DataController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "WildPokemon+DataController.h"

#import "AppDelegate.h"
#import "Pokemon+DataController.h"


@interface WildPokemon (Private)

- (void)_calculateMaxStatsAndHP;
- (void)_calculateGender;
- (void)_calculateFourMovesAtLevel:(NSInteger)level;
- (void)_calculateExpAndToNextLevelWithCurrentLevel:(NSInteger)level;

@end

@implementation WildPokemon (DataController)

// Query a Wild Pokemon Data with UID
+ (WildPokemon *)queryPokemonDataWithUID:(NSInteger)pokemonUID {
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"uid == %d", pokemonUID];
  [fetchRequest setPredicate:predicate];
  //[fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:@"", nil];
  [fetchRequest setFetchLimit:1];
  
  NSError * error = nil;
  WildPokemon * pokemon = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
  
  return pokemon;
}

// Query a Wild Pokemon Data wit SID
+ (WildPokemon *)queryPokemonDataWithSID:(NSInteger)pokemonSID {
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
  if (fetchLimit > 0) [fetchRequest setFetchLimit:fetchLimit];
  
  NSError * error;
  NSArray * pokemons = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  
  return pokemons;
}

// Get unique Pokemons that in |pokemonSIDs| array (for generate Wild Pokemon),
//   i.e. one Pokemon match one SID
+ (NSArray *)queryUniquePokemonsWithSIDs:(NSArray *)pokemonSIDs
                              fetchLimit:(NSInteger)fetchLimit {
  NSArray * pokemons = [self queryPokemonsWithSIDs:pokemonSIDs fetchLimit:0];
  
  // If fetch Pokemons number is less than |fetchLimit|,
  //   no need to filter the array, just return nil
  if ([pokemons count] < fetchLimit) {
    NSLog(@"[pokemons count] < fetchLimit");
    pokemons = nil;
    return nil;
  }
  
  // Filter the |pokemons| to get unique array
  NSMutableArray * uniquePokemons = [NSMutableArray arrayWithCapacity:fetchLimit];
  for (id SID in pokemonSIDs)
    for (WildPokemon *pokemon in pokemons)
      if ([pokemon.sid intValue] == [SID intValue])
        [uniquePokemons addObject:pokemon];
  pokemons = nil;
  return uniquePokemons;
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

// Update data for different |level|
- (void)updateToLevel:(NSInteger)level {
  self.level = [NSNumber numberWithInt:level];
  [self _calculateGender];
  [self _calculateMaxStatsAndHP];
  [self _calculateFourMovesAtLevel:level];
  [self _calculateExpAndToNextLevelWithCurrentLevel:level];
}

#pragma mark - Private Methods

// Calculate |gender| based on |pokemonGenderRate|
// 0:Female 1:Male 2:Genderless
- (void)_calculateGender {
  PokemonGenderRate pokemonGenderRate = [self.pokemon.genderRate intValue];
  NSInteger gender;
  if      (pokemonGenderRate == kPokemonGenderRateAlwaysFemale) gender = 0;
  else if (pokemonGenderRate == kPokemonGenderRateAlwaysMale)   gender = 1;
  else if (pokemonGenderRate == kPokemonGenderRateGenderless)   gender = 2;
  else {
    float randomValue = arc4random() % 1000 / 10; // Random value for calculating
    float genderRate = 25 * ((pokemonGenderRate == kPokemonGenderRateFemaleOneEighth) ? .5f : (pokemonGenderRate - 2));
    gender = randomValue < genderRate ? 0 : 1;
  }
  self.gender = [NSNumber numberWithInt:gender];
}

// Calculation FORMULA
//
//   Health Points:
//
//     ((IV + 2 * BaseStat + (EV/4) ) * Level/100 ) + 10 + Level
//
//   Attack, Defense, Speed, Sp. Attack, Sp. Defense:
//
//     (((IV + 2 * BaseStat + (EV/4) ) * Level/100 ) + 5) * Nature Value
//
- (void)_calculateMaxStatsAndHP {
  // Formula effects
  double IV          = 0; // IV.(Individual Values) TODO!!!!!!
  double EV          = 1; // EV.(Effort Values)     TODO!!!!!!
  double level       = [self.level doubleValue];
  double natureValue = 1; // Natures.               TODO!!!!
  // base stats
  NSArray * baseStats = [self.pokemon.baseStats componentsSeparatedByString:@","];
  NSInteger statHP        = [[baseStats objectAtIndex:0] intValue];
  NSInteger statAttack    = [[baseStats objectAtIndex:1] intValue];
  NSInteger statDefense   = [[baseStats objectAtIndex:2] intValue];
  NSInteger statSpAttack  = [[baseStats objectAtIndex:3] intValue];
  NSInteger statSpDefense = [[baseStats objectAtIndex:4] intValue];
  NSInteger statSpeed     = [[baseStats objectAtIndex:5] intValue];
  baseStats = nil;
  
  // Do calculation
  //   FORMULA
  //   Health Points: ((IV + 2 * BaseStat + (EV/4) ) * Level/100 ) + 10 + Level
  statHP = ((IV + 2.f * statHP + (EV / 4.f)) * level / 100.f) + 10.f + level;
  //   Attack, Defense, Speed, Sp. Attack, Sp. Defense:
  //     (((IV + 2 * BaseStat + (EV/4) ) * Level/100 ) + 5) * Nature Value
  statAttack    = round((((IV + 2 * statAttack    + (EV / 4.f)) * level / 100.f) + 5.f) * natureValue);
  statDefense   = round((((IV + 2 * statDefense   + (EV / 4.f)) * level / 100.f) + 5.f) * natureValue);
  statSpAttack  = round((((IV + 2 * statSpAttack  + (EV / 4.f)) * level / 100.f) + 5.f) * natureValue);
  statSpDefense = round((((IV + 2 * statSpDefense + (EV / 4.f)) * level / 100.f) + 5.f) * natureValue);
  statSpeed     = round((((IV + 2 * statSpeed     + (EV / 4.f)) * level / 100.f) + 5.f) * natureValue);
  
  // Save stats
  self.maxStats = [NSString stringWithFormat:@"%d,%d,%d,%d,%d,%d",
                   statHP, statAttack, statDefense, statSpAttack, statSpDefense, statSpeed];
  self.hp       = [NSNumber numberWithInt:statHP];
}

// Calculate |fourMoves| based on |moves| & |leve|
- (void)_calculateFourMovesAtLevel:(NSInteger)level {
  NSArray * moves = [self.pokemon.moves componentsSeparatedByString:@","];
  NSInteger moveCount = [moves count];
  // Get the last learned Move index
  NSInteger lastLearnedMoveIndex = 0;
  NSMutableArray * fourMovesID = [[NSMutableArray alloc] init];
  for (int i = 0; i < moveCount - 1; i += 2) {
    if ([[moves objectAtIndex:i] intValue] > level)
      break;
    // Remove the first Move when there're four Moves learned
    if ([fourMovesID count] == 4)
      [fourMovesID removeObjectAtIndex:0];
    // Push new Move ID
    [fourMovesID addObject:[moves objectAtIndex:(i + 1)]];
    ++lastLearnedMoveIndex;
  }
  // Fetch |fourMoves| with |fourMovesID|
  NSArray * fourMoves = [Move queryFourMovesDataWithIDs:fourMovesID];
  
  NSMutableString * fourMovesInString = [NSMutableString string];
  moveCount = 0;
  for (Move * move in fourMoves) {
    if (moveCount != 0) [fourMovesInString appendString:@","];
    ++moveCount;
    [fourMovesInString appendString:[NSString stringWithFormat:@"%d,%d,%d",
                                     [move.sid intValue], [move.basePP intValue], [move.basePP intValue]]];
  }
  fourMoves = nil;
  self.fourMoves = fourMovesInString;
}

// Calculate |exp| & |toNextLevel| for current |level|
- (void)_calculateExpAndToNextLevelWithCurrentLevel:(NSInteger)level {
  self.exp         = [NSNumber numberWithInt:[self.pokemon expAtLevel:level]];
  self.toNextLevel = [NSNumber numberWithInt:[self.pokemon expToNextLevel:(level + 1)]];
}

@end
