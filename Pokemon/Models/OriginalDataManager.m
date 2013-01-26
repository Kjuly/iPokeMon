//
//  OriginalDataManager.m
//  iPokeMon
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
  
+ (void)_updateDataForEntityWithType:(EntityType)type
                              bundle:(NSBundle *)bundle
                              isInit:(BOOL)isInit;
+ (void)_setDataForEntity:(id)entity
                 withType:(EntityType)type
                 dataDict:(NSDictionary *)dataDict
                    index:(NSInteger)index
                    extra:(NSDictionary *)extra;

@end


@implementation OriginalDataManager

// Update data with resource bundle
// If the bundle is not offered, use main bundle and init the data
+ (BOOL)updateDataWithResourceBundle:(NSBundle *)bundle {
  BOOL isInit = NO;
  if (bundle == nil) {
    NSLog(@"......INIT DATA with DEFAULT RESOURCE BUNDLE......");
    bundle = [NSBundle mainBundle];
    isInit = YES;
  }
  else NSLog(@"......UPDATING DATA with RESOURCE BUNDLE......");
  // Pokemon
  [self _updateDataForEntityWithType:kEntityTypePokemon       bundle:bundle isInit:isInit];
  
  // Move
  [self _updateDataForEntityWithType:kEntityTypeMove          bundle:bundle isInit:isInit];

  // BagXXXs
  [self _updateDataForEntityWithType:kEntityTypeBagItem       bundle:bundle isInit:isInit];
  [self _updateDataForEntityWithType:kEntityTypeBagMedicine   bundle:bundle isInit:isInit];
  [self _updateDataForEntityWithType:kEntityTypeBagPokeball   bundle:bundle isInit:isInit];
  [self _updateDataForEntityWithType:kEntityTypeBagTMHM       bundle:bundle isInit:isInit];
  [self _updateDataForEntityWithType:kEntityTypeBagBerry      bundle:bundle isInit:isInit];
  [self _updateDataForEntityWithType:kEntityTypeBagMail       bundle:bundle isInit:isInit];
  [self _updateDataForEntityWithType:kEntityTypeBagBattleItem bundle:bundle isInit:isInit];
  [self _updateDataForEntityWithType:kEntityTypeBagKeyItem    bundle:bundle isInit:isInit];
  return YES;
}

#pragma mark - Private Methods

+ (void)_updateDataForEntityWithType:(EntityType)type
                              bundle:(NSBundle *)bundle
                              isInit:(BOOL)isInit {
  NSArray * itemList;
  NSString * entityName;
  if (type & kEntityTypePokemon) {
    itemList = [PListParser pokedexInBundle:bundle];
    entityName = NSStringFromClass([Pokemon class]);
  }
  else if (type & kEntityTypeMove) {
    itemList = [PListParser movesInBundle:bundle];
    entityName = NSStringFromClass([Move class]);
  }
  else if (type & kEntityTypeBagItem) {
    itemList = [PListParser bagItemsInBundle:bundle];
    entityName = NSStringFromClass([BagItem class]);
  }
  else if (type & kEntityTypeBagMedicine) {
    itemList   = [PListParser bagMedicineInBundle:bundle];
    entityName = NSStringFromClass([BagMedicine class]);
  }
  else if (type & kEntityTypeBagPokeball) {
    itemList   = [PListParser bagPokeballsInBundle:bundle];
    entityName = NSStringFromClass([BagPokeball class]);
  }
  else if (type & kEntityTypeBagTMHM) {
    itemList   = [PListParser bagTMsHMsInBundle:bundle];
    entityName = NSStringFromClass([BagTMHM class]);
  }
  else if (type & kEntityTypeBagBerry) {
    itemList   = [PListParser bagBerriesInBundle:bundle];
    entityName = NSStringFromClass([BagBerry class]);
  }
  else if (type & kEntityTypeBagMail) {
    itemList   = [PListParser bagMailInBundle:bundle];
    entityName = NSStringFromClass([BagMail class]);
  }
  else if (type & kEntityTypeBagBattleItem) {
    itemList   = [PListParser bagBattleItemsInBundle:bundle];
    entityName = NSStringFromClass([BagBattleItem class]);
  }
  else if (type & kEntityTypeBagKeyItem) {
    itemList   = [PListParser bagKeyItemsInBundle:bundle];
    entityName = NSStringFromClass([BagKeyItem class]);
  }
  else return;
  
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSError * error = nil;
  id entity;
  NSInteger i = 0;
  // Init data
  if (isInit) {
    for (NSDictionary * itemDict in itemList) {
      entity = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                             inManagedObjectContext:managedObjectContext];
      [self _setDataForEntity:entity withType:type dataDict:itemDict index:++i extra:nil];
    }
  }
  // Update data
  else {
    entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"sid" ascending:YES]]];
    NSArray * entities = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    
    NSArray * pathOfImageIcons, * pathOfImages, * pathOfImageBacks;
    // Prepare extra data for special type
    if (type & kEntityTypePokemon) {
      pathOfImageIcons = [bundle pathsForResourcesOfType:@"png" inDirectory:kBundleDirectoryOfImageSpriteIcon];
      pathOfImages     = [bundle pathsForResourcesOfType:@"png" inDirectory:kBundleDirectoryOfImageSprite];
      pathOfImageBacks = [bundle pathsForResourcesOfType:@"png" inDirectory:kBundleDirectoryOfImageSpriteBack];
    }
    NSDictionary * extra = nil;
    for (NSDictionary * itemDict in itemList) {
      // Set extra data for special type
      if (type & kEntityTypePokemon)
        extra = @{@"imageIcon" : [pathOfImageIcons objectAtIndex:i],
                  @"image"     : [pathOfImages     objectAtIndex:i],
                  @"imageBack" : [pathOfImageBacks objectAtIndex:i]};
      else extra = nil;
      [self _setDataForEntity:[entities objectAtIndex:i++]
                     withType:type
                     dataDict:itemDict
                        index:0
                        extra:extra];
    }
  }
  if (! [managedObjectContext save:&error])
    NSLog(@"!!! Couldn't save data to %@, ERROR:%@", entityName, [error description]);
}

