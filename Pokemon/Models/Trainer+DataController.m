//
//  Trainer+DataController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/16/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "Trainer+DataController.h"

#import "AppDelegate.h"
#import "ServerAPIClient.h"
#import "TrainerController.h"

#import "AFJSONRequestOperation.h"


@implementation Trainer (DataController)

// Update Data
+ (void)initWithUserID:(NSInteger)userID {
  if (userID <= 0) return;
  
  ///Fetch Data from server & update the date for |trainer|
  // Success Block Method
  void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id JSON) {
    NSManagedObjectContext * managedObjectContext =
      [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    // Get |trainer| entity with |userID|
    // If failed (i.e. No data for current user), insert new one for user
    Trainer * trainer = [Trainer queryTrainerWithUserID:userID];
    if (! trainer) {
      NSLog(@"!!! No data for Trainer, insert new one");
      trainer = nil;
      trainer = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                              inManagedObjectContext:managedObjectContext];
    }
    
    // Set data for |Trainer|
    trainer.uid               = [NSNumber numberWithInt:[[JSON valueForKey:@"id"] intValue]];
    trainer.name              = [JSON valueForKey:@"name"];
    trainer.money             = [NSNumber numberWithInt:[[JSON valueForKey:@"money"] intValue]];
    trainer.pokedex           = [JSON valueForKey:@"pokedex"];
    trainer.sixPokemonsID     = [JSON valueForKey:@"sixPokemons"];
    trainer.adventureStarted  = [NSDate dateWithTimeIntervalSince1970:[[JSON valueForKey:@"timeStarted"] intValue]];
    
    // <bag>: <bagItems>_<bagMedicineStatus>_<bagMedicineHP>_<bagMedicinePP>
    //        <bagPokeballs>_<bagTMsHMs>_<bagBerries>_<bagBattleItems>_<bagKeyItems>
    // "0_0_0_0_0_0_0_0_0"
    NSArray * bagItems = [[JSON valueForKey:@"bag"] componentsSeparatedByString:@"_"];
    trainer.bagItems          = [bagItems objectAtIndex:0];
    trainer.bagMedicineStatus = [bagItems objectAtIndex:1];
    trainer.bagMedicineHP     = [bagItems objectAtIndex:2];
    trainer.bagMedicinePP     = [bagItems objectAtIndex:3];
    trainer.bagPokeballs      = [bagItems objectAtIndex:4];
    trainer.bagTMsHMs         = [bagItems objectAtIndex:5];
    trainer.bagBerries        = [bagItems objectAtIndex:6];
    trainer.bagBattleItems    = [bagItems objectAtIndex:7];
    trainer.bagKeyItems       = [bagItems objectAtIndex:8];
    bagItems = nil;
    
    NSError * error;
    if (! [managedObjectContext save:&error])
      NSLog(@"Couldn't save data to %@", NSStringFromClass([self class]));
    NSLog(@"...Update |%@| data done...", [self class]);
  };
  
  // Failure Block Method
  void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError * error) {
    NSLog(@"!!! |%@| data fetch ERROR: %@", [self class], error);
  };
  
  // Fetch data from server & populate the data for Tainer
  [[ServerAPIClient sharedInstance] fetchDataFor:kDataFetchTargetTrainer success:success failure:failure];
}

