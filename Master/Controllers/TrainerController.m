//
//  TrainerCoreData.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "TrainerController.h"

#import "AppDelegate.h"
#import "NSString+Algorithm.h"
#import "LoadingManager.h"
#import "OAuthManager.h"
#import "ServerAPIClient.h"
#import "Trainer+DataController.h"


@interface TrainerController () {
 @private
  Trainer        * entityTrainer_;     // Trainer
  NSMutableArray * entitySixPokemons_; // SixPokemons
  
  BOOL             isInitialized_;     // Is initialized for current user
  DataModifyFlag   flag_;              // Data modify flag
  NSInteger        userID_;            // User ID, same as Trainer UID
}

@property (nonatomic, strong) Trainer        * entityTrainer;
@property (nonatomic, strong) NSMutableArray * entitySixPokemons;

- (BOOL)_isTrainerOwnsThisDevice;
- (NSString *)_keyForDeviceUID;
- (NSString *)_resetDeviceUIDWithTrainerUID:(NSInteger)trainerUID;

- (void)_resetUser:(NSNotification *)notification;
- (void)_initTrainer;
- (void)_newbieChecking;
- (void)_saveBagItemsFor:(BagQueryTargetType)targetType withData:(NSString *)data;

@end


@implementation TrainerController

@synthesize entityTrainer     = entityTrainer_;
@synthesize entitySixPokemons = entitySixPokemons_;

// Singleton
static TrainerController * trainerController_ = nil;
+ (TrainerController *)sharedInstance
{
  // Check Session first,
  //   if it's not valid, post notification to |MainViewController| to show login view & return nil
  if (! [[OAuthManager sharedInstance] isSessionValid]) {
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNSessionIsInvalid
                                                        object:self
                                                      userInfo:nil];
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
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
  if (self = [super init]) {
    [self _resetUser:nil];
    // Notif from |OAuthManager|, reset data when user logout
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_resetUser:)
                                                 name:kPMNUserLogout
                                               object:nil];
  }
  return self;
}

// It is called at method:|syncUserID| in |OAuthManager| after user has authticated
- (void)initTrainerWithUserID:(NSInteger)userID
{
  if (isInitialized_)
    return;
  NSLog(@"- INIT trainer with User ID:%d", userID);
  userID_ = userID;
  
  // If the trainer own this device, initialize the data from server to client
  if ([self _isTrainerOwnsThisDevice]) [self _initTrainer];
  // Otherwise, ban user action
  else {
    NSLog(@"- Current Trainer does NOT Own this Device, BAN User Action!");
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    // Post notifi to ban user action
    [notificationCenter postNotificationName:kPMNBanUserAction
                                      object:[NSNumber numberWithInt:kPMDeviceBlockingTypeOfUIDNotMatched]];
    // Add observer for reseting device's UID
    [notificationCenter addObserverForName:kPMNResetDeviceUID
                                    object:nil
                                     queue:nil
                                usingBlock:^(NSNotification *note) {
                                  // Reset device's UID
                                  [self _resetDeviceUIDWithTrainerUID:userID_];
                                  // Initialize trainer's data
                                  [self _initTrainer];
                                }];
  }
}

// Save Client data to CoreData
- (void)saveWithSync:(BOOL)withSync
{
  NSLog(@"......SAVING DATA......");
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
  
  // Sync data to Server
  if (withSync) [self sync];
}

#pragma mark - Data Related Methods

// Sync data between Client & Server
- (void)sync
{
  if (! userID_) return;
  
  // C->S: If Client data has initialzied, just do sync Client to Server
  if (isInitialized_) {
    NSLog(@"......SYNC.......");
    if (flag_ & kDataModifyTrainer)
      [self.entityTrainer syncWithFlag:flag_];
  }
}

// Add modify flag for |flag_|
- (void)addModifyFlag:(DataModifyFlag)flag
{
  flag_ |= flag;
}

// Dispatch this method after Sync done
// It can be dispatched in URL Request Callback method
- (void)syncDoneWithFlag:(DataModifyFlag)flag
{
  flag_ -= flag;
  
  // If sync data for Trainer done, set all related flags to 0
  if (flag & kDataModifyTrainer) {
    flag_ &= (00000000 << 0);
  }
  // If sync data for Tamed Pokemon done, set all related flags to 0
  if (flag & kDataModifyTamedPokemon) {
    flag_ &= (0000 << 8);
  }
}

