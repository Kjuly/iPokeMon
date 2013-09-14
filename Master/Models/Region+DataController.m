//
//  Region+DataController.m
//  iPokeMon
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
- (void)_doPushWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end

@implementation Region (DataController)

// Sync data between SERVER & CLIENT
// pull data for current region from SERVER;
// push data for new region data to SERVER.
+ (void)sync {
  NSLog(@"SYNC REGION...");
  [self _pullFromServer];
  // this task will be done after task of |_pullFromServer| done
  //[self _pushToServer];
}

// get code for current region with |placemark|
//  
// |codes| value format: "<0>:<1>:<2>:<3>:<4>"
//   <0>=<country>:                      China (CN)
//   <1>=<administrativeArea(province)>: Zhejiang Province (ZJ)
//   <2>=<locality(city)>:               Hangzhou City (HZ)
//   <3>=<sublocality(district)>:        (Space Holder) Yuhang District (YH)
//   <4>=<special>:                      water, cave
//
// |codes| value e.g.: "CN:ZJ:HZ:XX:XX"
//
// !!! the last two is wait to be added,
//     so the current format e.g.:
//     
//     "CN:ZJ:HZ"
//
+ (NSString *)codeOfRegionWithPlacemark:(CLPlacemark *)placemark {
  // Sometimes, the Google Maps API will be blocked by ghost (you know, uh?),
  //   then no place mark can be got.
  //   In this case, just return the top level default code: "DEFAULT",
  //   it'll return default PokeMons for global places.
  if (! placemark) return @"DEFAULT";
  
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
  region.administrativeArea = placemark.administrativeArea;
  region.locality           = placemark.locality;
//  region.subLocality        = placemark.subLocality;
  
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
    // {'r':"CN:ZJ:HZ=Zhejiang Province=Hangzhou City"} // r:region
    if ([[JSON valueForKey:@"r"] isKindOfClass:[NSNull class]]) {
      NSLog(@"...SYNC Region Info from SERVER DONE...NO Region Data");
      // Hide loading
      [[LoadingManager sharedInstance] hideOverBar];
      // push new region data (|flag == 'n'|) to SERVER
      [self _pushToServer];
      return;
    }
    
    // Parse data from JSON
    // e.g. "CN:ZJ:HZ=Zhejiang Province=Hangzhou City"
    NSString * regionSeq = [JSON valueForKey:@"r"];
    NSLog(@"Pulled Region Seq : SERVER => CLIENT::%@", regionSeq);
    NSArray * regionArray = [regionSeq componentsSeparatedByString:@"="];
    
    // start to update regions
    NSManagedObjectContext * managedObjectContext =
      [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError * error;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class])
                                        inManagedObjectContext:managedObjectContext]];
    [fetchRequest setFetchLimit:1];
    
    // Update the data for model:|Region|
    Region * region;
    // Check the existence of the object
    // If exist, execute fetching request, otherwise, insert new object
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"locality == %@", [regionArray objectAtIndex:2]]];
    if ([managedObjectContext countForFetchRequest:fetchRequest error:&error])
      region = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
    else region = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                                inManagedObjectContext:managedObjectContext];
    // set data for region
    region.code               = [regionArray objectAtIndex:0]; // code
    region.countryCode        = [[regionArray objectAtIndex:0] substringToIndex:2]; // code country
    region.administrativeArea = [regionArray objectAtIndex:1]; // code administrative area
    region.locality           = [regionArray objectAtIndex:2]; // code locality
    //region.subLocality        = [regionDict valueForKey:@"csl"]; // code sublocality
    region.flag               = @"v"; // flag | verified
    
    
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
                                      withObject:nil
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
  if ([managedObjectContext countForFetchRequest:fetchRequest error:&error] == 0) {
    return;
  }
  NSArray * regions = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  
  // Push new |regions| data to SERVER
  //   and set their |flag| to 'p'(already pushed to server, but not verified)
  //   so next time do not need to push it again
  // When the SERVER side's admin update it,
  //   it'll get |flag| with 'v' (already verified)
  for (Region * region in regions) {
    // if the region info data not complete, pass this region
    if (!region.countryCode || !region.administrativeArea || !region.locality)
      continue;
    [region _doPushWithManagedObjectContext:managedObjectContext];
  }
}

// push new region info data to SERVER
- (void)_doPushWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
  NSLog(@"......PUSHING new REGION INFO to SERVER......");
  // Blocks: |success| & |failure|
  void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
    
    // set region's |flag| to 'p'(already pushed to server, but not verified)
    //   and save the region data that modified (|flag|)
    self.flag = @"p";
    NSError * error;
    if (! [managedObjectContext save:&error])
      NSLog(@"Couldn't save data to %@", NSStringFromClass([self class]));
    // Hide loading
    NSLog(@"FLAG:%@",self.flag);
    [[LoadingManager sharedInstance] hideOverBar];
    NSLog(@"...DONE...Pushed new Region Info to SERVER successfully...");
  };
  void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"!!! Push new Region Info to SERVER failed ERROR: %@", [error localizedDescription]);
    // Hide loading
    [[LoadingManager sharedInstance] hideOverBar];
  };
  
  // Show loading
  [[LoadingManager sharedInstance] showOverBar];
  
  // region info
  // e.g. "CN=Zhejiang Province=Hangzhou City"
  NSString * regionInfo = [NSString stringWithFormat:@"%@=%@=%@",
                             self.countryCode, self.administrativeArea, self.locality];
  NSDictionary * data = [[NSDictionary alloc] initWithObjectsAndKeys:regionInfo, @"ri", nil];
  NSLog(@"NEW REGION INFO:%@", regionInfo);
  [[ServerAPIClient sharedInstance] updateData:data
                                     forTarget:kDataFetchTargetRegion
                                       success:success
                                       failure:failure];
}

@end
