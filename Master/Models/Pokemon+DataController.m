//
//  Pokemon+DataController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/17/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "Pokemon+DataController.h"

#import "AppDelegate.h"
#import "PListParser.h"
#import "LoadingManager.h"
#import "ServerAPIClient.h"


@interface Pokemon (Private)

- (MoveDamageEffect)_combineMoveDamageEffect:(MoveDamageEffect)moveDamageEffect
                 withAnotherMoveDamageEffect:(MoveDamageEffect)anotherMoveDamageEffect;
- (MoveDamageEffect)_moveDamageEffectBetweenType:(PokemonType)type
                                 andOpponentType:(PokemonType)opponentType;

@end

@implementation Pokemon (DataController)

#pragma mark - Hard Initialize the DB data

// Hard Update the DB data
+ (void)hardUpdateData {
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:@"Pokemon"
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSError * error;
  NSArray * pokemons = [managedObjectContext executeFetchRequest:fetchRequest
                                                           error:&error];
  
  // Set Data
  NSArray * pokedex = [PListParser pokedexInBundle:[NSBundle mainBundle]];
  
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

// update area data for all PMs
+ (void)updateAreaForAll {
  // Success Block Method
  void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id JSON) {
    // Get JSON Data Array from HTTP Response
    //
    // pma: PokeMon Area
    // data format: "<SID>=<latitude>,<longitude>:<latitude>,<longitude>:..."
    //
    // {
    //   'pma':[
    //           "1=30.123,31.123:28.123,29.123:...",
    //           ...
    //         ]
    // }
    if ([[JSON valueForKey:@"pma"] isKindOfClass:[NSNull class]]) {
      NSLog(@"...SYNC Pokemon Area Data from SERVER DONE...NO Data");
      // Hide loading
      [[LoadingManager sharedInstance] hideOverBar];
      return;
    }
    
    // Parse data from JSON
    // e.g. "CN:ZJ:HZ=Zhejiang Province=Hangzhou City"
    NSArray * pma = [JSON valueForKey:@"pma"];
    NSLog(@"Pulled Pokemon Area Data : SERVER => CLIENT::%@", pma);
    
    // start to update regions
    NSManagedObjectContext * managedObjectContext =
      [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError * error;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class])
                                        inManagedObjectContext:managedObjectContext]];
    [fetchRequest setFetchLimit:1];
    for (NSString * pokemonArea in pma) {
      NSArray * data = [pokemonArea componentsSeparatedByString:@"="];
      
      // Update the data for model:|Pokemon|
      Pokemon * pokemon;
      // Check the existence of the object
      //   If exist, execute fetching request, otherwise, insert new object
      [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"sid == %d", [[data objectAtIndex:0] intValue]]];
      if ([managedObjectContext countForFetchRequest:fetchRequest error:&error])
        pokemon = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
      else continue;
      
      // update area data for PM
      pokemon.area = [data objectAtIndex:1];
    }
    
    if (! [managedObjectContext save:&error])
      NSLog(@"!!! Couldn't save data to %@", NSStringFromClass([self class]));
    NSLog(@"...Update |%@| data done...", [self class]);
    
    // Hide loading
    [[LoadingManager sharedInstance] hideOverBar];
  };
  
  // Failure Block Method
  void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError * error) {
    NSLog(@"!!! ERROR: %@", error);
    // Hide loading
    [[LoadingManager sharedInstance] hideOverBar];
  };
  
  // Show loading
  [[LoadingManager sharedInstance] showOverBar];
  // Fetch data from server & populate the |teamedPokemon|
  [[ServerAPIClient sharedInstance] fetchDataFor:kDataFetchTargetAllPokemonsArea
                                      withObject:nil
                                         success:success
                                         failure:failure];
}

