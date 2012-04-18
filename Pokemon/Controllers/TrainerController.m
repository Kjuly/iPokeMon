//
//  TrainerCoreData.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "TrainerController.h"

#import "AppDelegate.h"
#import "GlobalNotificationConstants.h"
#import "NSString+Algorithm.h"
#import "OAuthManager.h"
#import "Trainer+DataController.h"


@interface TrainerController () {
 @private
  BOOL             isInitialized_;     // Is initialized for current user
  DataModifyFlag   flag_;              // Data modify flag
  NSInteger        userID_;            // User ID, same as Trainer UID
  Trainer        * entityTrainer_;     // Trainer
  NSMutableArray * entitySixPokemons_; // SixPokemons
}

@property (nonatomic, assign) BOOL             isInitialized;
@property (nonatomic, assign) DataModifyFlag   flag;
@property (nonatomic, assign) NSInteger        userID;
@property (nonatomic, retain) Trainer        * entityTrainer;
@property (nonatomic, retain) NSMutableArray * entitySixPokemons;

- (void)updatePokedexWithPokemonID:(NSInteger)pokemonID;
- (void)saveBagItemsFor:(BagQueryTargetType)targetType withData:(NSString *)data;

@end

@implementation TrainerController

@synthesize isInitialized     = isInitialized_;
@synthesize flag              = flag_;
@synthesize userID            = userID_;
@synthesize entityTrainer     = entityTrainer_;
@synthesize entitySixPokemons = entitySixPokemons_;

// Singleton
static TrainerController * trainerController_ = nil;
+ (TrainerController *)sharedInstance {
  // Check Session first,
  //   if it's not valid, post notification to |MainViewController| to show login view & return nil
  if (! [[OAuthManager sharedInstance] isSessionValid]) {
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNSessionIsInvalid object:self userInfo:nil];
    return nil;
  }
  
  if (trainerController_ != nil)
    return trainerController_;
  
  static dispatch_once_t onceToken; // Lock
  dispatch_once(&onceToken, ^{      // This code is called at most once per app
    trainerController_ = [[TrainerController alloc] init];
  });
  return trainerController_;
}

- (void)dealloc
{
  [entityTrainer_     release];
  [entitySixPokemons_ release];
  
  self.entityTrainer     = nil;
  self.entitySixPokemons = nil;
  
  [super dealloc];
}

- (id)init {
  if (self = [super init]) {
    isInitialized_ = NO;
    flag_          = 0;
  }
  return self;
}

// It is called at method:|syncUserID| in |OAuthManager| after user has authticated
- (void)initTrainerWithUserID:(NSInteger)userID {
  NSLog(@"......|%@| - INIT......", [self class]);
  self.userID = userID;
  
  // S->C: Initialize Trainer data from Server to Client
  [Trainer initWithUserID:userID];
  // Fetch Trainer data from Client (CoreData)
  self.entityTrainer = [Trainer queryTrainerWithUserID:userID];
  // S->C: Initialize TrainerTamedPokemon data from Server to Client
  [TrainerTamedPokemon initWithTrainer:self.entityTrainer];
  // Fetch Trainer's Six Pokemons data from Client (CoreData)
  self.entitySixPokemons = [NSMutableArray arrayWithArray:[self.entityTrainer sixPokemons]];
  if (self.entitySixPokemons == nil) {
    NSLog(@"!!!|%@| - |initTrainerWithUserID:| - self.entitySixPokemons == nil...", [self class]);
    self.entitySixPokemons = [NSMutableArray array];
  }
  
  // If user has no Pokemon brought (newbie),
  //   post notification to |MainViewController| to show view of |NewbiewGuideViewController|
  if ([self.entitySixPokemons count] == 0) {
    NSLog(@"!!!|%@| - |initTrainerWithUserID:| - [self.entitySixPokemons count] == 0...", [self class]);
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNShowNewbieGuide object:self userInfo:nil];
  }
  
  self.isInitialized = YES;
}

