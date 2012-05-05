//
//  WildPokemonController.m
//  Pokemon
//
//  Created by Kaijie Yu on 4/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "WildPokemonController.h"

#import "PokemonConstants.h"
#import "AppDelegate.h"
#import "PMLocationManager.h"
#import "LoadingManager.h"
#import "WildPokemon+DataController.h"
#import "Pokemon+DataController.h"
#import "Move+DataController.h"
#import "ServerAPIClient.h"

#import "AFJSONRequestOperation.h"

#define kPokemonDefaultCount 0 // This number of PMs are defaults for every users

@interface WildPokemonController () {
 @private
  LoadingManager      * loadingManager_;
  NSMutableDictionary * locationInfo_;
  NSMutableDictionary * regionInfo_;
  
  BOOL                  isPokemonAppeared_;
  NSInteger             UID_;
  NSInteger             pokemonCounter_;
}

@property (nonatomic, retain) LoadingManager      * loadingManager;
@property (nonatomic, copy)   NSMutableDictionary * locationInfo;
@property (nonatomic, copy)   NSMutableDictionary * regionInfo;

- (void)_cleanDataWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)_updateWildPokemon:(WildPokemon *)wildPokemon withData:(NSString *)data;
- (NSInteger)_calculateLevel;

- (void)_updateForCurrentRegion;
- (void)_generateWildPokemonForCurrentLocation:(NSNotification *)notification;
- (void)_generateWildPokemonWithLocationInfo:(NSDictionary *)locationInfo;
- (PokemonHabitat)_parseHabitatWithLocationType:(NSString *)locationType;
//- (NSArray *)filterSIDs:(NSArray *)SIDs;

@end


@implementation WildPokemonController

@synthesize loadingManager = loadingManager_;
@synthesize locationInfo   = locationInfo_;
@synthesize regionInfo     = regionInfo_;

// Singleton
static WildPokemonController * wildPokemonController_ = nil;
+ (WildPokemonController *)sharedInstance {
  if (wildPokemonController_ != nil)
    return wildPokemonController_;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    wildPokemonController_ = [[WildPokemonController alloc] init];
  });
  return wildPokemonController_;
}

- (void)dealloc {
  self.locationInfo = nil;
  self.regionInfo   = nil;
  // remove notification observers
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNGenerateNewWildPokemon object:nil];
  [super dealloc];
}

- (id)init {
  if (self = [super init]) {
    self.loadingManager = [LoadingManager sharedInstance];
    isPokemonAppeared_  = NO;
    UID_                = 0;
    pokemonCounter_     = kPokemonDefaultCount;
  }
  return self;
}

#pragma mark - Public Methods

// listen for notification, etc.
- (void)listen {
  // add observer for notfication from |PMLocationManager| when it's time to generate a new Wild PM
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(_generateWildPokemonForCurrentLocation:)
                                               name:kPMNGenerateNewWildPokemon
                                             object:nil];
}

// Add more Wild Pokemons with SID array
- (void)addWildPokemonsWithSIDs:(NSArray *)pokemonSIDs {
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  
  // Add the data to |WildPokePokemon| with SID array
  for (id data in pokemonSIDs) {
    // Transfer NSNumber to NSString if it is NSNumber type
    if ([data isKindOfClass:[NSNumber class]])
      data = [data stringValue];
    
    WildPokemon * wildPokemon;
    wildPokemon = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([WildPokemon class])
                                                inManagedObjectContext:managedObjectContext];
    // Update data for current |wildPokemon|
    [self _updateWildPokemon:wildPokemon withData:data];
  }
  
  NSError * error;
  if (! [managedObjectContext save:&error])
    NSLog(@"!!! Couldn't save data to %@", NSStringFromClass([WildPokemon class]));
  NSLog(@"...|addWildPokemonsWithSIDs:| - Add |%@| data done...", [WildPokemon class]);
}

// Add more Wild Pokemons with SID array
//   return added Pokemons as an array
- (NSArray *)pokemonsAddedWithSIDs:(NSArray *)pokemonSIDs {
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  
  // Add the data to |WildPokePokemon| with SID array
  NSMutableArray * pokemons = [NSMutableArray arrayWithCapacity:[pokemonSIDs count]];
  for (id data in pokemonSIDs) {
    // Transfer NSNumber to NSString if it is NSNumber type
    if ([data isKindOfClass:[NSNumber class]])
      data = [data stringValue];
    
    WildPokemon * wildPokemon;
    wildPokemon = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([WildPokemon class])
                                                inManagedObjectContext:managedObjectContext];
    // Update data for current |wildPokemon|
    [self _updateWildPokemon:wildPokemon withData:data];
    
    // Add Pokemon to array
    [pokemons addObject:wildPokemon];
  }
  
  NSError * error;
  if (! [managedObjectContext save:&error])
    NSLog(@"!!! Couldn't save data to %@", NSStringFromClass([WildPokemon class]));
  NSLog(@"...|addWildPokemonsWithSIDs:| - Add |%@| data done...", [WildPokemon class]);
  
  return pokemons;
}