// Return device's UID (Unique IDentifier)
- (NSString *)deviceUID
{
  NSString * deviceUID       = nil;
  NSString * keyForDeviceUID = [self _keyForDeviceUID];
  
  // UID must be persistent even if the application is removed from devices
  // Use keychain as a storage
  NSDictionary * query = [NSDictionary dictionaryWithObjectsAndKeys:
                          (__bridge id)kSecClassGenericPassword,            (__bridge id)kSecClass,
                          keyForDeviceUID,                         (__bridge id)kSecAttrGeneric,
                          keyForDeviceUID,                         (__bridge id)kSecAttrAccount,
                          [[NSBundle mainBundle] bundleIdentifier],(__bridge id)kSecAttrService,
                          (__bridge id)kSecMatchLimitOne,                   (__bridge id)kSecMatchLimit,
                          (id)kCFBooleanTrue,                      (__bridge id)kSecReturnAttributes,
                          nil];
  CFTypeRef attributesRef = NULL;
  OSStatus result = SecItemCopyMatching((__bridge CFDictionaryRef)query, &attributesRef);
  if (result == noErr) {
    NSDictionary * attributes = (__bridge NSDictionary *)attributesRef;
    NSMutableDictionary * valueQuery = [NSMutableDictionary dictionaryWithDictionary:attributes];
    
    [valueQuery setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [valueQuery setObject:(id)kCFBooleanTrue           forKey:(__bridge id)kSecReturnData];
    
    CFTypeRef passwordDataRef = NULL;
    OSStatus result = SecItemCopyMatching((__bridge CFDictionaryRef)valueQuery, &passwordDataRef);
    if (result == noErr) {
      NSData *passwordData = (__bridge NSData *)passwordDataRef;
      // Assume the stored data is a UTF-8 string.
      deviceUID = [[NSString alloc] initWithBytes:[passwordData bytes]
                                           length:[passwordData length]
                                         encoding:NSUTF8StringEncoding];
    }
  }
  
  // Generate a new UID for device if it does not exist
  if (deviceUID == nil || [deviceUID isEqualToString:@""] || [deviceUID isEqualToString:@"0"])
    deviceUID = [self _resetDeviceUIDWithTrainerUID:userID_];
  NSLog(@"- Device UID: %@", deviceUID);
  return deviceUID;
}

// Trainer's basic data
- (NSInteger) UID         {return userID_;}
- (NSString *)name        {return self.entityTrainer.name;}
- (NSInteger) money       {return [self.entityTrainer.money intValue];}
- (NSArray *) badges      {return [self.entityTrainer.badges componentsSeparatedByString:@","];}
- (NSDate *)  timeStarted {return self.entityTrainer.adventureStarted;}
- (NSString *)pokedex     {return self.entityTrainer.pokedex;}
- (NSInteger) numberOfPokemonsForPokedex {return [self.entityTrainer.pokedex numberOfBinary1];}
- (NSInteger) numberOfTamedPokemons      {return [TrainerTamedPokemon numberOfTamedPokemonsWithTraienrUID:userID_];}
- (NSArray *) sixPokemons {return self.entitySixPokemons;}
- (NSString *)sixPokemonsUID {return self.entityTrainer.sixPokemonsID;}
- (NSInteger) numberOfSixPokemons {
  return [[self.entityTrainer.sixPokemonsID componentsSeparatedByString:@","] count];
}
// Avatar URL, asynchronously downloads the image with the specified url request object
- (NSURL *)avatarURL
{
  return [NSURL URLWithString:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=200",
                               [[OAuthManager sharedInstance] userEmailInMD5]]];
}

// Return first Pokemon of six Pokemons
- (TrainerTamedPokemon *)firstPokemonOfSix
{
  return [self.entitySixPokemons objectAtIndex:0];
}

// Return Pokemon at |index|(1-6) of six Pokemons
- (TrainerTamedPokemon *)pokemonOfSixAtIndex:(NSInteger)index
{
  if (index < 1 || index > 6)
    return nil;
  return [self.entitySixPokemons objectAtIndex:--index];
}

// Check whether Pokemons in Six can battle,
//   and return the first battleable one's index
- (NSInteger)battleAvailablePokemonIndex
{
  NSInteger i = 1;
  for (TrainerTamedPokemon *pokemon in self.entitySixPokemons) {
    if ([pokemon.hp intValue] > 0)
      return i;
    ++i;
  }
  return 0;
}

