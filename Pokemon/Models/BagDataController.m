//
//  BagDataController.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/17/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "BagDataController.h"

#import "AppDelegate.h"

@implementation BagDataController

static BagDataController * bagDataController = nil;

// Singleton
+ (BagDataController *)sharedInstance {
  if (bagDataController != nil)
    return bagDataController;
  
  static dispatch_once_t onceToken; // Lock
  dispatch_once(&onceToken, ^{      // This code is called at most once per app
    bagDataController = [[BagDataController alloc] init];
  });
  return bagDataController;
}

- (void)dealloc
{
  [super dealloc];
}

- (id)init
{
  if (self = [super init]) {
  }
  return self;
}

- (NSArray *)queryAllDataFor:(BagQueryTargetType)targetType
{
  NSString * entityName;
  if      (targetType & kBagQueryTargetTypeItem)       entityName = NSStringFromClass([BagItem class]);
  else if (targetType & kBagQueryTargetTypeMedicine)   entityName = NSStringFromClass([BagMedicine class]);
  else if (targetType & kBagQueryTargetTypePokeball)   entityName = NSStringFromClass([BagPokeball class]);
  else if (targetType & kBagQueryTargetTypeTMHM)       entityName = NSStringFromClass([BagTMHM class]);
  else if (targetType & kBagQueryTargetTypeBerry)      entityName = NSStringFromClass([BagBerry class]);
  else if (targetType & kBagQueryTargetTypeMail)       entityName = NSStringFromClass([BagMail class]);
  else if (targetType & kBagQueryTargetTypeBattleItem) entityName = NSStringFromClass([BagBattleItem class]);
  else if (targetType & kBagQueryTargetTypeKeyItem)    entityName = NSStringFromClass([BagKeyItem class]);
  else return nil;
  
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:entityName
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSError * error;
  NSArray * fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest
                                                                 error:&error];
  [fetchRequest release];
  return fetchedObjects;
}

@end