// Save Client data to CoreData
-(void)saveWithSync:(BOOL)withSync {
  NSLog(@"......|%@| - SVEING DATA......", [self class]);
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSError * error;
  if (! [managedObjectContext save:&error])
    NSLog(@"Couldn't save data to |%@|", NSStringFromClass([self class]));
  
  // Sync data to Server
  if (withSync) [self sync];
}

#pragma mark - Data Related Methods

// Sync data between Client & Server
- (void)sync {
  if (! self.userID) return;
  
  // C->S: If Client data has initialzied, just do sync Client to Server
  if (self.isInitialized) {
    NSLog(@"......|%@| - SYNC.......", [self class]);
    if (self.flag & kDataModifyTrainer)
      [self.entityTrainer syncWithFlag:self.flag];
  }
}

// Add modify flag for |flag_|
- (void)addModifyFlag:(DataModifyFlag)flag {
  self.flag |= flag;
}

// Dispatch this method after Sync done
// It can be dispatched in URL Request Callback method
- (void)syncDoneWithFlag:(DataModifyFlag)flag {
  self.flag -= flag;
  
  // If sync data for Trainer done, set all related flags to 0
  if (flag & kDataModifyTrainer) {
    self.flag &= (00000000 << 0);
  }
  // If sync data for Tamed Pokemon done, set all related flags to 0
  if (flag & kDataModifyTamedPokemon) {
    self.flag &= (0000 << 8);
  }
}

// Trainer's basic data
- (NSInteger) UID         {return self.userID;}
- (NSString *)name        {return self.entityTrainer.name;}
- (NSInteger) money       {return [self.entityTrainer.money intValue];}
- (NSArray *) badges      {return [self.entityTrainer.badges componentsSeparatedByString:@","];}
- (NSDate *)  timeStarted {return self.entityTrainer.adventureStarted;}
- (NSString *)pokedex     {return self.entityTrainer.pokedex;}
- (NSInteger) numberOfPokemonsForPokedex {return [self.entityTrainer.pokedex numberOfBinary1];}
- (NSInteger) numberOfTamedPokemons      {return [TrainerTamedPokemon numberOfTamedPokemonsWithTraienrUID:self.userID];}
- (NSArray *) sixPokemons {return self.entitySixPokemons;}
- (NSString *)sixPokemonsUID {return self.entityTrainer.sixPokemonsID;}
- (NSInteger) numberOfSixPokemons {
  return [[self.entityTrainer.sixPokemonsID componentsSeparatedByString:@","] count];
}
// Avatar URL, asynchronously downloads the image with the specified url request object
- (NSURL *)avatarURL {
  return [NSURL URLWithString:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=200",
                               [[OAuthManager sharedInstance] userEmailInMD5]]];
}

// Return first Pokemon of six Pokemons
- (TrainerTamedPokemon *)firstPokemonOfSix {
  return [self.entitySixPokemons objectAtIndex:0];
}

// Return Pokemon at |index|(1-6) of six Pokemons
- (TrainerTamedPokemon *)pokemonOfSixAtIndex:(NSInteger)index {
  if (index < 1 || index > 6)
    return nil;
  return [self.entitySixPokemons objectAtIndex:--index];
}

// Check whether Pokemons in Six can battle,
//   and return the first battleable one's index
- (NSInteger)battleAvailablePokemonIndex {
  NSInteger availablePokemonIndex = 0;
  NSInteger i = 1;
  for (TrainerTamedPokemon *pokemon in self.entitySixPokemons) {
    if ([pokemon.hp intValue] > 0) {
      availablePokemonIndex = i;
      break;
    }
    ++i;
  }
  return availablePokemonIndex;
}

