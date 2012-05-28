//
//  ServerAPIClient.m
//  Pokemon
//
//  Created by Kaijie Yu on 4/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "ServerAPIClient.h"

#import "OAuthManager.h"
#import "AFJSONRequestOperation.h"

#pragma mark - Constants
#pragma mark - ServerAPI Constants
#ifdef LOCAL_SERVER
NSString * const kServerAPIRoot = @"http://localhost:8080";
#else
NSString * const kServerAPIRoot = @"http://184.169.146.32:8080";
#endif
// Connection Checking
NSString * const kServerAPICheckConnection = @"/cc";     // /cc:Check Connection
// User
NSString * const kServerAPIGetUserID       = @"/id";     // /uid:User's Unique ID
NSString * const kServerAPIGetUser         = @"/u";      // /u:User
NSString * const kServerAPIUpdateUser      = @"/uu";     // /uu:Update User
NSString * const kServerAPICheckUniqueness = @"/cu";     // /cu:Check Uniqueness
// User's Pokemon
NSString * const kServerAPIGetPokemon      = @"/pm/%d";  // /pm:PokeMon/<PokemonSID:int>
NSString * const kServerAPIGet6Pokemons    = @"/6pm";    // /6pm:SixPokeMons
NSString * const kServerAPIGetPokedex      = @"/pd";     // /pd:PokeDex
NSString * const kServerAPIUpdatePokemon   = @"/upm";    // /upm:Update PokeMon
// pokemon area
NSString * const kServerAPIGetAllPokemonsArea = @"/pma";     // /pma:PokeMon Area
NSString * const kServerAPIGetPokemonArea     = @"/pma/%d";  // /pma:PokeMon Area/<PokemonSID:int>
// Region
// <code> = <cc>:<ca>:<cl>
//   <cc>: code country
//   <ca>: code administrative are
//   <cl>: code locality
NSString * const kServerAPIGetRegion    = @"/r/%@";  // /r:Region/<code>
NSString * const kServerAPIUpdateRegion = @"/ur";    // /ur:Update Region (push new region to server)
// WildPokemon
NSString * const kServerAPIGetWildPokemon = @"/wpm";    // /wp:WildPokeMon
// Map Annotations
NSString * const kServerAPIGetAnnotation = @"/mas/%@"; // /mas:Map AnnotationS/<code>

#pragma mark -
#pragma mark - ServerAPI
@interface ServerAPI ()
// Connection checking
+ (NSString *)checkConnection;                              // GET
// User
+ (NSString *)getUserID;                                    // GET
+ (NSString *)getUser;                                      // GET
+ (NSString *)updateUser;                                   // POST
+ (NSString *)checkUniquenessForName;                       // POST
// User's Pokemon
+ (NSString *)getPokemonWithPokemonID:(NSInteger)pokemonID; // GET
+ (NSString *)getSixPokemons;                               // GET
+ (NSString *)getPokedex;                                   // GET
+ (NSString *)updatePokemon;                                // POST
// Pokemon Area
+ (NSString *)getAllPokemonsArea;                      // GET
+ (NSString *)getAreaForPokemonWithSID:(NSInteger)SID; // GET
// Region
+ (NSString *)getRegionWithCode:(NSString *)code; // GET
+ (NSString *)updateRegion; // POST
// WildPokemon
+ (NSString *)getWildPokemon;
// Annotation
+ (NSString *)getAnnotationWithCode:(NSString *)code; // GET
@end


@implementation ServerAPI
#pragma mark - Public Methods
+ (NSURL *)getURLForUserID {
  return [NSURL URLWithString:[kServerAPIRoot stringByAppendingString:kServerAPIGetUserID]];
}

#pragma mark - Private Methods
// Connection checking
+ (NSString *)checkConnection { return kServerAPICheckConnection; }
// User
+ (NSString *)getUserID  { return kServerAPIGetUserID; }
+ (NSString *)getUser    { return kServerAPIGetUser; }
+ (NSString *)updateUser { return kServerAPIUpdateUser; }
+ (NSString *)checkUniquenessForName { return kServerAPICheckUniqueness; }

