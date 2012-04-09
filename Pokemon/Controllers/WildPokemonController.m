//
//  WildPokemonController.m
//  Pokemon
//
//  Created by Kaijie Yu on 4/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "WildPokemonController.h"

#import "GlobalConstants.h"
#import "PokemonConstants.h"
#import "PokemonServerAPI.h"
#import "AppDelegate.h"
#import "WildPokemon.h"
#import "Pokemon+DataController.h"
#import "Move+DataController.h"
#import "ServerAPIClient.h"

#import "AFJSONRequestOperation.h"


@interface WildPokemonController () {
 @private
  
}

- (void)updateWildPokemon:(WildPokemon *)wildPokemon withData:(NSDictionary *)data;
- (NSNumber *)calculateGenderWithPokemonGenderRate:(PokemonGenderRate)pokemonGenderRate;
- (NSString *)calculateFourMovesWithMoves:(NSArray *)moves level:(NSInteger)level;
- (NSString *)calculateStatsWithBaseStats:(NSArray *)baseStats level:(NSInteger)level;
- (NSInteger)calculateEXPWithBaseEXP:(NSInteger)baseEXP level:(NSInteger)level;

@end


@implementation WildPokemonController

// Singleton
static WildPokemonController * wildPokemonController_ = nil;
+ (WildPokemonController *)sharedInstance {
  if (wildPokemonController_ != nil)
    return wildPokemonController_;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    wildPokemonController_ = [[WildPokemonController alloc] init];
  });
  return wildPokemonController_;
}

- (id)init {
  if (self = [super init]) {
  }
  return self;
}

#pragma mark - Public Methods

- (void)updateForCurrentRegion {
  // Success Block Method
  void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id JSON) {
    // Get JSON Data Array from HTTP Response
    NSArray * wildPokemons = [JSON valueForKey:@"wildpokemons"];
    
    NSManagedObjectContext * managedObjectContext =
      [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError * error;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([WildPokemon class])
                                        inManagedObjectContext:managedObjectContext]];
    [fetchRequest setFetchLimit:1];
    // Update the data for |WildPokemon|
    for (NSDictionary * wildPokemonData in wildPokemons) {
      // Check the existence of the entity
      // If exist, execute fetching request, otherwise, insert new one
      WildPokemon * wildPokemon;
      [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"uid == %@", [wildPokemonData valueForKey:@"uid"]]];
      if ([managedObjectContext countForFetchRequest:fetchRequest error:&error])
        wildPokemon = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
      else wildPokemon = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([WildPokemon class])
                                                       inManagedObjectContext:managedObjectContext];
      // Update data for current |wildPokemon|
      [self updateWildPokemon:wildPokemon withData:wildPokemonData];
    }
    [fetchRequest release];
    
    if (! [managedObjectContext save:&error])
      NSLog(@"!!! Couldn't save data to %@", NSStringFromClass([WildPokemon class]));
    NSLog(@"...Update |%@| data done...", [WildPokemon class]);
  };
  
  // Failure Block Method
  void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"!!! ERROR: %@", error);
  };
  
  // Update data via |ServerAPIClient|
  [[ServerAPIClient sharedInstance] updateWildPokemonsForCurrentRegionSuccess:success failure:failure];
}

#pragma mark - Private Methods