// Return a Wild Pokemon for user's current location to generate a game battle scene
- (WildPokemon *)appearedPokemon {
  return [WildPokemon queryPokemonDataWithUID:UID_];
}

/*/ LEGACY: Use Google Maps API
// Update data for Wild Pokemon at current location
- (void)updateAtLocation:(CLLocation *)location {
  // Show loading process view
  [self.loadingManager showOverBar];
  
  isPokemonAppeared_ = YES;
  isReady_           = NO;
  
  NSLog(@"......UPDATING AT LOCATION......");
  ///Fetch Data from server
  // Success Block
  void (^success)(NSURLRequest *, NSHTTPURLResponse *, id);
  success = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    // Set data
    NSLog(@"status: %@", [JSON valueForKey:@"status"]);
    // Check STATUS CODE
    //
    //               OK: indicates that no errors occurred;
    //                   the place was successfully detected and at least one result was returned.
    //    UNKNOWN_ERROR: indicates a server-side error; trying again may be successful.
    //     ZERO_RESULTS: indicates that the reference was valid but no longer refers to a valid result.
    //                   This may occur if the establishment is no longer in business.
    // OVER_QUERY_LIMIT: indicates that you are over your quota.
    //   REQUEST_DENIED: indicates that your request was denied, generally because of lack of a sensor parameter.
    //  INVALID_REQUEST: generally indicates that the query (reference) is missing.
    //
    if (! [[JSON valueForKey:@"status"] isEqualToString:@"OK"]) {
      NSLog(@"!!! ERROR: Response STATUS is NOT OK");
      // Hide loading process view
      [self.loadingManager hideOverBar];
      return;
    }
    
    // The GeocoderResults object literal represents a single Geocoding result
    //   and is an object of the following form:
    //
    // results[]: {
    //   types[]: string,
    //   formatted_address: string,
    //   address_components[]: {
    //     short_name: string,
    //     long_name: string,
    //     types[]: string
    //   },
    //   geometry: {
    //     location: LatLng,
    //     location_type: GeocoderLocationType
    //     viewport: LatLngBounds,
    //     bounds: LatLngBounds
    //   }
    // }
    //
    NSLog(@"Setting data for |locationInfo|....");
    NSDictionary * results  = [[JSON valueForKey:@"results"] objectAtIndex:0];
    
    NSDictionary * locationInfo;
    locationInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                    [[results valueForKey:@"types"] objectAtIndex:0], @"type", nil];
    
    // Generate Wild Pokemon with the data of |locationInfo|
    [self _generateWildPokemonWithLocationInfo:locationInfo];
    [locationInfo release];
    results = nil;
    
    // Hide loading process view
    [self.loadingManager hideOverBar];
  };
  
  // Failure Block
  void (^failure)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id);
  failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    NSLog(@"!!! ERROR: %@", error);
    // Hide loading process view
    [self.loadingManager hideOverBar];
  };
  
  // Fetch Data from server
  NSString * requestURL =
  [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",
   location.coordinate.latitude, location.coordinate.longitude];
  NSURL * url = [[NSURL alloc] initWithString:requestURL];
  NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
  [url release];
  //  NSString * body = @"sensor=true";
  [request setHTTPMethod:@"POST"];
  //  [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
  //
  // !!!TODO
  //   When network is not available, timeout not works!!!
  //
  [request setTimeoutInterval:10.f];
  NSLog(@"%@", request.URL);
  AFJSONRequestOperation * operation =
  [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                  success:success
                                                  failure:failure];
  [request release];
  [operation start];
}*/

#pragma mark - Private Methods
#pragma mark - For updating

// Clean Wild Pokemon's data
- (void)_cleanDataWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass([WildPokemon class])
                                             inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  NSError * error;
  NSArray * wildPokemons = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  [fetchRequest release];
  
  for (WildPokemon *wildPokemon in wildPokemons) {
    // Keey default PMs
    if ([wildPokemon.uid intValue] <= kPokemonDefaultCount)
      return;
    [managedObjectContext deleteObject:wildPokemon];
  }
  
  if (! [managedObjectContext save:&error])
    NSLog(@"!!! Couldn't save data to %@", NSStringFromClass([WildPokemon class]));
  NSLog(@"...Clean |%@| data done...", [WildPokemon class]);
}