// Return all items for the bag item type (BagItem, BagMedicine, BagBerry, etc)
- (NSArray *)bagItemsFor:(BagQueryTargetType)targetType
{
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
- (void)setName:(NSString *)name
{
  self.entityTrainer.name = name;
  flag_ = flag_ | kDataModifyTrainer | kDataModifyTrainerName;
  [self saveWithSync:YES];
}

// earn money when WIN from another trainer or exchange between currency
- (void)earnMoney:(NSInteger)money
{
  // cannot earn more than 10000 at once
  if (money <= 0 || money > 10000)
    return;
  NSInteger currMoney = [self.entityTrainer.money intValue];
  currMoney += money;
  self.entityTrainer.money = [NSNumber numberWithInt:currMoney];
  flag_ = flag_ | kDataModifyTrainer | kDataModifyTrainerMoney;
  [self saveWithSync:YES];
}

// consume money when LOSE or buy items in Store
- (void)consumeMoney:(NSInteger)money
{
  if (money <= 0)
    return;
  NSInteger currMoney = [self.entityTrainer.money intValue];
  currMoney -= money;
  self.entityTrainer.money = [NSNumber numberWithInt:currMoney];
  flag_ = flag_ | kDataModifyTrainer | kDataModifyTrainerMoney;
  [self saveWithSync:YES];
}

// Update Pokedex with Pokemon ID
- (void)updatePokedexWithPokemonSID:(NSInteger)pokemonSID
{
  // If Pokemon already caught, do nothing
  if ([self.pokedex isBinary1AtIndex:pokemonSID])
    return;
  self.entityTrainer.pokedex = [self.entityTrainer.pokedex generateHexBySettingBinaryTo1:YES atIndex:pokemonSID];
  flag_ = flag_ | kDataModifyTrainer | kDataModifyTrainerPokedex;
}

// Transfer WildPokemon to TamedPokemon
// Add new TamedPokemon, 
- (void)caughtNewWildPokemon:(WildPokemon *)wildPokemon
                        memo:(NSString *)memo
{
  NSLog(@"Wild Pokemon:%@", wildPokemon);
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
  [TrainerTamedPokemon addPokemonWithWildPokemon:wildPokemon
                                        withMemo:memo
                                           toBox:box
                                      forTrainer:self.entityTrainer];
  // Update Pokedex
  [self updatePokedexWithPokemonSID:[wildPokemon.sid intValue]];
  // If |box == 0|, add new Pokemon to |sixPokemons|
  if (box == 0)
    [self addPokemonToSixPokemonsWithPokemonUID:[self numberOfTamedPokemons]];
  
  // Save & sync data
  [self saveWithSync:YES];
}

// Add Pokemon to |sixPokemons|
- (void)addPokemonToSixPokemonsWithPokemonUID:(NSInteger)pokemonUID
{
  // add new |pokemonUID| to |sixPokemons|
  [self.entityTrainer addPokemonToSixPokemonsWithPokemonUID:pokemonUID];
  // append new Pokemon to |sixPokemons|
  [self.entitySixPokemons addObject:
    [TrainerTamedPokemon queryPokemonDataWithUID:pokemonUID trainerUID:userID_]];
  // set flag for updating
  flag_ = flag_ | kDataModifyTrainer | kDataModifyTrainerSixPokemons;
}

// Replace Pokemon's index order
- (void)replacePokemonAtIndex:(NSInteger)sourceIndex
                      toIndex:(NSInteger)destinationIndex
{
  NSLog(@"Original SixPokemons:%@", self.entityTrainer.sixPokemonsID);
  NSLog(@"Moved sourceIndex:%d -> destinationIndex:%d", sourceIndex + 1, destinationIndex + 1);
  NSMutableArray * sixPokemonsID =
    [[NSMutableArray alloc] initWithArray:[self.entityTrainer.sixPokemonsID componentsSeparatedByString:@","]];
  id sourceObject      = [sixPokemonsID objectAtIndex:sourceIndex];
  id destinationObject = [sixPokemonsID objectAtIndex:destinationIndex];
  [sixPokemonsID replaceObjectAtIndex:sourceIndex withObject:destinationObject];
  [sixPokemonsID replaceObjectAtIndex:destinationIndex withObject:sourceObject];
  
  // Save & Sync data
  self.entityTrainer.sixPokemonsID = [sixPokemonsID componentsJoinedByString:@","];
  flag_ = flag_ | kDataModifyTrainer | kDataModifyTrainerSixPokemons;
  NSLog(@"Replaced SixPokemons:%@", self.entityTrainer.sixPokemonsID);
  [self saveWithSync:NO];
  
  // Refetch data of Six Pokemons
  self.entitySixPokemons = [NSMutableArray arrayWithArray:[self.entityTrainer sixPokemons]];
}

// BagItem - Use
- (void)useBagItemForType:(BagQueryTargetType)targetType
            withItemIndex:(NSInteger)itemIndex
{
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
  [self _saveBagItemsFor:targetType withData:bagItemsInString];
}

// BagItem - Add new
- (void)addBagItemsForType:(BagQueryTargetType)targetType
               withItemSID:(NSInteger)itemSID
                  quantity:(NSInteger)quantity
{
  NSMutableArray * bagItems = [[NSMutableArray alloc] initWithArray:[self bagItemsFor:targetType]];
  NSLog(@"BagItem: ORIGINAL:::%@ NEW ITEM SID:%d", bagItems, itemSID);
  // check whether the item exists, if exists, increase the quantity,
  //   otherwise, append new item with quantity
  BOOL itemExists = NO;
  NSInteger targetIndex = 0;
  for (NSInteger i = 0; i < [bagItems count]; i += 2) {
    if ([[bagItems objectAtIndex:i] intValue] != itemSID)
      continue;
    itemExists  = YES;
    targetIndex = ++i;
    break;
  }
  if (itemExists) {
    NSInteger currQuantity = [[bagItems objectAtIndex:targetIndex] intValue];
    [bagItems replaceObjectAtIndex:targetIndex withObject:
      [NSString stringWithFormat:@"%d", (currQuantity + quantity)]];
  }
  else {
    [bagItems addObject:[NSString stringWithFormat:@"%d", itemSID]];
    [bagItems addObject:[NSString stringWithFormat:@"%d", quantity]];
  }
  
  // save
  NSString * bagItemsInString = [[bagItems valueForKey:@"description"] componentsJoinedByString:@","];
  NSLog(@"BagItem: RESULT:::%@", bagItemsInString);
  [self _saveBagItemsFor:targetType withData:bagItemsInString];
}

// BagItem - Toss
- (void)tossBagItemsForType:(BagQueryTargetType)targetType
              withItemIndex:(NSInteger)itemIndex
                   quantity:(NSInteger)quantity
{
}

#pragma mark - Private Methods

// Device's ownership checking
- (BOOL)_isTrainerOwnsThisDevice
{
  return (userID_ == [[self deviceUID] integerValue]);
}

// Return the key of keychain for device's UID
- (NSString *)_keyForDeviceUID
{
#ifdef APPLY_SECRET_DEVICE_UID_KEY
  return kDeviceUIDKey;
#else
  return @"Master:Device:UID:Key";
#endif
}

// Return reset device's UID with trainer's UID
// It'll be occured only in two cases:
//   - Device's UID is empty
//   - User purchases the "Reassign Device Owner" to get the privilege
//     for the current trainer role
- (NSString *)_resetDeviceUIDWithTrainerUID:(NSInteger)trainerUID
{
  if (trainerUID <= 0) {
    NSLog(@"!!!ERROR: Invalid |trainerUID|: %d", trainerUID);
    return @"";
  }
  NSLog(@"- RESET Device UID with Trainer UID: %d", trainerUID);
  // Reset device UID
  NSString * deviceUID       = [NSString stringWithFormat:@"%d", trainerUID];
  
  // Key for device UID
  NSString * keyForDeviceUID = [self _keyForDeviceUID];
  // UID must be persistent even if the application is removed from devices
  // Use keychain as a storage
  NSMutableDictionary * query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 (__bridge id)kSecClassGenericPassword,             (__bridge id)kSecClass,
                                 keyForDeviceUID,                          (__bridge id)kSecAttrGeneric,
                                 keyForDeviceUID,                          (__bridge id)kSecAttrAccount,
                                 [[NSBundle mainBundle] bundleIdentifier], (__bridge id)kSecAttrService,
                                 @"",                                      (__bridge id)kSecAttrLabel,
                                 @"",                                      (__bridge id)kSecAttrDescription,
                                 nil];
  // Set |kSecAttrAccessibleAfterFirstUnlock|
  //   so that background applications are able to access this key.
  // Keys defined as |kSecAttrAccessibleAfterFirstUnlock|
  //   will be migrated to the new devices/installations via encrypted backups.
  // If you want different UID per device,
  //   use |kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly| instead.
  // Keep in mind that keys defined
  //   as |kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly|
  //   will be removed after restoring from a backup.
  [query setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlock
            forKey:(__bridge id)kSecAttrAccessible];
  // Set UID
  [query setObject:[deviceUID dataUsingEncoding:NSUTF8StringEncoding]
            forKey:(__bridge id)kSecValueData];
  
  // Delete old one first
  OSStatus result = SecItemDelete((__bridge CFDictionaryRef)query);
  if (result == noErr)
    NSLog(@"- Device UID is successfully reset.");
  else if (result == errSecItemNotFound)
    NSLog(@"- Device UID is successfully reset.");
  else
    NSLog(@"!!!ERROR: Coudn't delete the Keychain Item. result = %ld query = %@", result, query);
  
  // Add new
  result = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
  if (result != noErr) {
    NSLog(@"!!!ERROR: Couldn't add the Keychain Item. result = %ld, query = %@", result, query);
    return nil;
  }
  return deviceUID;
}

