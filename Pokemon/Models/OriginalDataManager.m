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
#import "BagItem.h"
#import "BagMedicine.h"
#import "BagPokeball.h"
#import "BagTMHM.h"
#import "BagBerry.h"
#import "BagMail.h"
#import "BagBattleItem.h"
#import "BagKeyItem.h"

typedef enum {
  kBagItemTypeItem       = 0,
  kBagItemTypeMedicine   = 1 << 0,
  kBagItemTypePokeball   = 1 << 1,
  kBagItemTypeTMHM       = 1 << 2,
  kBagItemTypeBerry      = 1 << 3,
  kBagItemTypeMail       = 1 << 4,
  kBagItemTypeBattleItem = 1 << 5,
  kBagItemTypeKeyItem    = 1 << 6
}BagItemType;


@interface OriginalDataManager ()
  
+ (void)initDataForBagType:(BagItemType)type;
+ (void)setDataForEntity:(id)entity withType:(BagItemType)type dataDict:(NSDictionary *)dataDict;

@end


@implementation OriginalDataManager

// Init data for Bag
+ (void)initDataForBag
{
  [self initDataForBagType:kBagItemTypeItem];
  [self initDataForBagType:kBagItemTypeMedicine];
  [self initDataForBagType:kBagItemTypePokeball];
  [self initDataForBagType:kBagItemTypeTMHM];
  [self initDataForBagType:kBagItemTypeBerry];
  [self initDataForBagType:kBagItemTypeMail];
  [self initDataForBagType:kBagItemTypeBattleItem];
  [self initDataForBagType:kBagItemTypeKeyItem];
}

#pragma mark - Private Methods

+ (void)initDataForBagType:(BagItemType)type
{
  NSArray * itemList;
  NSString * entityName;
  if (type & kBagItemTypeItem) {
//    itemList = [PListParser
    entityName = NSStringFromClass([BagItem class]);
  }
  else if (type & kBagItemTypeMedicine) {
    itemList   = [PListParser bagMedicine];
    entityName = NSStringFromClass([BagMedicine class]);
  }
  else if (type & kBagItemTypePokeball) {
    itemList   = [PListParser bagPokeballs];
    entityName = NSStringFromClass([BagPokeball class]);
  }
  else if (type & kBagItemTypeTMHM) {
    itemList   = [PListParser bagTMsHMs];
    entityName = NSStringFromClass([BagTMHM class]);
  }
  else if (type & kBagItemTypeBerry) {
    itemList   = [PListParser bagBerries];
    entityName = NSStringFromClass([BagBerry class]);
  }
  else if (type & kBagItemTypeMail) {
    itemList   = [PListParser bagMail];
    entityName = NSStringFromClass([BagMail class]);
  }
  else if (type & kBagItemTypeBattleItem) {
    itemList   = [PListParser bagBattleItems];
    entityName = NSStringFromClass([BagBattleItem class]);
  }
  else if (type & kBagItemTypeKeyItem) {
    itemList   = [PListParser bagKeyItems];
    entityName = NSStringFromClass([BagKeyItem class]);
  }
  else return;
  
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  for (NSDictionary * itemDict in itemList) {
    id entity = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                              inManagedObjectContext:managedObjectContext];
    [self setDataForEntity:entity withType:type dataDict:itemDict];
    itemDict = nil;
    entity   = nil;
  }
  itemList = nil;
  
  NSError * error;
  if (! [managedObjectContext save:&error])
    NSLog(@"!!! Couldn't save data to %@", entityName);
}

+ (void)setDataForEntity:(id)entity withType:(BagItemType)type dataDict:(NSDictionary *)dataDict
{
  if (type & kBagItemTypeItem) {
//    ((BagItem *)entity).icon = ;
//    ((BagItem *)entity).sid      = [dataDict objectForKey:@"sid"];
//    ((BagItem *)entity).type     = [dataDict objectForKey:@"type"];
//    ((BagItem *)entity).code     = [dataDict objectForKey:@"code"];
//    ((BagItem *)entity).price    = [dataDict objectForKey:@"price"];
//    ((BagItem *)entity).location = [dataDict objectForKey:@"location"];
  }
  else if (type & kBagItemTypeMedicine) {
    //((BagMedicine *)entity).icon = ;
    ((BagMedicine *)entity).sid      = [dataDict objectForKey:@"sid"];
    ((BagMedicine *)entity).type     = [dataDict objectForKey:@"type"];
    ((BagMedicine *)entity).code     = [dataDict objectForKey:@"code"];
    ((BagMedicine *)entity).price    = [dataDict objectForKey:@"price"];
    ((BagMedicine *)entity).location = [dataDict objectForKey:@"location"];
  }
  else if (type & kBagItemTypePokeball) {
    //((BagPokeball *)entity).icon = ;
    ((BagPokeball *)entity).sid      = [dataDict objectForKey:@"sid"];
    ((BagPokeball *)entity).type     = [dataDict objectForKey:@"type"];
    ((BagPokeball *)entity).code     = [dataDict objectForKey:@"code"];
    ((BagPokeball *)entity).price    = [dataDict objectForKey:@"price"];
    ((BagPokeball *)entity).location = [dataDict objectForKey:@"location"];
  }
  else if (type & kBagItemTypeTMHM) {
  }
  else if (type & kBagItemTypeBerry) {
    //((BagBerry *)entity).icon = ;
    ((BagBerry *)entity).sid      = [dataDict objectForKey:@"sid"];
    ((BagBerry *)entity).type     = [dataDict objectForKey:@"type"];
    ((BagBerry *)entity).code     = [dataDict objectForKey:@"code"];
    ((BagBerry *)entity).location = [dataDict objectForKey:@"location"];
  }
  else if (type & kBagItemTypeMail) {
  }
  else if (type & kBagItemTypeBattleItem) {
    //((BagBattleItem *)entity).icon = ;
    ((BagBattleItem *)entity).sid      = [dataDict objectForKey:@"sid"];
    ((BagBattleItem *)entity).type     = [dataDict objectForKey:@"type"];
    ((BagBattleItem *)entity).code     = [dataDict objectForKey:@"code"];
    ((BagBattleItem *)entity).price    = [dataDict objectForKey:@"price"];
    ((BagBattleItem *)entity).location = [dataDict objectForKey:@"location"];
  }
  else if (type & kBagItemTypeKeyItem) {
    //((BagBattleItem *)entity).icon = ;
    ((BagKeyItem *)entity).sid      = [dataDict objectForKey:@"sid"];
    ((BagKeyItem *)entity).type     = [dataDict objectForKey:@"type"];
    ((BagKeyItem *)entity).code     = [dataDict objectForKey:@"code"];
    ((BagKeyItem *)entity).location = [dataDict objectForKey:@"location"];
  }
  else return;
}

@end