// Return all items for the bag item type (BagItem, BagMedicine, BagBerry, etc)
- (NSArray *)bagItemsFor:(BagQueryTargetType)targetType {
  id bagItems = nil;
  if      (targetType & kBagQueryTargetTypeItem)       bagItems = self.entityTrainer.bagItems;
  else if (targetType & kBagQueryTargetTypeMedicine) {
    if (targetType & kBagQueryTargetTypeMedicineStatus)  bagItems = self.entityTrainer.bagMedicineStatus;
    else if (targetType & kBagQueryTargetTypeMedicineHP) bagItems = self.entityTrainer.bagMedicineHP;
    else if (targetType & kBagQueryTargetTypeMedicinePP) bagItems = self.entityTrainer.bagMedicinePP;
    else return nil;
  }
  else if (targetType & kBagQueryTargetTypePokeball)   bagItems = self.entityTrainer.bagPokeballs;
  else if (targetType & kBagQueryTargetTypeTMHM)       bagItems = self.entityTrainer.bagTMsHMs;
  else if (targetType & kBagQueryTargetTypeBerry)      bagItems = self.entityTrainer.bagBerries;
  else if (targetType & kBagQueryTargetTypeMail)       return nil;
  else if (targetType & kBagQueryTargetTypeBattleItem) bagItems = self.entityTrainer.bagBattleItems;
  else if (targetType & kBagQueryTargetTypeKeyItem)    bagItems = self.entityTrainer.bagKeyItems;
  else return nil;
  
  // TODO:
  //   |DataTransformer| should deal with NSString to NSArray transformation work
  //     It sometimes (like this case) not work!!
  if ([bagItems isKindOfClass:[NSString class]])
    return [bagItems componentsSeparatedByString:@","];
  return bagItems;
}

#pragma mark - Settings

// Set |name| for Trainer
- (void)setName:(NSString *)name {
  self.entityTrainer.name = name;
  self.flag = self.flag | kDataModifyTrainer | kDataModifyTrainerName;
  [self saveWithSync:YES];
}

// Transfer WildPokemon to TamedPokemon
// Add new TamedPokemon, 
- (void)caughtNewWildPokemon:(WildPokemon *)wildPokemon memo:(NSString *)memo {
  NSLog(@"|%@| - |caughtNewWildPokemon:| :: %@", [self class], wildPokemon);
  NSInteger box;
  // If count of |sixPokemons| is not |6|, add it there instead of |box|
  if ([self numberOfSixPokemons] < 6)
    box = 0;
  // Else, find a box to put new Pokemon
  //
  // !!!TODO:
  //   Need a model to store Pokemons in Boxes.
  //
  else {
    box = 1;
  }
  
  // Add WildPokemon to TrainerTamedPokemon Group
  [TrainerTamedPokemon addPokemonWithWildPokemon:wildPokemon withMemo:memo toBox:box forTrainer:self.entityTrainer];
  // Update Pokedex
  [self updatePokedexWithPokemonID:[wildPokemon.sid intValue]];
  // If |box == 0|, add new Pokemon to |sixPokemons|
  if (box == 0)
    [self addPokemonToSixPokemonsWithPokemonUID:[self numberOfTamedPokemons]];
  
  // Save & sync data
  [self saveWithSync:YES];
}

// Add Pokemon to |sixPokemons|
- (void)addPokemonToSixPokemonsWithPokemonUID:(NSInteger)pokemonUID {
  // Add new |pokemonUID| to |sixPokemons|
  [self.entityTrainer addPokemonToSixPokemonsWithPokemonUID:pokemonUID];
  
  // Refetch Pokemons for |sixPokemons|
  [self.entitySixPokemons addObject:[TrainerTamedPokemon queryPokemonDataWithUID:pokemonUID
                                                                      trainerUID:self.userID]];
  self.flag = self.flag | kDataModifyTrainer | kDataModifyTrainerSixPokemons;
}

// Replace Pokemon's index order
- (void)replacePokemonAtIndex:(NSInteger)sourceIndex
                      toIndex:(NSInteger)destinationIndex {
  NSLog(@"Original SixPokemons:%@", self.entityTrainer.sixPokemonsID);
  NSLog(@"Moved sourceIndex:%d -> destinationIndex:%d", sourceIndex + 1, destinationIndex + 1);
  NSMutableArray * sixPokemonsID = [[self.entityTrainer.sixPokemonsID componentsSeparatedByString:@","] mutableCopy];
  id sourceObject      = [sixPokemonsID objectAtIndex:sourceIndex];
  id destinationObject = [sixPokemonsID objectAtIndex:destinationIndex];
  [sixPokemonsID replaceObjectAtIndex:sourceIndex withObject:destinationObject];
  [sixPokemonsID replaceObjectAtIndex:destinationIndex withObject:sourceObject];
  
  // Save & Sync data
  self.entityTrainer.sixPokemonsID = [sixPokemonsID componentsJoinedByString:@","];
  self.flag = self.flag | kDataModifyTrainer | kDataModifyTrainerSixPokemons;
  NSLog(@"Replaced SixPokemons:%@", self.entityTrainer.sixPokemonsID);
  [self saveWithSync:NO];
  
  sixPokemonsID = nil;
  // Refetch data of Six Pokemons
  self.entitySixPokemons = [NSMutableArray arrayWithArray:[self.entityTrainer sixPokemons]];
}