// reset data for user when logout
- (void)_resetUser:(NSNotification *)notification
{
  NSLog(@"RESET");
  isInitialized_ = NO;
  flag_          = 0;
  self.entityTrainer     = nil;
  self.entitySixPokemons = nil;
}

// Initialize trainer's data from Server to Client
- (void)_initTrainer
{
  // |completion| block that will be executed after |Trainer|'s data initialized
  void (^completion)() = ^{
    // Fetch Trainer data from Client (CoreData)
    self.entityTrainer = [Trainer queryTrainerWithUserID:userID_];
    isInitialized_ = YES;
    
    // |completion| block that will be executed after |TrainerTamedPokemon|'s data initialized
    void (^completion)() = ^{
      // Fetch Trainer's Six Pokemons data from Client (CoreData)
      self.entitySixPokemons = [NSMutableArray arrayWithArray:[self.entityTrainer sixPokemons]];
      if (self.entitySixPokemons == nil || [self.entitySixPokemons count] == 0) {
        NSLog(@"!!! self.entitySixPokemons == nil...");
        self.entitySixPokemons = nil;
        self.entitySixPokemons = [NSMutableArray array];
      }
      // If user has no Pokemon in PokeDEX (newbie),
      //   post notification to |MainViewController| to show view of |NewbiewGuideViewController|
      [self _newbieChecking];
    };
    // S->C: Initialize TrainerTamedPokemon data from Server to Client
    [TrainerTamedPokemon initWithTrainer:self.entityTrainer completion:completion];
  };
  
  // S->C: Initialize trainer's data from Server to Client
  [Trainer initWithUserID:userID_ completion:completion];
}

