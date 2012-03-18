//
//  TrainerCoreData.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "TrainerCoreDataController.h"


@interface TrainerCoreDataController () {
 @private
  Trainer * entityTrainer_;
  NSArray * entitySixPokemons_;
}

@property (nonatomic, retain) Trainer * entityTrainer;
@property (nonatomic, retain) NSArray * entitySixPokemons;

@end

@implementation TrainerCoreDataController

@synthesize entityTrainer     = entityTrainer_;
@synthesize entitySixPokemons = entitySixPokemons_;

static TrainerCoreDataController * trainerCoreDataController = nil;

// Singleton
+ (TrainerCoreDataController *)sharedInstance {
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

- (id)init
{
  if (self = [super init]) {
    self.entityTrainer     = [Trainer queryTrainerWithTrainerID:1];
    self.entitySixPokemons = self.entityTrainer.sixPokemons;
  }
  return self;
}

#pragma mark - Data Related Methods

- (Trainer *)trainer {
  return self.entityTrainer;
}

- (NSArray *)sixPokemons {
  return self.entitySixPokemons;
}

- (TrainerTamedPokemon *)firstPokemonOfSix {
  return [self.entitySixPokemons objectAtIndex:0];
}

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