// get area data for single PM
- (void)getAreaCompletion:(void (^)(BOOL finished))completion {
  // Success Block Method
  void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id JSON) {
    // Get JSON Data Array from HTTP Response
    //
    // pma: PokeMon Area
    // data format: "<latitude>,<longitude>:<latitude>,<longitude>:..."
    //
    // {
    //   'pma':"1=30.123,31.123:28.123,29.123:..."
    // }
    if ([[JSON valueForKey:@"pma"] isKindOfClass:[NSNull class]]) {
      NSLog(@"...SYNC Pokemon Area Data from SERVER DONE...NO Data");
      // Hide loading
      [[LoadingManager sharedInstance] hideOverBar];
      return;
    }
    
    // start to update regions
    NSManagedObjectContext * managedObjectContext =
      [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError * error;
    
    // update area data for PM
    NSLog(@"Pulled Pokemon Area Data : SERVER => CLIENT::%@", [JSON valueForKey:@"pma"]);
    self.area = [JSON valueForKey:@"pma"];
    
    if (! [managedObjectContext save:&error])
      NSLog(@"!!! Couldn't save data to %@", NSStringFromClass([self class]));
    NSLog(@"...Update |%@| data done...", [self class]);
    
    // Hide loading
    [[LoadingManager sharedInstance] hideOverBar];
    
    // execute the |completion| block
    completion(YES);
  };
  
  // Failure Block Method
  void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError * error) {
    NSLog(@"!!! ERROR: %@", error);
    // Hide loading
    [[LoadingManager sharedInstance] hideOverBar];
  };
  
  // Show loading
  [[LoadingManager sharedInstance] showOverBar];
  // Fetch data from server & populate the |teamedPokemon|
  [[ServerAPIClient sharedInstance] fetchDataFor:kDataFetchTargetPokemonArea
                                      withObject:self.sid
                                         success:success
                                         failure:failure];
}

#pragma mark - Pokemon Data Query Mthods

// Get data from model
+ (NSArray *)queryAllData {
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSError * error;
  NSArray * fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest
                                                                 error:&error];
  
  return fetchedObjects;
}

