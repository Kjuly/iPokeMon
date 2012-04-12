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


@interface Trainer ()

- (NSString *)bagItemsInStringFor:(BagQueryTargetType)targetType;
- (NSString *)allBagItemsInString;

@end


@implementation Trainer (DataController)

// Update Data
+ (void)initWithUserID:(NSInteger)userID {
  if (userID <= 0) return;
  
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  
  // Get |trainer| entity with |userID|
  // If failed (i.e. No data for current user), insert new one for user
  __block Trainer * trainer = [Trainer queryTrainerWithUserID:userID];
  if (! trainer) {
    NSLog(@"!!! No data for Trainer, insert new one");
    trainer = nil;
    trainer = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                            inManagedObjectContext:managedObjectContext];
    trainer.uid  = [NSNumber numberWithInt:userID];
    trainer.name = [NSString stringWithFormat:@"Trainer%d", userID];
    
    NSError * error;
    if (! [managedObjectContext save:&error])
      NSLog(@"Couldn't save data to %@", NSStringFromClass([self class]));
  }
  
  ///Fetch Data from server & update the date for |trainer|
  // Success Block Method
  void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id JSON) {
    // Set data for |Trainer|
    trainer.uid               = [NSNumber numberWithInt:[[JSON valueForKey:@"id"] intValue]];
    trainer.name              = [JSON valueForKey:@"name"];
    trainer.money             = [NSNumber numberWithInt:[[JSON valueForKey:@"money"] intValue]];
    trainer.badges            = [JSON valueForKey:@"badges"];
    trainer.pokedex           = [JSON valueForKey:@"pokedex"];
    trainer.sixPokemonsID     = [JSON valueForKey:@"sixPokemons"];
    trainer.adventureStarted  = [NSDate dateWithTimeIntervalSince1970:[[JSON valueForKey:@"timeStarted"] intValue]];
    
    // <bag>: <bagItems>:<bagMedicineStatus>:<bagMedicineHP>:<bagMedicinePP>
    //        :<bagPokeballs>:<bagTMsHMs>:<bagBerries>:<bagBattleItems>:<bagKeyItems>
    // "0:0:0:0:0:0:0:0:0"
    NSArray * bagItems = [[JSON valueForKey:@"bag"] componentsSeparatedByString:@":"];
    NSLog(@"BagItems:%@", bagItems);
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
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"uid == %d", userID];
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

// Sync data between Client & Server
- (void)syncWithFlag:(DataModifyFlag)flag {
  //  Trainer * trainer = [self queryTrainerWithUserID:userID];
  NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
  if (! (flag & kDataModifyTrainer))
    return;
  
  if (flag & kDataModifyTrainerName)        [data setValue:self.name                  forKey:@"name"];
  if (flag & kDataModifyTrainerMoney)       [data setValue:self.money                 forKey:@"money"];
  if (flag & kDataModifyTrainerBadges)      [data setValue:self.badges                forKey:@"badges"];
  if (flag & kDataModifyTrainerPokedex)     [data setValue:self.pokedex               forKey:@"pokedex"];
  if (flag & kDataModifyTrainerSixPokemons) [data setValue:self.sixPokemonsID         forKey:@"sixPokemons"];
  if (flag & kDataModifyTrainerBag)         [data setValue:[self allBagItemsInString] forKey:@"bag"];
  
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

// Fetch Pokemons for |sixPokemons|
- (NSArray *)sixPokemons {
  NSArray * sixPokemonsUID = [self.sixPokemonsID componentsSeparatedByString:@","];
  NSArray * sixPokemons = [TrainerTamedPokemon queryPokemonsWithUID:sixPokemonsUID
                                                         trainerUID:[self.uid intValue]
                                                         fetchLimit:6];
  
  // Sort six pokemons in order
  NSMutableArray * sixPokemonsInOrder = [NSMutableArray arrayWithCapacity:[sixPokemonsUID count]];
  for (id pokemonID in sixPokemonsUID)
    for (TrainerTamedPokemon * pokemon in sixPokemons) {
      NSNumber * pokemonIDInNumber = [NSNumber numberWithInt:[pokemonID intValue]];
      if ([pokemon.uid isEqualToNumber:pokemonIDInNumber]) {
        [sixPokemonsInOrder addObject:pokemon];
        break;
      }
    }
  sixPokemonsUID = nil;
  sixPokemons    = nil;
  return sixPokemonsInOrder;
}

// Add Pokemon to |sixPokemons|
- (void)addPokemonToSixPokemonsWithPokemonUID:(NSInteger)pokemonUID {
  if ([self.sixPokemonsID length] == 0)
    self.sixPokemonsID = [NSString stringWithFormat:@"%d", pokemonUID];
  else
    self.sixPokemonsID = [NSString stringWithFormat:@"%@,%d", self.sixPokemonsID, pokemonUID];
}

#pragma mark - Private Methods

// Bag Items in String
- (NSString *)bagItemsInStringFor:(BagQueryTargetType)targetType {
  id bagItems = nil;
  if      (targetType & kBagQueryTargetTypeItem)       bagItems = self.bagItems;
  else if (targetType & kBagQueryTargetTypeMedicine) {
    if (targetType & kBagQueryTargetTypeMedicineStatus)  bagItems = self.bagMedicineStatus;
    else if (targetType & kBagQueryTargetTypeMedicineHP) bagItems = self.bagMedicineHP;
    else if (targetType & kBagQueryTargetTypeMedicinePP) bagItems = self.bagMedicinePP;
    else return nil;
  }
  else if (targetType & kBagQueryTargetTypePokeball)   bagItems = self.bagPokeballs;
  else if (targetType & kBagQueryTargetTypeTMHM)       bagItems = self.bagTMsHMs;
  else if (targetType & kBagQueryTargetTypeBerry)      bagItems = self.bagBerries;
  else if (targetType & kBagQueryTargetTypeMail)       return nil;
  else if (targetType & kBagQueryTargetTypeBattleItem) bagItems = self.bagBattleItems;
  else if (targetType & kBagQueryTargetTypeKeyItem)    bagItems = self.bagKeyItems;
  else return nil;
  
  // TODO:
  //   |DataTransformer| should deal with NSString to NSArray transformation work
  //     It sometimes (like this case) not work!!
//  if ([bagItems isKindOfClass:[NSArray class]])
//    return [bagItems componentsJoinedByString:@","];
  return bagItems;
}

// All bag items in one String
- (NSString *)allBagItemsInString {
  return [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@:%@:%@:%@",
          [self bagItemsInStringFor:kBagQueryTargetTypeItem],
          [self bagItemsInStringFor:kBagQueryTargetTypeMedicine | kBagQueryTargetTypeMedicineStatus],
          [self bagItemsInStringFor:kBagQueryTargetTypeMedicine | kBagQueryTargetTypeMedicineHP],
          [self bagItemsInStringFor:kBagQueryTargetTypeMedicine | kBagQueryTargetTypeMedicinePP],
          [self bagItemsInStringFor:kBagQueryTargetTypePokeball],
          [self bagItemsInStringFor:kBagQueryTargetTypeTMHM],
          [self bagItemsInStringFor:kBagQueryTargetTypeBerry],
          [self bagItemsInStringFor:kBagQueryTargetTypeBattleItem],
          [self bagItemsInStringFor:kBagQueryTargetTypeKeyItem]];
}

@end
