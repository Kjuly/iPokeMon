//
//  OriginalDataManager.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/17/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "OriginalDataManager.h"

#import "AppDelegate.h"
#import "PListParser.h"

#import "Pokemon.h"
#import "Move.h"
#import "BagItem.h"
#import "BagMedicine.h"
#import "BagPokeball.h"
#import "BagTMHM.h"
#import "BagBerry.h"
#import "BagMail.h"
#import "BagBattleItem.h"
#import "BagKeyItem.h"

typedef enum {
  kEntityTypePokemon       = 1 << 0,
  kEntityTypeMove          = 1 << 1,
  kEntityTypeBagItem       = 1 << 2,
  kEntityTypeBagMedicine   = 1 << 3,
  kEntityTypeBagPokeball   = 1 << 4,
  kEntityTypeBagTMHM       = 1 << 5,
  kEntityTypeBagBerry      = 1 << 6,
  kEntityTypeBagMail       = 1 << 7,
  kEntityTypeBagBattleItem = 1 << 8,
  kEntityTypeBagKeyItem    = 1 << 9
}EntityType;


@interface OriginalDataManager ()
  
+ (void)initDataForEntityWithType:(EntityType)type;
+ (void)setDataForEntity:(id)entity withType:(EntityType)type dataDict:(NSDictionary *)dataDict index:(NSInteger)index;

@end


@implementation OriginalDataManager

// Init data for Pokemon, Move, BagXXX, etc.
+ (void)initData
{
  // Pokemon
  [self initDataForEntityWithType:kEntityTypePokemon];
  
  // Move
  [self initDataForEntityWithType:kEntityTypeMove];
  
  // BagXXXs
  [self initDataForEntityWithType:kEntityTypeBagItem];
  [self initDataForEntityWithType:kEntityTypeBagMedicine];
  [self initDataForEntityWithType:kEntityTypeBagPokeball];
  [self initDataForEntityWithType:kEntityTypeBagTMHM];
  [self initDataForEntityWithType:kEntityTypeBagBerry];
  [self initDataForEntityWithType:kEntityTypeBagMail];
  [self initDataForEntityWithType:kEntityTypeBagBattleItem];
  [self initDataForEntityWithType:kEntityTypeBagKeyItem];
}

#pragma mark - Private Methods

+ (void)initDataForEntityWithType:(EntityType)type
{
  NSArray * itemList;
  NSString * entityName;
  if (type & kEntityTypePokemon) {
    itemList = [PListParser pokedex];
    entityName = NSStringFromClass([Pokemon class]);
  }
  else if (type & kEntityTypeMove) {
    itemList = [PListParser moves];
    entityName = NSStringFromClass([Move class]);
  }
  else if (type & kEntityTypeBagItem) {
    itemList = [PListParser bagItems];
    entityName = NSStringFromClass([BagItem class]);
  }
  else if (type & kEntityTypeBagMedicine) {
    itemList   = [PListParser bagMedicine];
    entityName = NSStringFromClass([BagMedicine class]);
  }
  else if (type & kEntityTypeBagPokeball) {
    itemList   = [PListParser bagPokeballs];
    entityName = NSStringFromClass([BagPokeball class]);
  }
  else if (type & kEntityTypeBagTMHM) {
    itemList   = [PListParser bagTMsHMs];
    entityName = NSStringFromClass([BagTMHM class]);
  }
  else if (type & kEntityTypeBagBerry) {
    itemList   = [PListParser bagBerries];
    entityName = NSStringFromClass([BagBerry class]);
  }
  else if (type & kEntityTypeBagMail) {
    itemList   = [PListParser bagMail];
    entityName = NSStringFromClass([BagMail class]);
  }
  else if (type & kEntityTypeBagBattleItem) {
    itemList   = [PListParser bagBattleItems];
    entityName = NSStringFromClass([BagBattleItem class]);
  }
  else if (type & kEntityTypeBagKeyItem) {
    itemList   = [PListParser bagKeyItems];
    entityName = NSStringFromClass([BagKeyItem class]);
  }
  else return;
  
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSInteger i = 0;
  for (NSDictionary * itemDict in itemList) {
    id entity = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                              inManagedObjectContext:managedObjectContext];
    [self setDataForEntity:entity withType:type dataDict:itemDict index:++i];
    itemDict = nil;
    entity   = nil;
  }
  itemList = nil;
  
  NSError * error;
  if (! [managedObjectContext save:&error])
    NSLog(@"!!! Couldn't save data to %@", entityName);
}