// Update data for WildPokemon entity
- (void)_updateWildPokemon:(WildPokemon *)wildPokemon withData:(NSString *)data {
  // Update basic data fetched from server
  NSInteger SID = [data intValue];
  wildPokemon.uid    = [NSNumber numberWithInt:++pokemonCounter_];
  wildPokemon.sid    = [NSNumber numberWithInt:SID];
  wildPokemon.status = [NSNumber numberWithInt:kPokemonStatusNormal];
  
  // Relationship betweent Pokemon & WildPokemon
  wildPokemon.pokemon = [Pokemon queryPokemonDataWithID:SID];
  
  // Calculate |level| based on Trainer's related data
  //   then, update data for current level.
  // datas included:|gender|, |fourMoves|, |maxStats|, |hp|, |exp|, |toNextLevel|
  [wildPokemon updateToLevel:[self _calculateLevel]];
}

// Calculate |level| based on Trainer's "level"
//
// !!!TODO
//   Need a formular
//
- (NSInteger)_calculateLevel {
  return 10;
}

#pragma mark - For Generating

- (void)_updateForCurrentRegion {
  // Show loading process view
  [self.loadingManager showOverBar];
  
  // Success Block Method
  void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id JSON) {
    NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    // Clean data for model:|WildPokemon| & reset pokemonCounter to 0
    [self _cleanDataWithManagedObjectContext:managedObjectContext];
    pokemonCounter_ = kPokemonDefaultCount;
    
    // Get JSON Data Array from HTTP Response
    NSArray * datas = [[JSON valueForKey:@"wpm"] componentsSeparatedByString:@","];
    NSLog(@"WildPM SIDs:%@", datas);
    // Update the data for |WildPokePokemon|
    for (NSString * data in datas) {
      if ([data isEqualToString:@""])
        continue;
      WildPokemon * wildPokemon;
      wildPokemon = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([WildPokemon class])
                                                  inManagedObjectContext:managedObjectContext];
      // Update data for current |wildPokemon|
      [self _updateWildPokemon:wildPokemon withData:data];
    }
    
    NSError * error;
    if (! [managedObjectContext save:&error])
      NSLog(@"!!! Couldn't save data to %@", NSStringFromClass([WildPokemon class]));
    NSLog(@"...Update |%@| data done...", [WildPokemon class]);
    
    // If a Wild Pokemon Appeared already, fetch data for it
    if (isPokemonAppeared_)
      [self _generateWildPokemonWithLocationInfo:[[PMLocationManager sharedInstance] currLocationInfo]];
    
    // Hide loading process view
    [self.loadingManager hideOverBar];
  };
  
  // Failure Block Method
  void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"!!! ERROR: %@", error);
    // Hide loading process view
    [self.loadingManager hideOverBar];
  };
  
  // Update data via |ServerAPIClient|
  [[ServerAPIClient sharedInstance] updateWildPokemonsForCurrentRegion:self.regionInfo
                                                               success:success
                                                               failure:failure];
}

// Generate Wild Pokemon with current location info
- (void)_generateWildPokemonForCurrentLocation:(NSNotification *)notification {
  NSDictionary * locationInfo = notification.object;
  [self _generateWildPokemonWithLocationInfo:locationInfo];
  locationInfo = nil;
}

// Generate Wild Pokemon with location info
- (void)_generateWildPokemonWithLocationInfo:(NSDictionary *)locationInfo {
  NSLog("locationInfo::%@", locationInfo);
  
  // Parse the habitat type from current location type
  PokemonHabitat habitat = [self _parseHabitatWithLocationType:[locationInfo valueForKey:@"type"]];
  
  // Set data for |regionInfo_|
  // !!!TODO
  //   More data needed!
  // t:Type
  CLPlacemark * placemark = [locationInfo objectForKey:@"placemark"];
  self.regionInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      [NSNumber numberWithInt:habitat], @"t",
                      placemark.ISOcountryCode, @"code_co", // code: country
                      @"", @"code_aa", // code: administrative area
                      @"", @"code_ci", // code: city (locality)
                      nil];
  placemark = nil;
  
  // Got SIDs for Pokemons in this |habitat| & generate one as the Appeared Pokemon
  NSArray * pokemonSIDs = [Pokemon SIDsForHabitat:habitat];
  // Generate a random SID for fetching the related Wild Pokemon
  NSInteger randomIndex = arc4random() % [pokemonSIDs count];
  WildPokemon * wildPokemon =
    [WildPokemon queryPokemonDataWithSID:[[pokemonSIDs objectAtIndex:randomIndex] intValue]];
  NSLog(@"Habitat:%d - PokemonSIDs:<< %@ >> - WildPokemon:%@",
        habitat, [pokemonSIDs componentsJoinedByString:@","], wildPokemon);
  
  // If no Wild Pokemon data matched, update all data for current region
  if (wildPokemon == nil) {
    // Save location info data
    self.locationInfo = [NSMutableDictionary dictionaryWithDictionary:locationInfo];
    [self _updateForCurrentRegion];
    return;
  }
  
  // Set data
  UID_               = [wildPokemon.uid intValue];
