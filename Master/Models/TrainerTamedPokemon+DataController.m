//
//  TrainerTamedPokemon+DataController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/21/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "TrainerTamedPokemon+DataController.h"

#import "AppDelegate.h"
#import "ServerAPIClient.h"
#import "TrainerController.h"
#import "Trainer+DataController.h"
#import "LoadingManager.h"


@implementation TrainerTamedPokemon (DataController)

// Update |TrainerTamedPokemon|
+ (void)initWithTrainer:(Trainer *)trainer
             completion:(void (^)())completion {
  if (trainer == nil)
    return;
  
  // Show loading
  [[LoadingManager sharedInstance] showOverBar];
  
  // Success Block Method
  void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id JSON) {
    // Get JSON Data Array from HTTP Response
    // {'pd':[...]} // pd:PokeDex
    if ([[JSON valueForKey:@"pd"] isKindOfClass:[NSNull class]]) {
      NSLog(@"...Update |%@| data done...NO Pokemon Data", [self class]);
      // Hide loading
      [[LoadingManager sharedInstance] hideOverBar];
      // Execute the |completion| block
      completion();
      return;
    }
    
    NSManagedObjectContext * managedObjectContext =
      [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    // Parse data from JSON
    NSArray * tamedPokemonGroup = [JSON valueForKey:@"pd"];
    NSLog(@"|tamedPokemonGroup| SERVER => CLIENT::%@", tamedPokemonGroup);
    
    NSError * error;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class])
                                        inManagedObjectContext:managedObjectContext]];
    [fetchRequest setFetchLimit:1];
    
    // Update the data for |tamedPokemmon|
    for (NSDictionary * tamedPokemonData in tamedPokemonGroup) {
      TrainerTamedPokemon * tamedPokemon;
      
      // UID for Pokemon
      NSInteger uid = [[tamedPokemonData valueForKey:@"uid"] intValue];
      
      // Check the existence of the object
      // If exist, execute fetching request, otherwise, insert new object
      [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"uid == %d", uid]];
      if ([managedObjectContext countForFetchRequest:fetchRequest error:&error])
        tamedPokemon = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
      else {
        tamedPokemon = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                                     inManagedObjectContext:managedObjectContext];
        NSInteger sid = [[tamedPokemonData valueForKey:@"sid"] intValue];
        
        // Set fixed base data for new one
        tamedPokemon.uid     = [NSNumber numberWithInt:uid];
        tamedPokemon.sid     = [NSNumber numberWithInt:sid];
        tamedPokemon.gender  = [NSNumber numberWithInt:[[tamedPokemonData valueForKey:@"gender"] intValue]];
        
        // Set relationships
        tamedPokemon.owner   = trainer;
        tamedPokemon.pokemon = [Pokemon queryPokemonDataWithSID:sid];
      }
      
      // Update base data
      tamedPokemon.box         = [NSNumber numberWithInt:[[tamedPokemonData valueForKey:@"box"] intValue]];
      tamedPokemon.status      = [NSNumber numberWithInt:[[tamedPokemonData valueForKey:@"status"] intValue]];
      tamedPokemon.happiness   = [NSNumber numberWithInt:[[tamedPokemonData valueForKey:@"happiness"] intValue]];
      tamedPokemon.level       = [NSNumber numberWithInt:[[tamedPokemonData valueForKey:@"level"] intValue]];
      tamedPokemon.fourMoves   = [tamedPokemonData valueForKey:@"fourMoves"];
      tamedPokemon.maxStats    = [tamedPokemonData valueForKey:@"maxStats"];
      tamedPokemon.hp          = [NSNumber numberWithInt:[[tamedPokemonData valueForKey:@"hp"] intValue]];
      tamedPokemon.exp         = [NSNumber numberWithInt:[[tamedPokemonData valueForKey:@"exp"] intValue]];
      tamedPokemon.toNextLevel = [NSNumber numberWithInt:[[tamedPokemonData valueForKey:@"toNextLevel"] intValue]];
      tamedPokemon.memo        = [tamedPokemonData valueForKey:@"memo"];
    }
    
    if (! [managedObjectContext save:&error])
      NSLog(@"!!! Couldn't save data to %@", NSStringFromClass([self class]));
    NSLog(@"...Update |%@| data done...", [self class]);
    
    // Hide loading
    [[LoadingManager sharedInstance] hideOverBar];
    
    // Execute the |completion| block
    completion();
  };
  
  // Failure Block Method
  void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError * error) {
    NSLog(@"!!! ERROR: %@", error);
    // Hide loading
    [[LoadingManager sharedInstance] hideOverBar];
    // Execute the |completion| block
    completion();
  };
  
  // Fetch data from server & populate the |teamedPokemon|
  [[ServerAPIClient sharedInstance] fetchDataFor:kDataFetchTargetTamedPokemon
                                      withObject:nil
                                         success:success
                                         failure:failure];
}