// Set data for entity
+ (void)setDataForEntity:(id)entity
                withType:(EntityType)type
                dataDict:(NSDictionary *)dataDict
                   index:(NSInteger)index
{
  if (type & kEntityTypePokemon) {
    Pokemon * pokemon = entity;
    pokemon.sid           = [NSNumber numberWithInt:index];
    pokemon.image         = [UIImage imageNamed:[NSString stringWithFormat:@"%.3d.png", index]];
    pokemon.imageBack     = [UIImage imageNamed:[NSString stringWithFormat:@"PMSpriteBack_%d.png", index]];
    pokemon.imageIcon     = [UIImage imageNamed:[NSString stringWithFormat:@"PMIcon_%.3d.png", index - 1]];
    pokemon.type1         = [dataDict objectForKey:@"type1"];
    pokemon.type2         = [dataDict objectForKey:@"type2"];
    pokemon.species       = [dataDict objectForKey:@"species"];
    pokemon.color         = [dataDict objectForKey:@"color"];
    pokemon.height        = [dataDict objectForKey:@"height"];
    pokemon.weight        = [dataDict objectForKey:@"weight"];
    pokemon.ability1      = [dataDict objectForKey:@"ability1"];
    pokemon.ability2      = [dataDict objectForKey:@"ability2"];
    pokemon.hiddenAbility = [dataDict objectForKey:@"hiddenAbility"];
    pokemon.genderRate    = [dataDict objectForKey:@"genderRate"];
    pokemon.stepsToHatch  = [dataDict objectForKey:@"stepsToHatch"];
    pokemon.rareness      = [dataDict objectForKey:@"rareness"];
    pokemon.happiness     = [dataDict objectForKey:@"happiness"];
    pokemon.baseEXP       = [dataDict objectForKey:@"baseEXP"];
    pokemon.growthRate    = [dataDict objectForKey:@"growthRate"];
    pokemon.habitat       = [dataDict objectForKey:@"habitat"];
    pokemon.area          = [dataDict objectForKey:@"area"];
    pokemon.baseStats     = [dataDict objectForKey:@"baseStats"];
    pokemon.effortPoints  = [dataDict objectForKey:@"effortPoints"];
    pokemon.evolutions    = [dataDict objectForKey:@"evolutions"];
    pokemon.moves         = [dataDict objectForKey:@"moves"];
    pokemon.compatibility = [dataDict objectForKey:@"compatibility"];
    pokemon.eggMoves      = [dataDict objectForKey:@"eggMoves"];
    pokemon = nil;
  }
  else if (type & kEntityTypeMove) {
    Move * move = entity;
    move.sid                    = [NSNumber numberWithInt:index];
    move.type                   = [dataDict objectForKey:@"type"];
    move.category               = [dataDict objectForKey:@"category"];
    //move.contestType            = [dataDict objectForKey:@"contestType"];
    move.basePP                 = [dataDict objectForKey:@"basePP"];
    move.baseDamage             = [dataDict objectForKey:@"baseDamage"];
    //move.priority               = [dataDict objectForKey:@"priority"];
    move.effectCode             = [dataDict objectForKey:@"effectCode"];
    move.hitChance              = [dataDict objectForKey:@"hitChance"];
    //move.additionalEffectChance = [dataDict objectForKey:@"additionalEffectChance"];
    move.target                 = [dataDict objectForKey:@"target"];
    //move.flags                  = [dataDict objectForKey:@"flags"];
    move = nil;
  }
  else if (type & kEntityTypeBagItem) {
    BagItem * bagItem = entity;
    //((BagItem *)entity).icon = ;
    bagItem.sid      = [dataDict objectForKey:@"sid"];
    bagItem.type     = [dataDict objectForKey:@"type"];
    bagItem.code     = [dataDict objectForKey:@"code"];
    bagItem.price    = [dataDict objectForKey:@"price"];
    bagItem.location = [dataDict objectForKey:@"location"];
    bagItem = nil;
  }
  else if (type & kEntityTypeBagMedicine) {
    BagMedicine * bagMedicine = entity;
    //((BagMedicine *)entity).icon = ;
    bagMedicine.sid      = [dataDict objectForKey:@"sid"];
    bagMedicine.type     = [dataDict objectForKey:@"type"];
    bagMedicine.code     = [dataDict objectForKey:@"code"];
    bagMedicine.price    = [dataDict objectForKey:@"price"];
    bagMedicine.location = [dataDict objectForKey:@"location"];
    bagMedicine = nil;
  }
  else if (type & kEntityTypeBagPokeball) {
    BagPokeball * bagPokeball = entity;
    //((BagPokeball *)entity).icon = ;
    bagPokeball.sid      = [dataDict objectForKey:@"sid"];
    bagPokeball.type     = [dataDict objectForKey:@"type"];
    bagPokeball.code     = [dataDict objectForKey:@"code"];
    bagPokeball.price    = [dataDict objectForKey:@"price"];
    bagPokeball.location = [dataDict objectForKey:@"location"];
    bagPokeball = nil;
  }
  else if (type & kEntityTypeBagTMHM) {
  }
  else if (type & kEntityTypeBagBerry) {
    BagBerry * bagBerry = entity;
    //((BagBerry *)entity).icon = ;
    bagBerry.sid      = [dataDict objectForKey:@"sid"];
    bagBerry.type     = [dataDict objectForKey:@"type"];
    bagBerry.code     = [dataDict objectForKey:@"code"];
    bagBerry.location = [dataDict objectForKey:@"location"];
    bagBerry = nil;
  }
  else if (type & kEntityTypeBagMail) {
  }
  else if (type & kEntityTypeBagBattleItem) {
    BagBattleItem * bagBattleItem = entity;
    //((BagBattleItem *)entity).icon = ;
    bagBattleItem.sid      = [dataDict objectForKey:@"sid"];
    bagBattleItem.type     = [dataDict objectForKey:@"type"];
    bagBattleItem.code     = [dataDict objectForKey:@"code"];
    bagBattleItem.price    = [dataDict objectForKey:@"price"];
    bagBattleItem.location = [dataDict objectForKey:@"location"];
    bagBattleItem = nil;
  }
  else if (type & kEntityTypeBagKeyItem) {
    BagKeyItem * bagKeyItem = entity;
    //((BagBattleItem *)entity).icon = ;
    bagKeyItem.sid      = [dataDict objectForKey:@"sid"];
    bagKeyItem.type     = [dataDict objectForKey:@"type"];
    bagKeyItem.code     = [dataDict objectForKey:@"code"];
    bagKeyItem.location = [dataDict objectForKey:@"location"];
    bagKeyItem = nil;
  }
  else return;
}

@end