// Get data of one Pokemon
+ (Pokemon *)queryPokemonDataWithSID:(NSInteger)pokemonSID {
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
  Pokemon * pokemon = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
  
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

// Calculate EXP
//
// y:return value:|result|
// x:|level|
//
// following numbers are for pokemon at level 100.
//   
//    |TYPE        |MAX           |FORMULAR
//    Fast:        800,000   EXP  0.8(Current Level)^3
//    Medium-Fast: 1,000,000 EXP  (Current Level)^3
//    Slow:        1,250,000 EXP  1.25(Current Level)^3
//    Medium-Slow: 1,059,860 EXP  1.2(Current Level)^3 - 15(Current Level)^2 + 100(Current Level) - 140
//    Erratic:     600,000   EXP  unknown
//    Fluctuating: 1,640,000 EXP  unknown
//
- (NSInteger)expAtLevel:(NSInteger)level {
  double result = 0;
  
  switch ([self.growthRate intValue]) {
    case kPokemonGrowthRateFast:
      result = .8f * pow(level, 3);
      break;
      
    case kPokemonGrowthRateMedium:
      result = pow(level, 3);
      break;
      
    case kPokemonGrowthRateSlow:
      result = 1.25f * pow(level, 3);
      break;
      
    case kPokemonGrowthRateParabolic:
      result = 1.2f * pow(level, 3) - 15.f * pow(level, 2) + 100.f * level - 140.f;
      break;
      
    case kPokemonGrowthRateErratic:     // UNKNOWN TODO!!!
      result = 1.25f * pow(level, 3);
      break;
      
    case kPokemonGrouthRateFluctuating: // UNKNOWN TDOO!!!
      result = 1.25f * pow(level, 3);
      break;
      
    default:
      break;
  }
  return (NSInteger)round(result);
}

// EXP to next level
- (NSInteger)expToNextLevel:(NSInteger)nextLevel {
  NSInteger result;
  result = [self expAtLevel:nextLevel] - [self expAtLevel:(nextLevel - 1)];
  return result;
}

// Move damage effect on opponent's type
- (double)moveDamageEffectOnOpponentPokemon:(Pokemon *)opponentPokemon {
  MoveDamageEffect moveDamageEffect;
  PokemonType type1 = [self.type1 intValue];
  PokemonType type2 = [self.type2 intValue];
  PokemonType opponentType1 = [opponentPokemon.type1 intValue];
  PokemonType opponentType2 = [opponentPokemon.type2 intValue];
  
  moveDamageEffect = [self _moveDamageEffectBetweenType:type1 andOpponentType:opponentType1];
  if (type2)
    moveDamageEffect = [self _combineMoveDamageEffect:moveDamageEffect
                          withAnotherMoveDamageEffect:[self _moveDamageEffectBetweenType:type2
                                                                         andOpponentType:opponentType1]];
  // If opponent PM has |type2|, do calculation for it
  if (opponentType2) {
    moveDamageEffect = [self _combineMoveDamageEffect:moveDamageEffect
                          withAnotherMoveDamageEffect:[self _moveDamageEffectBetweenType:type1
                                                                         andOpponentType:opponentType2]];
    if (type2)
      moveDamageEffect = [self _combineMoveDamageEffect:moveDamageEffect
                            withAnotherMoveDamageEffect:[self _moveDamageEffectBetweenType:type2
                                                                           andOpponentType:opponentType2]];
  }
  
  // Fix value
  if (moveDamageEffect < kMoveDamageEffectQuarter)
    moveDamageEffect = kMoveDamageEffectNo;
  if (moveDamageEffect > kMoveDamageEffect4x)
    moveDamageEffect = kMoveDamageEffect4x;
  
  // Get the STAB based on move damage effect
  double stab;
  switch (moveDamageEffect) {
    case kMoveDamageEffectNo:
      return 0;
      break;
      
    case kMoveDamageEffectQuarter:
      stab = .25f;
      break;
      
    case kMoveDamageEffectHalf:
      stab = .5f;
      break;
      
    case kMoveDamageEffect2x:
      stab = 2;
      break;
      
    case kMoveDamageEffect4x:
      stab = 4;
      break;
      
    case kMoveDamageEffect1x:
    default:
      stab = 1;
      break;
  }
  return stab;
}

#pragma mark - Private Methods

// Combine two move damage effects
- (MoveDamageEffect)_combineMoveDamageEffect:(MoveDamageEffect)moveDamageEffect
                 withAnotherMoveDamageEffect:(MoveDamageEffect)anotherMoveDamageEffect {
  switch (anotherMoveDamageEffect) {
    case kMoveDamageEffectNo:
      moveDamageEffect = kMoveDamageEffectNo;
      break;
      
    case kMoveDamageEffectQuarter:
      moveDamageEffect >>= 2;
      break;
      
    case kMoveDamageEffectHalf:
      moveDamageEffect >>= 1;
      break;
      
    case kMoveDamageEffect2x:
      moveDamageEffect <<= 1;
      break;
      
    case kMoveDamageEffect4x:
      moveDamageEffect <<= 2;
      break;
      
    case kMoveDamageEffect1x:
    default:
      break;
  }
  return moveDamageEffect;
}

// Move damage effect between two type of Pokemon
- (MoveDamageEffect)_moveDamageEffectBetweenType:(PokemonType)type
                                 andOpponentType:(PokemonType)opponentType {
  switch (type) {
    case kPokemonTypeNormal:
      if (opponentType == kPokemonTypeGhost)
        return kMoveDamageEffectNo;
      else if (opponentType == kPokemonTypeRock || opponentType == kPokemonTypeSteel)
        return kMoveDamageEffectHalf;
      else
        return kMoveDamageEffect1x;
      break;
      
    case kPokemonTypeFire:
      if (opponentType == kPokemonTypeFire  ||
          opponentType == kPokemonTypeWater ||
          opponentType == kPokemonTypeRock  ||
          opponentType == kPokemonTypeDragon)
        return kMoveDamageEffectHalf;
      else if (opponentType == kPokemonTypeGrass ||
               opponentType == kPokemonTypeIce   ||
               opponentType == kPokemonTypeBug   ||
               opponentType == kPokemonTypeSteel)
        return kMoveDamageEffect2x;
      else
        return kMoveDamageEffect1x;
      break;
      
    case kPokemonTypeWater:
      if (opponentType == kPokemonTypeWater ||
          opponentType == kPokemonTypeGrass ||
          opponentType == kPokemonTypeDragon)
        return kMoveDamageEffectHalf;
      else if (opponentType == kPokemonTypeFire   ||
               opponentType == kPokemonTypeGround ||
               opponentType == kPokemonTypeRock)
        return kMoveDamageEffect2x;
      else
        return kMoveDamageEffect1x;
      break;
      
    case kPokemonTypeElectric:
      if (opponentType == kPokemonTypeGround)
        return kMoveDamageEffectNo;
      else if (opponentType == kPokemonTypeFire) {
      }
      else if (opponentType == kPokemonTypeElectric ||
               opponentType == kPokemonTypeGrass    ||
               opponentType == kPokemonTypeDragon)
        return kMoveDamageEffectHalf;
      else if (opponentType == kPokemonTypeWater ||
               opponentType == kPokemonTypeFlying)
        return kMoveDamageEffect2x;
      else
        return kMoveDamageEffect1x;
      break;
      
    case kPokemonTypeGrass:
      if (opponentType == kPokemonTypeFire   ||
          opponentType == kPokemonTypeGrass  ||
          opponentType == kPokemonTypePoison ||
          opponentType == kPokemonTypeFlying ||
          opponentType == kPokemonTypeBug    ||
          opponentType == kPokemonTypeDragon ||
          opponentType == kPokemonTypeSteel)
        return kMoveDamageEffectHalf;
      else if (opponentType == kPokemonTypeWater  ||
               opponentType == kPokemonTypeGround ||
               opponentType == kPokemonTypeRock)
        return kMoveDamageEffect2x;
      else
        return kMoveDamageEffect1x;
      break;
      
    case kPokemonTypeIce:
      if (opponentType == kPokemonTypeFire  ||
          opponentType == kPokemonTypeWater ||
          opponentType == kPokemonTypeIce   ||
          opponentType == kPokemonTypeSteel)
        return kMoveDamageEffectHalf;
      else if (opponentType == kPokemonTypeGrass  ||
               opponentType == kPokemonTypeGround ||
               opponentType == kPokemonTypeFlying ||
               opponentType == kPokemonTypeDragon)
        return kMoveDamageEffect2x;
      else
        return kMoveDamageEffect1x;
      break;
      
    case kPokemonTypeFighting:
      if (opponentType == kPokemonTypeGhost)
        return kMoveDamageEffectNo;
      else if (opponentType == kPokemonTypePoison  ||
               opponentType == kPokemonTypeFlying  ||
               opponentType == kPokemonTypePsychic ||
               opponentType == kPokemonTypeBug)
        return kMoveDamageEffectHalf;
      else if (opponentType == kPokemonTypeNormal ||
               opponentType == kPokemonTypeIce    ||
               opponentType == kPokemonTypeRock   ||
               opponentType == kPokemonTypeDark   ||
               opponentType == kPokemonTypeSteel)
        return kMoveDamageEffect2x;
      else
        return kMoveDamageEffect1x;
      break;
      
    case kPokemonTypePoison:
      if (opponentType == kPokemonTypeSteel)
        return kMoveDamageEffectNo;
      else if(opponentType == kPokemonTypePoison ||
              opponentType == kPokemonTypeGround ||
              opponentType == kPokemonTypeRock   ||
              opponentType == kPokemonTypeGhost)
        return kMoveDamageEffectHalf;
      else
        return kMoveDamageEffect1x;
      break;
      
    case kPokemonTypeGround:
      if (opponentType == kPokemonTypeFlying)
        return kMoveDamageEffectNo;
      else if (opponentType == kPokemonTypeGrass ||
               opponentType == kPokemonTypeBug)
        return kMoveDamageEffectHalf;
      else if (opponentType == kPokemonTypeFire     ||
               opponentType == kPokemonTypeElectric ||
               opponentType == kPokemonTypePoison   ||
               opponentType == kPokemonTypeRock     ||
               opponentType == kPokemonTypeSteel)
        return kMoveDamageEffect2x;
      else
        return kMoveDamageEffect1x;
      break;
      
    case kPokemonTypeFlying:
      if (opponentType == kPokemonTypeElectric ||
          opponentType == kPokemonTypeRock     ||
          opponentType == kPokemonTypeSteel)
        return kMoveDamageEffectHalf;
      else if (opponentType == kPokemonTypeGrass    ||
               opponentType == kPokemonTypeFighting ||
               opponentType == kPokemonTypeBug)
        return kMoveDamageEffect2x;
      else
        return kMoveDamageEffect1x;
      break;
      
    case kPokemonTypePsychic:
      if (opponentType == kPokemonTypeDark)
        return kMoveDamageEffectNo;
      else if (opponentType == kPokemonTypePsychic ||
               opponentType == kPokemonTypeSteel)
        return kMoveDamageEffectHalf;
      else if (opponentType == kPokemonTypeFighting ||
               opponentType == kPokemonTypePoison)
        return kMoveDamageEffect2x;
      else
        return kMoveDamageEffect1x;
      break;
      
    case kPokemonTypeBug:
      if (opponentType == kPokemonTypeFire     ||
          opponentType == kPokemonTypeFighting ||
          opponentType == kPokemonTypePoison   ||
          opponentType == kPokemonTypeFlying   ||
          opponentType == kPokemonTypeGhost    ||
          opponentType == kPokemonTypeSteel)
        return kMoveDamageEffectHalf;
      else if (opponentType == kPokemonTypeGrass   ||
               opponentType == kPokemonTypePsychic ||
               opponentType == kPokemonTypeDark)
        return kMoveDamageEffect2x;
      else
        return kMoveDamageEffect1x;
      break;
      
    case kPokemonTypeRock:
      if (opponentType == kPokemonTypeFighting ||
          opponentType == kPokemonTypeGround   ||
          opponentType == kPokemonTypeSteel)
        return kMoveDamageEffectHalf;
      else if (opponentType == kPokemonTypeFire   ||
               opponentType == kPokemonTypeIce    ||
               opponentType == kPokemonTypeFlying ||
               opponentType == kPokemonTypeBug)
        return kMoveDamageEffect2x;
      else
        return kMoveDamageEffect1x;
      break;
      
    case kPokemonTypeGhost:
      if (opponentType == kPokemonTypeNormal)
        return kMoveDamageEffectNo;
      else if (opponentType == kPokemonTypeDark ||
               opponentType == kPokemonTypeSteel)
        return kMoveDamageEffectHalf;
      else if (opponentType == kPokemonTypePsychic ||
               opponentType == kPokemonTypeGhost)
        return kMoveDamageEffect2x;
      else
        return kMoveDamageEffect1x;
      break;
      
    case kPokemonTypeDragon:
      if (opponentType == kPokemonTypeSteel)
        return kMoveDamageEffectHalf;
      else if (opponentType == kPokemonTypeDragon)
        return kMoveDamageEffect2x;
      else
        return kMoveDamageEffect1x;
      break;
      
    case kPokemonTypeDark:
      if (opponentType == kPokemonTypeFighting ||
          opponentType == kPokemonTypeDark     ||
          opponentType == kPokemonTypeSteel)
        return kMoveDamageEffectHalf;
      else if (opponentType == kPokemonTypePsychic ||
               opponentType == kPokemonTypeGhost)
        return kMoveDamageEffect2x;
      else
        return kMoveDamageEffect1x;
      break;
      
    case kPokemonTypeSteel:
      if (opponentType == kPokemonTypeFire     ||
          opponentType == kPokemonTypeWater    ||
          opponentType == kPokemonTypeElectric ||
          opponentType == kPokemonTypeSteel)
        return kMoveDamageEffectHalf;
      else if (opponentType == kPokemonTypeIce ||
               opponentType == kPokemonTypeRock)
        return kMoveDamageEffect2x;
      else
        return kMoveDamageEffect1x;
      break;
      
    default:
      return kMoveDamageEffect1x;
      break;
  }
  return kMoveDamageEffect1x;
}

@end