// User's Pokemon
+ (NSString *)getPokemonWithPokemonID:(NSInteger)pokemonID {
  return [NSString stringWithFormat:kServerAPIGetPokemon, pokemonID];
}

+ (NSString *)getSixPokemons { return kServerAPIGet6Pokemons; }
+ (NSString *)getPokedex     { return kServerAPIGetPokedex; }
+ (NSString *)updatePokemon  { return kServerAPIUpdatePokemon; }

// Pokemon Area
+ (NSString *)getAllPokemonsArea { return kServerAPIGetAllPokemonsArea; }
+ (NSString *)getAreaForPokemonWithSID:(NSInteger)SID {
  return [NSString stringWithFormat:kServerAPIGetPokemonArea, SID];
}

// Region
+ (NSString *)getRegionWithCode:(NSString *)code {
  return [NSString stringWithFormat:kServerAPIGetRegion, code];
}
+ (NSString *)updateRegion { return kServerAPIUpdateRegion; }

// WildPokemon
+ (NSString *)getWildPokemon { return kServerAPIGetWildPokemon; }

// Annotation
+ (NSString *)getAnnotationWithCode:(NSString *)code {
  return [NSString stringWithFormat:kServerAPIGetAnnotation, code];
}

@end

#pragma mark -
#pragma mark - ServerAPIClient

// HTTP headers for request to web server
// Default: |key|, |provider|, |identity|
typedef enum {
  kHTTPHeaderDefault    = 1 << 0,
  kHTTPHeaderWithRegion = 1 << 1  // region
}HTTPHeaderFlag;

@interface ServerAPIClient () {
 @private
  NSString * regionCode_; // record current region code
}

@property (nonatomic, copy) NSString * regionCode;

- (void)updateHeaderWithFlag:(HTTPHeaderFlag)flag;
- (void)_updateRegion:(NSNotification *)notification;
//- (void)setHTTPHeaderForRequest:(NSMutableURLRequest *)request; // Set HTTP Header for URL request

@end

@implementation ServerAPIClient

@synthesize regionCode = regionCode_;

// singleton
static ServerAPIClient * client_;
+ (ServerAPIClient *)sharedInstance {
  if (client_ != nil)
    return client_;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    client_ = [[ServerAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kServerAPIRoot]];
  });
  return client_;
}

- (void)dealloc {
  self.regionCode = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNUpdateRegion object:nil];
  [super dealloc];
}

- (id)initWithBaseURL:(NSURL *)url {
  if (self = [super initWithBaseURL:url]) {
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setDefaultHeader:@"key"    value:kClientIdentifier];
    
    self.regionCode = @"XX";
    // add observer for notification from |PMLocationManager| when region changed
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_updateRegion:)
                                                 name:kPMNUpdateRegion
                                               object:nil];
  }
  return self;
}

#pragma mark - Public Methods

// Method for checking connection to server
- (void)checkConnectionToServerSuccess:(void (^)(AFHTTPRequestOperation *, id))success
                               failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
  [self updateHeaderWithFlag:kHTTPHeaderDefault];
  NSLog(@"Request URL");
  [self getPath:[ServerAPI checkConnection] parameters:nil success:success failure:failure];
}

#pragma mark - Public Methods: Trainer

// GET userID
- (void)fetchUserIDSuccess:(void (^)(AFHTTPRequestOperation *, id))success
                   failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
  [self updateHeaderWithFlag:kHTTPHeaderDefault];
  NSLog(@"Request UserID");
  [self getPath:[ServerAPI getUserID] parameters:nil success:success failure:failure];
}

