//
//  TrainerCoreData.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "TrainerController.h"

#import "GlobalNotificationConstants.h"
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
  NSLog(@"Init......");
  NSLog(@"|%@| - |initTrainerWithUserID:|...", [self class]);
  self.userID = userID;
  
  [Trainer             initWithUserID:self.userID];
  [TrainerTamedPokemon initWithUserID:self.userID];
  self.isInitialized = YES;
  
  self.entityTrainer     = [Trainer queryTrainerWithUserID:self.userID];
  self.entitySixPokemons = [[self.entityTrainer sixPokemons] mutableCopy];
  if (self.entitySixPokemons == nil)
    self.entitySixPokemons = [NSMutableArray array];
  
  // If user has no Pokemon brought (newbie),
  //   post notification to |MainViewController| to show view of |NewbiewGuideViewController|
  if ([self.entitySixPokemons count] == 0)
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNShowNewbieGuide object:self userInfo:nil];
}

// Save Client data to CoreData
-(void)save {
  NSLog(@"......SVEING DATA......");
  [Trainer save];
}

#pragma mark - Data Related Methods

// Sync data between Client & Server
- (void)sync {
  if (! self.userID) return;
  
  // C->S: If Client data has initialzied, just do sync Client to Server
  if (self.isInitialized) {
    NSLog(@"Sync.......");
    if (self.flag & kDataModifyTrainer)
      [Trainer             syncWithUserID:self.userID flag:self.flag];
//    if (self.flag & kDataModifyTamedPokemon)
//      [TrainerTamedPokemon syncWithUserID:self.userID pokemonUID:0 flag:self.flag];
//      [TrainerTamedPokemon syncWithUserID:self.userID flag:self.flag];
  }
  // S->C: Client data has not initialzied, so initialize it from Server to Client
  else {
    
    
  }
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
- (NSArray *) sixPokemons {return self.entitySixPokemons;}
- (NSInteger) numberOfSixPokemons {return [self.entityTrainer.sixPokemonsID length];}
// Avatar URL, asynchronously downloads the image with the specified url request object
- (NSURL *)   avatarURL   {
  return [NSURL URLWithString:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=100",
                               [[OAuthManager sharedInstance] userEmailInMD5]]];
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

#pragma mark - Settings

// Set |name| for Trainer
- (void)setName:(NSString *)name {
  self.entityTrainer.name = name;
  self.flag = self.flag | kDataModifyTrainer | kDataModifyTrainerName;
  [self save];
  [self sync];
}

// Transfer WildPokemon to TamedPokemon
// Add new TamedPokemon, 
- (void)caughtNewWildPokemon:(WildPokemon *)wildPokemon memo:(NSString *)memo {
  NSLog(@"|%@| - |caughtNewWildPokemon:| :: %@", [self class], wildPokemon);
  NSInteger box;
  // If count of |sixPokemons| is not |6|, add it there instead of |box|
  if ([self numberOfSixPokemons] < 6) {
    box = 0;
  }
  // Else, find a box to put new Pokemon
  //
  // !!!TODO:
  //   Need a model to store Pokemons in Boxes.
  //
  else {
    box = 1;
  }
  
  [TrainerTamedPokemon addPokemonWithWildPokemon:wildPokemon toBox:box withUserID:self.userID memo:memo];
  // If |box == 0|, add new Pokemon to |sixPokemons|
  if (box == 0) [self addPokemonToSixPokemonsWithPokemonUID:[wildPokemon.uid intValue]];
}

// Add Pokemon to |sixPokemons|
- (void)addPokemonToSixPokemonsWithPokemonUID:(NSInteger)pokemonUID {
  // Add new |pokemonUID| to |sixPokemons|
  [self.entityTrainer addPokemonToSixPokemonsWithPokemonUID:pokemonUID];
  
  // Refetch Pokemons for |sixPokemons|
  [self.entitySixPokemons addObject:[TrainerTamedPokemon queryPokemonDataWithUID:pokemonUID]];
  [self save];
}

@end