// CM: Sync data between Client & Server
+ (void)syncWithUserID:(NSInteger)userID
            pokemonUID:(NSInteger)pokemonUID
                  flag:(DataModifyFlag)flag {
  if (! (flag & kDataModifyTamedPokemon))
    return;
  [[self queryPokemonDataWithUID:pokemonUID trainerUID:userID] syncWithFlag:flag];
}

// IM: Sync data between Client & Server
- (void)syncWithFlag:(DataModifyFlag)flag {
  if (! (flag & kDataModifyTamedPokemon))
    return;
  
  // Show loading
  [[LoadingManager sharedInstance] showOverBar];
  
  NSLog(@"......SAVING DATA......");
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSError * error;
  if (! [managedObjectContext save:&error])
    NSLog(@"Couldn't save data to |%@|", NSStringFromClass([self class]));
  
  
  NSLog(@"......SYNC......");
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
    
    // Hide loading
    [[LoadingManager sharedInstance] hideOverBar];
  };
  void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"!!! Sync |%@| data failed ERROR: %@", [self class], error);
    // Hide loading
    [[LoadingManager sharedInstance] hideOverBar];
  };
  
  NSLog(@"Sync Data:%@", data);
  [[ServerAPIClient sharedInstance] updateData:data forTarget:kDataFetchTargetTamedPokemon success:success failure:failure];
}

#pragma mark -
#pragma mark - GET Data

// Get Six Pokemons that trainer brought
// State: 0 - Unknown; 1 - Seen; 2 - Caught; 3 - Brought; 4 - Foster Care.
+ (NSArray *)sixPokemonsForTrainer:(NSInteger)trainerID {
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class])
                                      inManagedObjectContext:managedObjectContext]];
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"owner.uid == %d", trainerID]];
  [fetchRequest setFetchLimit:6];
  
  NSError * error;
  NSArray * sixPokemons = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  
  return sixPokemons;
}

// Get pokemons that in pokemons ID array
+ (NSArray *)queryPokemonsWithUID:(NSArray *)pokemonsUID
                       trainerUID:(NSInteger)trainerUID
                       fetchLimit:(NSInteger)fetchLimit {
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class])
                                      inManagedObjectContext:managedObjectContext]];
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"owner.uid == %d AND uid IN %@", trainerUID, pokemonsUID]];
  [fetchRequest setFetchLimit:fetchLimit];
  
  NSError * error;
  NSArray * pokemons = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  
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
  NSInteger UID = [self numberOfTamedPokemonsWithTraienrUID:[trainer.uid intValue]] + 1;
  NSLog(@"New TamedPokemon UID:%d", UID);
  tamedPokemon.uid         = [NSNumber numberWithInt:UID];
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
  tamedPokemon.pokemon = [Pokemon queryPokemonDataWithSID:[wildPokemon.sid intValue]];
  
  NSError * error;
  if (! [managedObjectContext save:&error])
    NSLog(@"!!! Couldn't save data to |%@| :: %@", [self class], error);
  
  // Sync new Pokemon data to Server
  [tamedPokemon syncWithFlag:kDataModifyTamedPokemon
                            |kDataModifyTamedPokemonNew
                            |kDataModifyTamedPokemonBasic
                            |kDataModifyTamedPokemonExtra];
  tamedPokemon = nil;
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

// Current PPs & Max PPs
- (NSArray *)fourMovesPPInArray {
  NSMutableArray * fourMovesPP = [NSMutableArray arrayWithArray:
                                  [self.fourMoves componentsSeparatedByString:@","]];
  NSInteger fourMovesCount = [fourMovesPP count] / 3;
  if (fourMovesCount <= 0)
    return nil;
  // remove Move IDs from tail to head
  for (NSInteger i = --fourMovesCount; i >= 0; --i)
    [fourMovesPP removeObjectAtIndex:(i * 3)];
  return fourMovesPP;
}

