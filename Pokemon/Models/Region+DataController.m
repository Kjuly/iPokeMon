//
//  Region+DataController.m
//  iPokemon
//
//  Created by Kaijie Yu on 5/5/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "Region+DataController.h"

#import "AppDelegate.h"
#import "LoadingManager.h"
#import "ServerAPIClient.h"

@interface Region (Private)

//- (NSString *)_formatToString;
+ (void)_addNewRegionWithPlacemark:(CLPlacemark *)placemark
              managedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (void)_pullFromServer;
+ (void)_pushToServer;
- (void)_doPush;

@end

@implementation Region (DataController)

// Sync data between SERVER & CLIENT
// pull data for current region from SERVER;
// push data for new region data to SERVER.
+ (void)sync {
  [self _pullFromServer];
  // this task will be done after task of |_pullFromServer| done
  //[self _pushToServer];
}

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
  
  // if no object fetched, add this new region info to CoreData
  if (region == nil) {
    NSLog(@"!!! region == nil");
    [self _addNewRegionWithPlacemark:placemark
                managedObjectContext:managedObjectContext];
    return placemark.ISOcountryCode;
  }
  // no matter |flog| is 'v' or 'n', that's okay
  // case 'v', it'll return correct |code|;
  // case 'n', it'll return |placemark.ISOcountryCode|.
  if (region.code == nil) {
    NSLog(@"!!! region.code == nil");
    return placemark.ISOcountryCode;
  }
  return region.code;
}

#pragma mark - Private

// add new region data to CoreData
//
// |flag|:
//   v:verified - already verified
//   n:new      - unknow |code|, will be removed from CoreData, after pushed to server
//   p:pushed   - already pushed to server, but not verified
//
+ (void)_addNewRegionWithPlacemark:(CLPlacemark *)placemark
              managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
  Region * region;
  region = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                         inManagedObjectContext:managedObjectContext];
  // Set data
  region.flag               = @"n"; // flag to new, wait to be pushed to server
  region.code               = nil;
  region.countryCode        = placemark.ISOcountryCode;
  region.administrativeArea = @"Zhejiang Province";//placemark.administrativeArea;
  region.locality           = @"Hangzhou City";//placemark.locality;
//  region.subLocality        = placemark.subLocality;
  NSLog(@"%@", region.countryCode);
  
  NSError * error;
  if (! [managedObjectContext save:&error])
    NSLog(@"!!! Couldn't save data to |%@| :: %@", [self class], error);
  NSLog(@"ADD new Region DONE...");
  region = nil;
}

// pull data for current region from SERVER;
+ (void)_pullFromServer {
  NSLog(@"=== START");
  // Success Block Method
  void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id JSON) {
    // Get JSON Data Array from HTTP Response
    // {'r':[...]} // r:region
    if ([[JSON valueForKey:@"r"] isKindOfClass:[NSNull class]]) {
      NSLog(@"...SYNC Region Info from SERVER DONE...NO Region Data");
      // Hide loading
      [[LoadingManager sharedInstance] hideOverBar];
      // push new region data (|flag == 'n'|) to SERVER
      [self _pushToServer];
      return;
    }
    
    // Parse data from JSON
    NSDictionary * regionDict = [JSON valueForKey:@"r"];
    NSLog(@"Pulled Region Info : SERVER => CLIENT::%@", regionDict);
    
    // start to update regions
    NSManagedObjectContext * managedObjectContext =
      [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError * error;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class])
                                        inManagedObjectContext:managedObjectContext]];
    [fetchRequest setFetchLimit:1];
    // Update the data for model:|Region|
//    for (NSDictionary * regionDict in regions) {
      Region * region;
      NSString * locality = [regionDict valueForKey:@"cl"]; // code locality
      // Check the existence of the object
      // If exist, execute fetching request, otherwise, insert new object
      [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"locality == %@", locality]];
      if ([managedObjectContext countForFetchRequest:fetchRequest error:&error])
        region = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
      else region = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                                  inManagedObjectContext:managedObjectContext];
      region.code               = @"CN:ZJ:HZ";//[regionDict valueForKey:@"c"];   // code
      region.countryCode        = @"CN";//[regionDict valueForKey:@"cc"];  // code country
      region.administrativeArea = @"Zhejiang Province";//[regionDict valueForKey:@"ca"];  // code administrative area
      region.locality           = @"Hangzhou City";//locality;                        // code locality