// Update data for WildPokemon entity
- (void)updateWildPokemon:(WildPokemon *)wildPokemon withData:(NSDictionary *)data {
  // Update basic data fetched from server
  wildPokemon.uid         = [data valueForKey:@"uid"];
  wildPokemon.sid         = [data valueForKey:@"sid"];
  wildPokemon.status      = [NSNumber numberWithInt:kPokemonStatusNormal];
  wildPokemon.level       = [data valueForKey:@"level"];
  NSInteger level = [wildPokemon.level intValue];
  
  // Fetch Pokemon entity with |sid|
  Pokemon * pokemon = [Pokemon queryPokemonDataWithID:[[data valueForKey:@"sid"] intValue]];
  wildPokemon.pokemon = pokemon; // Relationship betweent Pokemon & WildPokemon
  
  // |gender|
  wildPokemon.gender = [self calculateGenderWithPokemonGenderRate:[pokemon.genderRate intValue]];
  
  // |fourMoves|
  wildPokemon.fourMoves = [self calculateFourMovesWithMoves:[pokemon.moves componentsSeparatedByString:@","] level:level];
  
  // |maxStats| & |hp|
  NSString * maxStats  = [self calculateStatsWithBaseStats:[pokemon.baseStats componentsSeparatedByString:@","] level:level];
  wildPokemon.maxStats = maxStats;
  wildPokemon.hp       = [NSNumber numberWithInt:[[[maxStats componentsSeparatedByString:@","] objectAtIndex:0] intValue]];
  maxStats = nil;
  
  // |exp| & |toNextLevel|
  // Calculate EXP based on Level Formular with value:|level|
  NSInteger baseEXP       = [pokemon.baseEXP intValue];
  NSInteger currEXP       = [self calculateEXPWithBaseEXP:baseEXP level:level];
  NSInteger nextLevelEXP  = [self calculateEXPWithBaseEXP:baseEXP level:(level + 1)];
  wildPokemon.exp         = [NSNumber numberWithInt:currEXP];
  wildPokemon.toNextLevel = [NSNumber numberWithInt:(nextLevelEXP - currEXP)];
  
  pokemon = nil;
}

// Calculate |gender| based on |pokemonGenderRate|
// 0:Female 1:Male 2:Genderless
- (NSNumber *)calculateGenderWithPokemonGenderRate:(PokemonGenderRate)pokemonGenderRate {
  NSInteger gender;
  if      (pokemonGenderRate == kPokemonGenderRateAlwaysFemale) gender = 0;
  else if (pokemonGenderRate == kPokemonGenderRateAlwaysMale)   gender = 1;
  else if (pokemonGenderRate == kPokemonGenderRateGenderless)   gender = 2;
  else {
    float randomValue = arc4random() % 1000 / 10; // Random value for calculating
    float genderRate = 25 * ((pokemonGenderRate == kPokemonGenderRateFemaleOneEighth) ? .5f : (pokemonGenderRate - 2));
    gender = randomValue < genderRate ? 0 : 1;
  }
  return [NSNumber numberWithInt:gender];
}

// Calculate |fourMoves| based on |moves| & |leve|
- (NSString *)calculateFourMovesWithMoves:(NSArray *)moves level:(NSInteger)level {
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
  [fourMovesID release];
  
  NSMutableString * fourMovesInString = [NSMutableString string];
  moveCount = 0;
  for (Move * move in fourMoves) {
    if (moveCount != 0) [fourMovesInString appendString:@","];
    ++moveCount;
    [fourMovesInString appendString:[NSString stringWithFormat:@"%d,%d,%d",
                                     [move.sid intValue], [move.basePP intValue], [move.basePP intValue]]];
  }
  fourMoves = nil;
  return fourMovesInString;
}

// Calculate |stats| based on |baseStats|
- (NSString *)calculateStatsWithBaseStats:(NSArray *)baseStats level:(NSInteger)level {
  NSInteger statHP        = [[baseStats objectAtIndex:0] intValue];
  NSInteger statAttack    = [[baseStats objectAtIndex:1] intValue];
  NSInteger statDefense   = [[baseStats objectAtIndex:2] intValue];
  NSInteger statSpAttack  = [[baseStats objectAtIndex:3] intValue];
  NSInteger statSpDefense = [[baseStats objectAtIndex:4] intValue];
  NSInteger statSpeed     = [[baseStats objectAtIndex:5] intValue];
  
  // Calculate the stats
  statHP        += 3 * level;
  statAttack    += level;
  statDefense   += level;
  statSpAttack  += level;
  statSpDefense += level;
  statSpeed     += level;
  
  return [NSString stringWithFormat:@"%d,%d,%d,%d,%d,%d",
          statHP, statAttack, statDefense, statSpAttack, statSpDefense, statSpeed];
}

// Calculate EXP based on |baseEXP| with |level|
// y:return value:|result|
// x:|level|
//
// TODO:
//   The formular is not suit now!!
//
- (NSInteger)calculateEXPWithBaseEXP:(NSInteger)baseEXP level:(NSInteger)level {
  NSInteger result;
  result = (10000000 - 100) / (100 - 1) * level + baseEXP;
  return result;
}

@end