// Current PPs in One NSInteger
//
//   |PPInOne|: 000 000 000 000
//  Move Index:   4   3   2   1
//
- (NSInteger)fourMovesPPInOne {
  NSArray * fourMoves = [self.fourMoves componentsSeparatedByString:@","];
  NSInteger fourMovesCount = [fourMoves count] / 3;
  if (fourMovesCount <= 0)
    return 0;
  NSInteger ppInOne = 0;
  for (NSInteger i = 0; i < fourMovesCount; ++i) {
    NSInteger movePP = [[fourMoves objectAtIndex:(i * 3 + 1)] intValue];
    if (movePP < 0) movePP = 0;
    ppInOne += movePP * pow(1000, i);
  }
  NSLog(@"ppInOne:%d", ppInOne);
  return ppInOne;
}

- (NSArray *)maxStatsInArray {
  return [self.maxStats componentsSeparatedByString:@","];
}

#pragma mark - SET Base data

// Add Move
- (void)addMoveWithNewMoveID:(NSInteger)newMoveID {
}

// Replace move
- (void)replaceMoveAtIndex:(NSInteger)index
             withNewMoveID:(NSInteger)newMoveID {
}

// update pp & maxPP for moves (NSArray)
//- (void)updateFourMovesWithPPArrayWithMax:(NSArray *)ppArrayWithMax {
//  NSMutableArray * fourMoves = [NSMutableArray arrayWithArray:[self.fourMoves componentsSeparatedByString:@","]];
//  for (NSInteger i = 0; i < [fourMoves count] / 3; ++i) {
//    [fourMoves replaceObjectAtIndex:(i * 3 + 1) withObject:[ppArrayWithMax objectAtIndex:i]];
//    [fourMoves replaceObjectAtIndex:(i * 3 + 2) withObject:[ppArrayWithMax objectAtIndex:(i + 1)]];
//  }
//  self.fourMoves = [fourMoves componentsJoinedByString:@","];
//}

// Update PP for moves (NSArray)
//
// |self.fourMoves|:
//    move1ID,move1currPP,move1maxPP, move2ID,move2currPP,move2maxPP,
//    move3ID,move3currPP,move3maxPP, move4ID,move4currPP,move4maxPP
//
//  0,1,2, 3,4,5, 6,7,8, 9,10,11
//
- (void)updateFourMovesWithPPArray:(NSArray *)ppArray {
  NSMutableArray * fourMoves = [NSMutableArray arrayWithArray:[self.fourMoves componentsSeparatedByString:@","]];
  for (NSInteger i = 0; i < [fourMoves count] / 3; ++i)
    [fourMoves replaceObjectAtIndex:(i * 3 + 1) withObject:[ppArray objectAtIndex:i]];
  self.fourMoves = [fourMoves componentsJoinedByString:@","];
}

// Update PP for moves (NSInteger)
//
//   |PPInOne|: 000 000 000 000
//  Move Index:   4   3   2   1
//
- (void)updateFourMovesWithPPInOne:(NSInteger)PPInOne {
  NSArray * ppArray = [[NSArray alloc] initWithObjects:
                       [NSNumber numberWithInt:(PPInOne % 1000)],
                       [NSNumber numberWithInt:(PPInOne % 1000000    / 1000)], 
                       [NSNumber numberWithInt:(PPInOne % 1000000000 / 1000000)],
                       [NSNumber numberWithInt:(PPInOne / 1000000000)], nil];
  [self updateFourMovesWithPPArray:ppArray];
}

// Return Levels Up after added gained EXP
- (NSInteger)levelsUpWithGainedExp:(NSInteger)gainedExp {
  NSInteger levelsUp       = 0;
  NSInteger exp            = [self.exp intValue];
  NSInteger expToNextLevel = [self.toNextLevel intValue];
  exp            += gainedExp;
  expToNextLevel -= gainedExp;
  
  // Level Up when |expToNextLevel <= 0|
  if (expToNextLevel <= 0) {
    NSInteger level = [self.level intValue] + 1;
    do {
      ++levelsUp;
      expToNextLevel += [self.pokemon expToNextLevel:++level];
    } while (expToNextLevel <= 0);
    self.level = [NSNumber numberWithInt:--level];
  }
  
  // Save new data
  self.exp         = [NSNumber numberWithInt:exp];
  self.toNextLevel = [NSNumber numberWithInt:expToNextLevel];
  return levelsUp;
}