// GET
- (void)fetchDataFor:(DataFetchTarget)target
          withObject:(id)object
             success:(void (^)(AFHTTPRequestOperation *, id))success
             failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
  NSString * path;
  if (target & kDataFetchTargetTrainer)
    path = [ServerAPI getUser];
  else if (target & kDataFetchTargetTamedPokemon)
    path = [ServerAPI getPokedex];
  else if (target & kDataFetchTargetAllPokemonsArea)
    path = [ServerAPI getAllPokemonsArea];
  else if (target & kDataFetchTargetPokemonArea)
    path = [ServerAPI getAreaForPokemonWithSID:[object intValue]];
  else if (target & kDataFetchTargetRegion)
    path = [ServerAPI getRegionWithCode:self.regionCode];
  else if (target & kDataFetchTargetAnnotation)
    path = [ServerAPI getAnnotationWithCode:self.regionCode];
  else return;
  
  [self updateHeaderWithFlag:kHTTPHeaderDefault];
  [self getPath:path parameters:nil success:success failure:failure];
  NSLog(@"Request with URL tail:%@", path);
  
  /*/ *** Legacy ***
   success:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id))success
   failure:(void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id))failure {}   
   
  NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[ServerAPI getUser]];
  [self setHTTPHeaderForRequest:request];
  [request setHTTPMethod:@"GET"];
  NSLog(@"Request URL:%@ --- HTTPHeader:%@", [ServerAPI getUser], [request allHTTPHeaderFields]);
  AFJSONRequestOperation * operation;
  operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
  [request release];
  [operation start];
  [self.operationQueue addOperation:operation];*/
}

// POST
- (void)updateData:(NSDictionary *)data
         forTarget:(DataFetchTarget)target
           success:(void (^)(AFHTTPRequestOperation *, id))success
           failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
  NSString * path;
  if (target & kDataFetchTargetTrainer)
    path = [ServerAPI updateUser];
  else if (target & kDataFetchTargetTamedPokemon)
    path = [ServerAPI updatePokemon];
  else if (target & kDataFetchTargetRegion)
    path = [ServerAPI updateRegion];
  else return;
  
  [self updateHeaderWithFlag:kHTTPHeaderDefault];
  NSLog(@"Sync Data Request");
  [self postPath:path parameters:data success:success failure:failure];
}

// POST: Check uniqueness for the |name|
- (void)checkUniquenessForName:(NSString *)name
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
  [self updateHeaderWithFlag:kHTTPHeaderDefault];
  NSLog(@"Request URL...");
  [self postPath:[ServerAPI checkUniquenessForName]
      parameters:[NSDictionary dictionaryWithObject:name forKey:@"name"]
         success:success
         failure:failure];
}

#pragma mark - Public Methods: WildPokemon

// Update data for Wild Pokemon at current Region
//   |regionInfo|:
//                 { "t"(type):XXX, ... }
- (void)updateWildPokemonsForCurrentRegion:(NSDictionary *)regionInfo
                                   success:(void (^)(AFHTTPRequestOperation *, id))success
                                   failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
  [self updateHeaderWithFlag:kHTTPHeaderDefault | kHTTPHeaderWithRegion];
  [self getPath:[ServerAPI getWildPokemon]
     parameters:regionInfo
        success:success
        failure:failure];
}

#pragma mark - Provate Methods

- (void)updateHeaderWithFlag:(HTTPHeaderFlag)flag {
  // Reset headers to empty
  [self setDefaultHeader:@"provider" value:nil];
  [self setDefaultHeader:@"identity" value:nil];
  [self setDefaultHeader:@"region"   value:nil];
  
  // Default headers
  if (flag & kHTTPHeaderDefault) {
    [self setDefaultHeader:@"provider" value:
      [NSString stringWithFormat:@"%d",
        [[NSUserDefaults standardUserDefaults] integerForKey:kUDKeyLastUsedServiceProvider]]];
    [self setDefaultHeader:@"identity" value:[[OAuthManager sharedInstance] userEmailInMD5]];
  }
  
  // Include user location info if needed
  if (flag & kHTTPHeaderWithRegion) [self setDefaultHeader:@"region" value:@"1"];                      
}

// update region (code, ...)
- (void)_updateRegion:(NSNotification *)notification {
  self.regionCode = notification.object;
}

// Set HTTP Header for URL request
//- (void)setHTTPHeaderForRequest:(NSMutableURLRequest *)request {
//  NSString * provider = [NSString stringWithFormat:@"%d",
//                         [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsLastUsedServiceProvider]];
//  [request setValue:@"123456" forHTTPHeaderField:@"key"];
//  [request setValue:provider forHTTPHeaderField:@"provider"];
//  [request setValue:[[OAuthManager sharedInstance] userEmailInMD5] forHTTPHeaderField:@"identity"];
//}

@end