// Sync data between Client & Server
+ (void)syncWithUserID:(NSInteger)userID flag:(DataModifyFlag)flag {
  Trainer * trainer = [self queryTrainerWithUserID:userID];
  NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
  if (! (flag & kDataModifyTrainer))
    return;
  
  if (flag & kDataModifyTrainerName)        [data setValue:trainer.name          forKey:@"name"];
  if (flag & kDataModifyTrainerMoney)       [data setValue:trainer.money         forKey:@"money"];
  if (flag & kDataModifyTrainerBadges)      [data setValue:nil                   forKey:@"badges"];
  if (flag & kDataModifyTrainerPokedex)     [data setValue:trainer.pokedex       forKey:@"pokedex"];
  if (flag & kDataModifyTrainerSixPokemons) [data setValue:trainer.sixPokemonsID forKey:@"sixPokemons"];
  if (flag & kDataModifyTrainerBag) {
    NSMutableString * bag = [NSMutableString string];
    [bag stringByAppendingString:trainer.bagItems];
    [bag stringByAppendingString:trainer.bagMedicineStatus];
    [bag stringByAppendingString:trainer.bagMedicineHP];
    [bag stringByAppendingString:trainer.bagMedicinePP];
    [bag stringByAppendingString:trainer.bagPokeballs];
    [bag stringByAppendingString:trainer.bagTMsHMs];
    [bag stringByAppendingString:trainer.bagBerries];
    [bag stringByAppendingString:trainer.bagBattleItems];
    [bag stringByAppendingString:trainer.bagKeyItems];
    [data setValue:bag forKey:@"bag"];
  }
  
  // Block: |success| & |failure|
  void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"...Sync |%@| data done...Reset FLAG", [self class]);
    // Reset |flag_| in |TrainerCoreDataController| after sync done & successed (response 'v' with value 1)
    if ([[responseObject valueForKey:@"v"] intValue])
      [[TrainerController sharedInstance] syncDoneWithFlag:kDataModifyTrainer];
  };
  void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"!!! Sync |%@| data failed ERROR: %@", [self class], error);
  };
  
  NSLog(@"Sync Data:%@", data);
  [[ServerAPIClient sharedInstance] updateData:data forTarget:kDataFetchTargetTrainer success:success failure:failure];
  [data release];
}

// Add new Entity Data
+ (void)addData
{
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  Trainer * trainer = [NSEntityDescription insertNewObjectForEntityForName:@"Trainer"
                                                    inManagedObjectContext:managedObjectContext];
  
  // Fetch Data from server
  NSURL * url = [[NSURL alloc] initWithString:@"http://localhost:8080/user/1"];
  NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
  [url release];
  
  AFJSONRequestOperation * operation =
  [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                  success:^(NSURLRequest * request, NSHTTPURLResponse * response, id JSON) {
                                                    // Set data for |Trainer|
                                                    trainer.uid = [JSON valueForKey:@"id"];
                                                    trainer.name = [JSON valueForKey:@"name"];
                                                    trainer.money = [JSON valueForKey:@"money"];
                                                    trainer.adventureStarted = nil;
                                                    
                                                    NSError * error;
                                                    if (! [managedObjectContext save:&error])
                                                      NSLog(@"Couldn't save data to %@", NSStringFromClass([self class]));
                                                  }
                                                  failure:nil];
  [request release];
  [operation start];
}

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

// Get current User's trainer data
+ (Trainer *)queryTrainerWithUserID:(NSInteger)userID {
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sid == %d", userID];
  [fetchRequest setPredicate:predicate];
  [fetchRequest setFetchLimit:1];
  
  NSError * error;
  Trainer * trainer = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
  NSLog(@"|queryTrainerWithUserID:%d| - Trainer:%@", userID, trainer);
  [fetchRequest release];
  
  return trainer;
}

// Set data to model
+ (void)setTrainerWith:(NSInteger)trainerID Name:(NSString *)name
{
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  Trainer * trainer = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                                         inManagedObjectContext:managedObjectContext];
  trainer.uid  = [NSNumber numberWithInt:trainerID];
  trainer.name = name;
  
  NSError * error;
  if (! [managedObjectContext save:&error])
    NSLog(@"Couldn't save data to %@", NSStringFromClass([self class]));
}

#pragma mark - Instance Methods

- (NSArray *)sixPokemons
{
  NSArray * sixPokemonsID = [self.sixPokemonsID componentsSeparatedByString:@","];
  NSArray * sixPokemons = [TrainerTamedPokemon queryPokemonsWithID:sixPokemonsID fetchLimit:6];
  
  // Sort six pokemons in order
  NSMutableArray * sixPokemonsInOrder = [NSMutableArray arrayWithCapacity:[sixPokemonsID count]];
  for (id pokemonID in sixPokemonsID)
    for (TrainerTamedPokemon * pokemon in sixPokemons) {
      NSNumber * pokemonIDInNumber = [NSNumber numberWithInt:[pokemonID intValue]];
      if ([pokemon.uid isEqualToNumber:pokemonIDInNumber]) {
        [sixPokemonsInOrder addObject:pokemon];
        break;
      }
    }
  sixPokemonsID = nil;
  sixPokemons   = nil;
  return sixPokemonsInOrder;
}

@end