//      region.subLocality        = [regionDict valueForKey:@"csl"]; // code sublocality
      region.flag               = [regionDict valueForKey:@"f"];   // flag
//    }
    [fetchRequest release];
    
    if (! [managedObjectContext save:&error])
      NSLog(@"!!! Couldn't save data to %@", NSStringFromClass([self class]));
    NSLog(@"...Update |%@| data done...", [self class]);
    
    // Hide loading
    [[LoadingManager sharedInstance] hideOverBar];
    // push new region data (|flag == 'n'|) to SERVER
    [self _pushToServer];
  };
  
  // Failure Block Method
  void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError * error) {
    NSLog(@"!!! ERROR: %@", error);
    // Hide loading
    [[LoadingManager sharedInstance] hideOverBar];
    // push new region data (|flag == 'n'|) to SERVER
    [self _pushToServer];
  };
  
  // Show loading
  [[LoadingManager sharedInstance] showOverBar];
  // Fetch data from server & populate the |teamedPokemon|
  [[ServerAPIClient sharedInstance] fetchDataFor:kDataFetchTargetRegion
                                         success:success
                                         failure:failure];
}

// push data for new region data to SERVER.
+ (void)_pushToServer {
  NSLog(@"=== START");
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSError * error;
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class])
                                      inManagedObjectContext:managedObjectContext]];
  [fetchRequest setFetchLimit:1];
  
  // Check the existence of the object
  // If not exist, return, otherwise, execute fetching request.
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"flag == %@", @"n"]];
  if ([managedObjectContext countForFetchRequest:fetchRequest error:&error] == 0)
    return;
  NSArray * regions = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  [fetchRequest release];
  
  // Push new |regions| data to SERVER
  //   and set their |flag| to 'p'(already pushed to server, but not verified)
  //   so next time do not need to push it again
  // When the SERVER side's admin update it,
  //   it'll get |flag| with 'v' (already verified)
  for (Region * region in regions)
    [region _doPush];
  
  // save data that modified (|flag|)
  if (! [managedObjectContext save:&error])
    NSLog(@"Couldn't save data to %@", NSStringFromClass([self class]));
  NSLog(@"...DONE...");
}

// push new region info data to SERVER
- (void)_doPush {
  NSLog(@"......PUSHING new REGION INFO to SERVER......");
  NSString * locationInfo = [NSString stringWithFormat:@"%@=%@=%@", @"CN", @"Zhejiang Province", @"Hangzhou City"];
  NSDictionary * data = [[NSDictionary alloc] initWithObjectsAndKeys:
                         locationInfo, @"li", // location info
//                         @"Shaoxing City", @"cl",
//                         self.code,               @"c",
//                         self.countryCode,        @"cc",
//                         self.administrativeArea, @"ca",
//                         self.locality,           @"cl",
                         
//                         self.subLocality,        @"csl", # add it in next version
                         nil];
  NSLog(@"NEW REGION INFO:%@", data);
  
  // Blocks: |success| & |failure|
  void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"...Push new Region Info to SERVER successfully...");
    // set region's |flag| to 'p'(already pushed to server, but not verified)
    NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    self.flag = @"p";
    NSError * error;
    if (! [managedObjectContext save:&error])
      NSLog(@"Couldn't save data to %@", NSStringFromClass([self class]));
    // Hide loading
    [[LoadingManager sharedInstance] hideOverBar];
  };
  void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"!!! Push new Region Info to SERVER failed ERROR: %@", [error localizedDescription]);
    // Hide loading
    [[LoadingManager sharedInstance] hideOverBar];
  };
  
  // Show loading
  [[LoadingManager sharedInstance] showOverBar];
  [[ServerAPIClient sharedInstance] updateData:data
                                     forTarget:kDataFetchTargetRegion
                                       success:success
                                       failure:failure];
  [data release];
}

@end