//  isReady_           = YES;
  isPokemonAppeared_ = NO;
}

// Parse habitat with the location type
/*
 kPokemonHabitatCave         = 1,
 kPokemonHabitatForest       = 2,
 kPokemonHabitatGrassland    = 3,
 kPokemonHabitatMountain     = 4,
 kPokemonHabitatRare         = 5, // Mean "Unknow"
 kPokemonHabitatRoughTerrain = 6,
 kPokemonHabitatSea          = 7,
 kPokemonHabitatUrban        = 8,
 kPokemonHabitatWatersEdge   = 9
 */
/*
              street_address: indicates a precise street address.
                       route: indicates a named route (such as "US 101").
                intersection: indicates a major intersection, usually of two major roads.
                   political: indicates a political entity. Usually, this type indicates a polygon
                              of some civil administration.
                     country: indicates the national political entity, and is typically the highest
                              order type returned by the Geocoder.
 administrative_area_level_1: indicates a first-order civil entity below the country level.
                              Within the United States, these administrative levels are states.
                              Not all nations exhibit these administrative levels.
 administrative_area_level_2: indicates a second-order civil entity below the country level.
                              Within the United States, these administrative levels are counties.
                              Not all nations exhibit these administrative levels.
 administrative_area_level_3: indicates a third-order civil entity below the country level.
                              This type indicates a minor civil division.
                              Not all nations exhibit these administrative levels.
             colloquial_area: indicates a commonly-used alternative name for the entity.
                    locality: indicates an incorporated city or town political entity.
                 sublocality: indicates an first-order civil entity below a locality.
                neighborhood: indicates a named neighborhood.
                     premise: indicates a named location, usually a building or collection of buildings
                              with a common name
                  subpremise: indicates a first-order entity below a named location, usually a singular
                              building within a collection of buildings with a common name.
                 postal_code: indicates a postal code as used to address postal mail within the country.
             natural_feature: indicates a prominent natural feature.
                     airport: indicates an airport.
                        park: indicates a named park.
 */
- (PokemonHabitat)_parseHabitatWithLocationType:(NSString *)locationType {
  NSLog(@"locationType:%@", locationType);
  PokemonHabitat habitat;
  if ([locationType isEqualToString:@"premise"] || [locationType isEqualToString:@"subpremise"])
    habitat = kPokemonHabitatCave;
  else if ([locationType isEqualToString:@"natural_feature"])
    habitat = kPokemonHabitatForest;
  else if ([locationType isEqualToString:@"park"])
    habitat = kPokemonHabitatGrassland;
  else if ([locationType isEqualToString:@"airport"])
    habitat = kPokemonHabitatMountain;
  else if ([locationType isEqualToString:@"colloquial_area"])
    habitat = kPokemonHabitatRoughTerrain;
  else if ([locationType isEqualToString:@""])
    habitat = kPokemonHabitatSea;
  else if ([locationType isEqualToString:@"street_address"] ||
           [locationType isEqualToString:@"route"] ||
           [locationType isEqualToString:@"intersection"] ||
           [locationType isEqualToString:@"locality"] ||
           [locationType isEqualToString:@"sublocality"] ||
           [locationType isEqualToString:@"political"] ||
           [locationType isEqualToString:@"country"] ||
           [locationType isEqualToString:@"administrative_area_level_1"] ||
           [locationType isEqualToString:@"administrative_area_level_2"] ||
           [locationType isEqualToString:@"administrative_area_level_3"])
    habitat = kPokemonHabitatUrban;
  else if ([locationType isEqualToString:@"neighborhood"])
    habitat = kPokemonHabitatWatersEdge;
  else
    habitat = kPokemonHabitatRare;
  
  return habitat;
}

/*/ Filter Pokemon SIDs for current fetched Wild Pokemon Grounp
- (NSArray *)filterSIDs:(NSArray *)SIDs {
  NSLog(@"ORIGINAL SIDs:%@", SIDs);
  if (SIDs == nil || [SIDs count] == 0)
    return nil;
  
  NSMutableArray * newSIDs = [NSMutableArray array];
  for (id SID in SIDs) {
  }
  NSLog(@"NEW SIDs:%@", newSIDs);
  return newSIDs;
}*/

@end