// Add stats with number of levels up
//   return an array to show detail of stats added
//
// [[STAT CALCULATION]]
//    [[BASE STATS]]
//      Base stats are the core of the whole stats. Each Pokémon species has their own unique set of base stats. These stats help determine the total stats when the Pokémon is at a specific level. However, as each species has a different, this means that if say you have two Meganium, their stats will not be radically different if untrained.
//
//    [[INDIVIDUAL VALUES]]
//      Individual Values are a specific value that each Pokémon has one each of its six stats. The value ranges from 0 to 31 and each value corresponds to one single stat point at Level 100. Technically, apart from seeing their effect, they are a hidden value which you have little to no control over. If you have a Pokémon with a high IV, you will have the ability to pass it down via breeding, however that means is pretty much random. As there are six stats and thirty one possible values for each stat, there are 1,073,741,824 different IV combinations making sure that you will pretty much never have a Pokémon exactly the same as another one of the same species. To calculate IVs, use our IV Calculator.
//
//    [[EFFORT VALUES]]
//      Effort Values are another set of values utilised to determine a Pokémon's stat. However, unlike IVs and Base Stats, EVs are totally customisable. You earn Effort Values by battling Pokémon, with each Pokémon giving a different set of EVs to the Pokémon that defeats it. For every 4 EVs earned in a particular stat, you get 1 extra stat point at Level 100. However, there are limits on the Effort Values you can have. You can only have 510 Effort Values on any one Pokémon, corresponding to a maximum of 255 on two stats. However, as that is not divisable by four, it's best to take it to 252 when maxing a stat. This corresponds to 63 more stat points at Level 100. The dispersal of these values is completely up to you so it can help you make the most out of your Pokémon.
//
//    [[LEVEL]]
//      The Level of your Pokémon is also vital in the calculation of the Pokémon stats. As you increase in level, the stats get increased by 2% of the Base Stat value and 1% of the combined IV and current EV value. This means that even if you have maxed out a stat in EVs but it's still say Level 10, you'll only notice a minimal stat increase.
//
//    [[NATURES]]
//      Finally, Natures are the other attribute which have a permanent affect on the stats. Each nature raises one stat while lowering another (the neutral natures raise and lower the same stat rendering them inert). At the end of the calculation, the nature is taken into account. If it raises the stat, then the stat's value becomes 110% of what it would normally be and if it lowers the stat, the value becomes 90% of what it would normally be.
//
//
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
- (NSArray *)addStatsWithLevelsUp:(NSInteger)levelsUp {
  // Formula effects
  double IV          = 0; // IV.(Individual Values) TODO!!!!!!
  double EV          = 1; // EV.(Effort Values)     TODO!!!!!!
  double level       = [self.level doubleValue] + (double)levelsUp;
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
  
  // get the <delta stats> (<new value> minus the <original value>)
  NSArray * originalStats = [self maxStatsInArray];
  NSInteger statDeltaHP        = statHP        - [[originalStats objectAtIndex:0] intValue];
  NSInteger statDeltaAttack    = statAttack    - [[originalStats objectAtIndex:1] intValue];
  NSInteger statDeltaDefense   = statDefense   - [[originalStats objectAtIndex:2] intValue];
  NSInteger statDeltaSpAttack  = statSpAttack  - [[originalStats objectAtIndex:3] intValue];
  NSInteger statDeltaSpDefense = statSpDefense - [[originalStats objectAtIndex:4] intValue];
  NSInteger statDeltaSpeed     = statSpeed     - [[originalStats objectAtIndex:5] intValue];
  originalStats = nil;
  
  // Save stats
  self.maxStats = [NSString stringWithFormat:@"%d,%d,%d,%d,%d,%d",
                   statHP, statAttack, statDefense, statSpAttack, statSpDefense, statSpeed];
  
  // Return delta stats
  return [NSArray arrayWithObjects:
          [NSNumber numberWithInt:statDeltaHP],
          [NSNumber numberWithInt:statDeltaAttack],
          [NSNumber numberWithInt:statDeltaDefense],
          [NSNumber numberWithInt:statDeltaSpAttack],
          [NSNumber numberWithInt:statDeltaSpDefense],
          [NSNumber numberWithInt:statDeltaSpeed], nil];
}

@end
