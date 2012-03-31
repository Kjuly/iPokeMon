//
//  Trainer+DataController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/16/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "Trainer+DataController.h"

#import "PokemonServerAPI.h"
#import "AppDelegate.h"
#import "TrainerTamedPokemon+DataController.h"

#import "OAuthManager.h"
#import "AFJSONRequestOperation.h"


@implementation Trainer (DataController)

// Update Data
+ (BOOL)initWithUserID:(NSInteger)userID
{
  // Fetch current User's Trainer Data
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sid == %d", userID];
  [fetchRequest setPredicate:predicate];
  //  [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:@"", nil];
  [fetchRequest setFetchLimit:1];
  
  NSError * error;
  Trainer * trainer = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
  [fetchRequest release];
  
  // If no Trainer Data for current User exists, insert new one
  if (! trainer) {
    NSLog(@"!!! No data for Trainer, insert new one");
    trainer = nil;
    trainer = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                            inManagedObjectContext:managedObjectContext];
  }
  
  ///Fetch Data from server & populate the |trainer|
  // Success Block Method
  void (^blockPopulateData)(NSURLRequest *, NSHTTPURLResponse *, id) =
  ^(NSURLRequest * request, NSHTTPURLResponse * response, id JSON) {
    // Set data for |Trainer|
    trainer.sid               = [NSNumber numberWithInt:[[JSON valueForKey:@"id"] intValue]];
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
  void (^blockError)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id) =
  ^(NSURLRequest *request, NSHTTPURLResponse * response, NSError * error, id JSON) {
    NSLog(@"!!! |%@| data fetch ERROR: %@", [self class], error);
  };
  
  // Fetch data from server & populate the data for Tainer
  [[OAuthManager sharedInstance] fetchDataFor:kDataFetchTargetTrainer success:blockPopulateData failure:blockError];
  return true;
}

// Sync data between Client & Server
+ (void)syncWithUserID:(NSInteger)userID flag:(DataModifyFlag)flag {
  Trainer * trainer = [self queryTrainerWithTrainerID:userID];
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
  
  void (^success)(AFHTTPRequestOperation *, id) =
    ^(AFHTTPRequestOperation *operation, id responseObject) {
      NSLog(@"...Sync |%@| data done...", [self class]);
    };
  
  void (^failure)(AFHTTPRequestOperation *, NSError *) =
    ^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"!!! Sync |%@| data failed ERROR: %@", [self class], error);
    };
  
  NSLog(@"Sync Data:%@", data);
  [[OAuthManager sharedInstance] updateData:data forTarget:kDataFetchTargetTrainer success:success failure:failure];
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
                                                    trainer.sid = [JSON valueForKey:@"id"];
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
+ (Trainer *)queryTrainerWithTrainerID:(NSInteger)trainerID
{
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sid == %d", trainerID];
  [fetchRequest setPredicate:predicate];
  [fetchRequest setFetchLimit:1];
  
  NSError * error;
  Trainer * trainer = [[managedObjectContext executeFetchRequest:fetchRequest
                                                                 error:&error] lastObject];
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
  trainer.sid  = [NSNumber numberWithInt:trainerID];
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