// BagItem - Use
- (void)useBagItemForType:(BagQueryTargetType)targetType
            withItemIndex:(NSInteger)itemIndex {
  NSMutableArray * bagItems = [[NSMutableArray alloc] initWithArray:[self bagItemsFor:targetType]];
  NSLog(@"BagItem: ORIGINAL:::%@", bagItems);
  NSInteger targetIndex = itemIndex * 2 + 1;
  NSLog(@"BagItem: targetIndex:%d", targetIndex);
  NSInteger quantity = [[bagItems objectAtIndex:targetIndex] intValue] - 1;
  if (quantity > 0)
    [bagItems replaceObjectAtIndex:targetIndex withObject:[NSString stringWithFormat:@"%d", quantity]];
  else
    [bagItems removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(targetIndex - 1, 2)]];
  NSString * bagItemsInString = [[bagItems valueForKey:@"description"] componentsJoinedByString:@","];
  NSLog(@"BagItem: RESULT:::%@", bagItemsInString);
  [self saveBagItemsFor:targetType withData:bagItemsInString];
  [bagItems release];
}

// BagItem - Add new
- (void)addBagItemsForType:(BagQueryTargetType)targetType
             withItemIndex:(NSInteger)itemIndex
                  quantity:(NSInteger)quantity {
  
}

// BagItem - Toss
- (void)tossBagItemsForType:(BagQueryTargetType)targetType
              withItemIndex:(NSInteger)itemIndex
                   quantity:(NSInteger)quantity {
  
}

#pragma mark - Private Methods

// Update Pokedex with Pokemon ID
- (void)updatePokedexWithPokemonID:(NSInteger)pokemonID {
  // If Pokemon already caught, do nothing
  if ([self.pokedex isBinary1AtIndex:pokemonID])
    return;
  self.entityTrainer.pokedex = [self.entityTrainer.pokedex generateHexBySettingBainaryTo1:YES atIndex:pokemonID];
  self.flag = self.flag | kDataModifyTrainer | kDataModifyTrainerPokedex;
}

// Save data for bag items
- (void)saveBagItemsFor:(BagQueryTargetType)targetType withData:(NSString *)data {
  if      (targetType & kBagQueryTargetTypeItem)       self.entityTrainer.bagItems = data;
  else if (targetType & kBagQueryTargetTypeMedicine) {
    if (targetType & kBagQueryTargetTypeMedicineStatus)  self.entityTrainer.bagMedicineStatus = data;
    else if (targetType & kBagQueryTargetTypeMedicineHP) self.entityTrainer.bagMedicineHP = data;
    else if (targetType & kBagQueryTargetTypeMedicinePP) self.entityTrainer.bagMedicinePP = data;
    else return;
  }
  else if (targetType & kBagQueryTargetTypePokeball)   self.entityTrainer.bagPokeballs = data;
  else if (targetType & kBagQueryTargetTypeTMHM)       self.entityTrainer.bagTMsHMs = data;
  else if (targetType & kBagQueryTargetTypeBerry)      self.entityTrainer.bagBerries = data;
  else if (targetType & kBagQueryTargetTypeMail)       return;
  else if (targetType & kBagQueryTargetTypeBattleItem) self.entityTrainer.bagBattleItems = data;
  else if (targetType & kBagQueryTargetTypeKeyItem)    self.entityTrainer.bagKeyItems = data;
  else return;
  
  self.flag = self.flag | kDataModifyTrainer | kDataModifyTrainerBag;
  [self saveWithSync:YES];
}

@end
