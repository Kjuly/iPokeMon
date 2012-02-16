//
//  Trainer+DataController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/16/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "Trainer+DataController.h"

#import "AppDelegate.h"

#import "AFJSONRequestOperation.h"

@implementation Trainer (DataController)

// Update
+ (void)updateData
{
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  Trainer * trainer = [NSEntityDescription insertNewObjectForEntityForName:@"Trainer"
                                                    inManagedObjectContext:managedObjectContext];
  
  // Fetch Data from server
  NSURL * url = [[NSURL alloc] initWithString:@"http://localhost:8080/user/1"];
  NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
  [url release];
  
  AFJSONRequestOperation * operation =
  [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                  success:^(NSURLRequest * request, NSHTTPURLResponse * response, id JSON) {
                                                    NSLog(@"%@", JSON);
                                                    //                                                    [TrainerModel setTrainerWith:[[JSON valueForKey:@"id"] intValue]
                                                    //                                                                            Name:[JSON valueForKey:@"name"]];
                                                    trainer.trainerID = [JSON valueForKey:@"id"];
                                                    trainer.name      = [JSON valueForKey:@"name"];
                                                    trainer.money     = [JSON valueForKey:@"money"];
                                                    trainer.badges    = [JSON valueForKey:@"badges"];
                                                    trainer.adventureStarted = nil;
                                                    
                                                    NSError * error;
                                                    if (! [managedObjectContext save:&error])
                                                      NSLog(@"Couldn't save data to %@", NSStringFromClass([self class]));
                                                  }
                                                  failure:nil];
  [request release];
  [operation start];
}

// Get data from model
+ (NSArray *)queryAllData
{
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:@"Trainer"
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSError * error;
  NSArray * fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest
                                                                 error:&error];
  [fetchRequest release];
  
  return fetchedObjects;
}

// Set data to model
+ (void)setTrainerWith:(NSInteger)trainerID Name:(NSString *)name
{
  NSManagedObjectContext * managedObjectContext =
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  Trainer * trainer = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                                         inManagedObjectContext:managedObjectContext];
  trainer.trainerID = [NSNumber numberWithInt:trainerID];
  trainer.name      = name;
  
  NSError * error;
  if (! [managedObjectContext save:&error])
    NSLog(@"Couldn't save data to %@", NSStringFromClass([self class]));
}

@end
