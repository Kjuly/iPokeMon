//
//  BagDataController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 3/17/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "BagDataController.h"

#import "AppDelegate.h"


@interface BagDataController (Private)

- (NSString *)_entityNameFor:(BagQueryTargetType)targetType;

@end


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


- (id)init {
  if (self = [super init]) {
  }
  return self;
}

#pragma mark - Public Methods

// Query all data for one type
- (NSArray *)queryAllDataFor:(BagQueryTargetType)targetType {
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:[self _entityNameFor:targetType]
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSError * error;
  NSArray * fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest
                                                                 error:&error];
  return fetchedObjects;
}

// Query data for one type, multiple item IDs
- (NSArray *)queryDataFor:(BagQueryTargetType)targetType
          withIDsInString:(NSString *)targetIDsInString {
  NSArray * targetIDs = [targetIDsInString componentsSeparatedByString:@","];
  NSInteger count = [targetIDs count];
  if (count == 0) {
    targetIDs = nil;
    return nil;
  }
  
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:[self _entityNameFor:targetType]
                                      inManagedObjectContext:managedObjectContext]];
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"sid IN %@", targetIDs]];
  [fetchRequest setFetchLimit:count];
  
  // set sort descriptor when fetching multiple objects
  if (count > 1) {
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"price" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
  }
  
  NSError * error;
  NSArray * items = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  
  return items;
}

// Query data for one type, one item ID
- (id)queryDataFor:(BagQueryTargetType)targetType
            withID:(NSInteger)targetID {
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:[self _entityNameFor:targetType]
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sid == %d", targetID];
  [fetchRequest setPredicate:predicate];
  [fetchRequest setFetchLimit:1];
  
  NSError * error;
  id queryResult = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
  
  return queryResult;
}

#pragma mark - Private Methods

- (NSString *)_entityNameFor:(BagQueryTargetType)targetType {
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
  return entityName;
}

@end
