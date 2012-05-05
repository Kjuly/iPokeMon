//
//  Region+DataController.m
//  iPokemon
//
//  Created by Kaijie Yu on 5/5/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "Region+DataController.h"

#import "AppDelegate.h"

@interface Region (Private)

//- (NSString *)_formatToString;
+ (void)_addNewRegionWithPlacemark:(CLPlacemark *)placemark
              managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end

@implementation Region (DataController)

// get code for current region with |placemark|
//  
// |codes| value format: [<0>:<1>:<2>:<3>:<4>]
//   <0>=<country>:                      China (CN)
//   <1>=<administrativeArea(province)>: Zhejiang Province (ZJ)
//   <2>=<locality(city)>:               Hangzhou City (HZ)
//   <3>=<sublocality(district)>:        (Space Holder) Yuhang District (YH)
//   <4>=<special>:                      water, cave
//
// |codes| value e.g.: "CN:ZJ:HZ:XX:XX"
//
+ (NSString *)codeOfRegionWithPlacemark:(CLPlacemark *)placemark {
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSPredicate * predicate;
  // As the user only fetched data for current region (|administrativeArea| currently),
  //  so, just need to fetch sub tier:|locality|
  //  (need to involve |subLocality| in next vertion)
  predicate = [NSPredicate predicateWithFormat:@"locality == %@", placemark.locality];
  [fetchRequest setPredicate:predicate];
  [fetchRequest setFetchLimit:1];
  
  NSError * error;
  Region * region = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
  [fetchRequest release];
  
  // if no object fetched, add this new region data to CoreData
  if (region == nil) {
//    [self _addNewRegionWithPlacemark:placemark
//                managedObjectContext:managedObjectContext];
    return nil;
  }
  return region.code;
}

#pragma mark - Private

+ (void)_addNewRegionWithPlacemark:(CLPlacemark *)placemark
              managedObjectContext:(NSManagedObjectContext *)managedObjectContext{
  Region * region;
  region = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                         inManagedObjectContext:managedObjectContext];
  
  // Set data
  region.code = @"";
//  region.
  
  NSError * error;
  if (! [managedObjectContext save:&error])
    NSLog(@"!!! Couldn't save data to |%@| :: %@", [self class], error);
  region = nil;
}

@end
