//
//  TrainerCoreData.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "TrainerCoreDataController.h"

#import "GlobalNotificationConstants.h"
#import "OAuthManager.h"


@interface TrainerCoreDataController () {
 @private
  BOOL        isInitialized_;     // Is initialized for current user
  NSInteger   userID_;            // User ID, same as Trainer UID
  Trainer   * entityTrainer_;     // Trainer
  NSArray   * entitySixPokemons_; // SixPokemons
}

@property (nonatomic, assign) BOOL        isInitialized;
@property (nonatomic, assign) NSInteger   userID;
@property (nonatomic, retain) Trainer   * entityTrainer;
@property (nonatomic, retain) NSArray   * entitySixPokemons;

@end

@implementation TrainerCoreDataController

@synthesize isInitialized     = isInitialized_;
@synthesize userID            = userID_;
@synthesize entityTrainer     = entityTrainer_;
@synthesize entitySixPokemons = entitySixPokemons_;

static TrainerCoreDataController * trainerCoreDataController = nil;

// Singleton
+ (TrainerCoreDataController *)sharedInstance {
  // Check Session first,
  //   if it's not valid, post notification to |MainViewController| to show login view & return nil
  if (! [[OAuthManager sharedInstance] isSessionValid]) {
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNSessionIsInvalid object:self userInfo:nil];
    return nil;
  }
  
  if (trainerCoreDataController != nil)
    return trainerCoreDataController;
  
  static dispatch_once_t onceToken; // Lock
  dispatch_once(&onceToken, ^{      // This code is called at most once per app
    trainerCoreDataController = [[TrainerCoreDataController alloc] init];
  });
  return trainerCoreDataController;
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
  }
  return self;
}

// It is called at method:|syncUserID| in |OAuthManager| after user has authticated
- (void)initTrainerWithUserID:(NSInteger)userID {
  self.userID            = userID;
  self.entityTrainer     = [Trainer queryTrainerWithTrainerID:self.userID];
  self.entitySixPokemons = self.entityTrainer.sixPokemons;
}

#pragma mark - Data Related Methods

// Sync data between Client & Server
- (void)sync {
  // If Client data is not initialzied, do it
  if (! self.isInitialized) {
    [Trainer             initWithUserID:self.userID];
    [TrainerTamedPokemon initWithUserID:self.userID];
    self.isInitialized = YES;
  }
  // Sync data...
  [WildPokemon updateDataForCurrentRegion:self.userID];
}

// Return trainer entity
- (Trainer *)trainer {
  return self.entityTrainer;
}

// Return six Pokemons
- (NSArray *)sixPokemons {
  return self.entitySixPokemons;
}

// Return first Pokemon of six Pokemons
- (TrainerTamedPokemon *)firstPokemonOfSix {
  return [self.entitySixPokemons objectAtIndex:0];
}

// Return Pokemon at |index|(1-6) of six Pokemons
- (TrainerTamedPokemon *)pokemonOfSixAtIndex:(NSInteger)index {
  return [self.entitySixPokemons objectAtIndex:--index];
}

// Return all items for the bag item type (BagItem, BagMedicine, BagBerry, etc)
- (NSArray *)bagItemsFor:(BagQueryTargetType)targetType {
  if      (targetType & kBagQueryTargetTypeItem)       return self.entityTrainer.bagItems;
  else if (targetType & kBagQueryTargetTypeMedicine) {
    if (targetType & kBagQueryTargetTypeMedicineStatus)  return self.entityTrainer.bagMedicineStatus;
    else if (targetType & kBagQueryTargetTypeMedicineHP) return self.entityTrainer.bagMedicineHP;
    else if (targetType & kBagQueryTargetTypeMedicinePP) return self.entityTrainer.bagMedicinePP;
    else return nil;
  }
  else if (targetType & kBagQueryTargetTypePokeball)   return self.entityTrainer.bagPokeballs;
  else if (targetType & kBagQueryTargetTypeTMHM)       return self.entityTrainer.bagTMsHMs;
  else if (targetType & kBagQueryTargetTypeBerry)      return self.entityTrainer.bagBerries;
  else if (targetType & kBagQueryTargetTypeMail)       return nil;
  else if (targetType & kBagQueryTargetTypeBattleItem) return self.entityTrainer.bagBattleItems;
  else if (targetType & kBagQueryTargetTypeKeyItem)    return self.entityTrainer.bagKeyItems;
  else return nil;
}

@end
