//
//  Move+DataController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/22/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "Move+DataController.h"

#import "AppDelegate.h"
#import "PListParser.h"

@implementation Move (DataController)

#pragma mark - Hard Initialize the DB data

+ (void)populateData
{
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  
  // Fetch data that store in |Moves.plist|
  NSArray * moves = [PListParser moves];
  
  int i = 0;
  for (NSDictionary * moveDict in moves) {
    Move * move = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                                inManagedObjectContext:managedObjectContext];
    
    move.sid                    = [NSNumber numberWithInt:++i];
    move.name                   = [moveDict objectForKey:@"name"];
    move.type                   = [moveDict objectForKey:@"type"];
    move.category               = [moveDict objectForKey:@"category"];
    move.contestType            = [moveDict objectForKey:@"contestType"];
    move.basePP                 = [moveDict objectForKey:@"basePP"];
    move.baseDamage             = [moveDict objectForKey:@"baseDamage"];
    move.priority               = [moveDict objectForKey:@"priority"];
    move.effectCode             = [moveDict objectForKey:@"effectCode"];
    move.hitChance              = [moveDict objectForKey:@"hitChance"];
    move.additionalEffectChance = [moveDict objectForKey:@"additionalEffectChance"];
    move.target                 = [moveDict objectForKey:@"target"];
    move.flags                  = [moveDict objectForKey:@"flags"];
    move.info                   = [moveDict objectForKey:@"info"];
    
    moveDict = nil;
    move = nil;
  }
  
  NSError * error;
  if (! [managedObjectContext save:&error])
    NSLog(@"!!! Couldn't save data to %@", NSStringFromClass([self class]));
  
  moves = nil;
}

#pragma mark - Data Query Mthods

+ (NSArray *)queryAllData
{
  return nil;
}

+ (Move *)queryMoveDataWithID:(NSInteger)moveID
{
  return nil;
}

@end