// Set data for entity
+ (void)_setDataForEntity:(id)entity
                 withType:(EntityType)type
                 dataDict:(NSDictionary *)dataDict
                    index:(NSInteger)index
                    extra:(NSDictionary *)extra {
  if (type & kEntityTypePokemon) {
    Pokemon * pokemon = entity;
    if (index) pokemon.sid = [NSNumber numberWithInt:index];
    if (extra) {
      pokemon.imageIcon = [UIImage imageWithContentsOfFile:extra[@"imageIcon"]];
      pokemon.image     = [UIImage imageWithContentsOfFile:extra[@"image"]];
      pokemon.imageBack = [UIImage imageWithContentsOfFile:extra[@"imageBack"]];
    }
    else {
      pokemon.image     = [UIImage imageNamed:[NSString stringWithFormat:@"%.3d.png", index]];
      pokemon.imageBack = [UIImage imageNamed:[NSString stringWithFormat:@"PMSpriteBack_%.3d.png", index]];
      pokemon.imageIcon = [UIImage imageNamed:[NSString stringWithFormat:@"PMIcon_%.3d.png", index - 1]];
    }
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
    if (index) move.sid = [NSNumber numberWithInt:index];
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
    if (index) bagItem.sid = [dataDict objectForKey:@"sid"];
    bagItem.type     = [dataDict objectForKey:@"type"];
    bagItem.code     = [dataDict objectForKey:@"code"];
    bagItem.price    = [dataDict objectForKey:@"price"];
    bagItem.location = [dataDict objectForKey:@"location"];
    bagItem = nil;
  }
  else if (type & kEntityTypeBagMedicine) {
    BagMedicine * bagMedicine = entity;
    //((BagMedicine *)entity).icon = ;
    if (index) bagMedicine.sid = [dataDict objectForKey:@"sid"];
    bagMedicine.type     = [dataDict objectForKey:@"type"];
    bagMedicine.code     = [dataDict objectForKey:@"code"];
    bagMedicine.price    = [dataDict objectForKey:@"price"];
    bagMedicine.location = [dataDict objectForKey:@"location"];
    bagMedicine = nil;
  }
  else if (type & kEntityTypeBagPokeball) {
    BagPokeball * bagPokeball = entity;
    //((BagPokeball *)entity).icon = ;
    if (index) bagPokeball.sid = [dataDict objectForKey:@"sid"];
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
    if (index) bagBerry.sid = [dataDict objectForKey:@"sid"];
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
    if (index) bagBattleItem.sid = [dataDict objectForKey:@"sid"];
    bagBattleItem.type     = [dataDict objectForKey:@"type"];
    bagBattleItem.code     = [dataDict objectForKey:@"code"];
    bagBattleItem.price    = [dataDict objectForKey:@"price"];
    bagBattleItem.location = [dataDict objectForKey:@"location"];
  }
  else if (type & kEntityTypeBagKeyItem) {
    BagKeyItem * bagKeyItem = entity;
    //((BagBattleItem *)entity).icon = ;
    if (index) bagKeyItem.sid = [dataDict objectForKey:@"sid"];
    bagKeyItem.type     = [dataDict objectForKey:@"type"];
    bagKeyItem.code     = [dataDict objectForKey:@"code"];
    bagKeyItem.location = [dataDict objectForKey:@"location"];
  }
  else return;
}

@end
