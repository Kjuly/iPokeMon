//
//  Move+DataController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/22/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "Move+DataController.h"

#import "AppDelegate.h"
#import "PListParser.h"

@implementation Move (DataController)

#pragma mark - Data Query Mthods

+ (NSArray *)queryFourMovesDataWithIDs:(NSArray *)moveIDs
{
  NSMutableArray * moveIDsInNumber = [NSMutableArray arrayWithCapacity:4];
  for (id moveID in moveIDs) {
    NSNumber * moveIDInNumber;
    if ([moveID isKindOfClass:[NSString class]])
      moveIDInNumber = [NSNumber numberWithInt:[moveID intValue]];
    else
      moveIDInNumber = moveID;
    [moveIDsInNumber addObject:moveIDInNumber];
    moveIDInNumber = nil;
  }
  
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sid IN %@", moveIDsInNumber];
  moveIDsInNumber = nil;
  [fetchRequest setPredicate:predicate];
  [fetchRequest setFetchLimit:4];
  
  NSError * error;
  NSArray * fourMoves = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  
  return fourMoves;
}

+ (Move *)queryMoveDataWithID:(NSInteger)moveID
{
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sid == %d", moveID];
  [fetchRequest setPredicate:predicate];
  [fetchRequest setFetchLimit:1];
  
  NSError * error;
  Move * move = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
  
  return move;
}

@end