// Newbie checking
- (void)_newbieChecking
{
  // If user already has Pokemon in PokeDEX (not newbie), just do nothing
  //   otherwise, post notification to |MainViewController| to show view of |NewbiewGuideViewController|
  if ([self.entityTrainer.pokedex intValue])
    return;
  NSLog(@"- NEWBIE CHECKING......");
  
  // Show loading
  [[LoadingManager sharedInstance] showOverView];
  // Block: |success| & |failure|
  void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"...Checking CONNECTION to SERVER...");
    // If connection to server succeed, post notification to |MainViewController|,
    //   to show the view of |NewbieGuideViewController|
    if ([responseObject valueForKey:@"v"])
      [[NSNotificationCenter defaultCenter] postNotificationName:kPMNShowNewbieGuide object:self userInfo:nil];
    // Hide loading
    [[LoadingManager sharedInstance] hideOverView];
  };
  void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"!!! CONNECTION to SERVER failed, ERROR: %@", error);
    // If connection to server faild, post notification to |MainViewController|,
    //   to show a info of CONNECTION ERROR
    NSDictionary * userInfo =
      [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:kPMErrorNetworkNotAvailable], @"error", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNError object:self userInfo:userInfo];
    // Hide loading
    [[LoadingManager sharedInstance] hideOverView];
  };
  [[ServerAPIClient sharedInstance] checkConnectionToServerSuccess:success failure:failure];
}

// Save data for bag items
- (void)_saveBagItemsFor:(BagQueryTargetType)targetType
                withData:(NSString *)data
{
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
  
  flag_ = flag_ | kDataModifyTrainer | kDataModifyTrainerBag;
  [self saveWithSync:YES];
}

@end
