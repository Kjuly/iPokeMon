//
//  ServerAPIClient.m
//  Pokemon
//
//  Created by Kaijie Yu on 4/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "ServerAPIClient.h"

#import "GlobalConstants.h"
#import "OAuthManager.h"
#import "AFJSONRequestOperation.h"

#pragma mark - Constants
#pragma mark - ServerAPI Constants
NSString * const kServerAPIRoot            = @"http://localhost:8080";
// User
NSString * const kServerAPIGetUserID       = @"/id";     // /uid:User's Unique ID
NSString * const kServerAPIGetUser         = @"/u";      // /u:User
NSString * const kServerAPIUpdateUser      = @"/uu";     // /uu:Update User
NSString * const kServerAPICheckUniqueness = @"/cu";     // /cu:Check Uniqueness
// User's Pokemon
NSString * const kServerAPIGetPokemon      = @"/pm/%d";  // /pm:PokeMon/<PokemonID:Int>
NSString * const kServerAPIGet6Pokemons    = @"/6pm";    // /6pm:SixPokeMons
NSString * const kServerAPIGetPokedex      = @"/pd";     // /pd:PokeDex
NSString * const kServerAPIUpdatePokemon   = @"/upm";    // /upm:Update PokeMon
// WildPokemon
NSString * const kServerAPIGetWildPokemon  = @"/wpm";    // /wp:WildPokeMon

#pragma mark -
#pragma mark - ServerAPI
@interface ServerAPI ()
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
// WildPokemon
+ (NSString *)getWildPokemon;
@end


@implementation ServerAPI
#pragma mark - Public Methods
+ (NSURL *)getURLForUserID {
  return [NSURL URLWithString:[kServerAPIRoot stringByAppendingString:kServerAPIGetUserID]];
}

#pragma mark - Private Methods
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

// WildPokemon
+ (NSString *)getWildPokemon { return kServerAPIGetWildPokemon; }

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
  
}

- (void)updateHeaderWithFlog:(HTTPHeaderFlag)flag;
//- (void)setHTTPHeaderForRequest:(NSMutableURLRequest *)request; // Set HTTP Header for URL request

@end

@implementation ServerAPIClient

static ServerAPIClient * client_;
+ (ServerAPIClient *)sharedInstance {
  if (client_ != nil)
    return client_;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    client_ = [[ServerAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:8080"]];
  });
  return client_;
}

- (id)initWithBaseURL:(NSURL *)url {
  if (self = [super initWithBaseURL:url]) {
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setDefaultHeader:@"key"    value:@"123456"];
  }
  return self;
}

#pragma mark - Public Methods
#pragma mark - Public Methods: Trainer

// GET
- (void)fetchDataFor:(DataFetchTarget)target
             success:(void (^)(AFHTTPRequestOperation *, id))success
             failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
  NSString * path;
  if (target & kDataFetchTargetTrainer)
    path = [ServerAPI getUser];
  else if (target & kDataFetchTargetTamedPokemon)
    path = [ServerAPI getPokedex];
  else return;
  
  [self updateHeaderWithFlog:kHTTPHeaderDefault];
  NSLog(@"Request URL Description:%@", [self description]);
  [self getPath:path parameters:nil success:success failure:failure];
  
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
  else return;
  
  [self updateHeaderWithFlog:kHTTPHeaderDefault];
  NSLog(@"Sync Data Request - clientDescription:%@", [self description]);
  [self postPath:path parameters:data success:success failure:failure];
}

// POST: Check uniqueness for the |name|
- (void)checkUniquenessForName:(NSString *)name
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
  [self updateHeaderWithFlog:kHTTPHeaderDefault];
  NSLog(@"Request URL Description:%@", [self description]);
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
  [self updateHeaderWithFlog:kHTTPHeaderDefault | kHTTPHeaderWithRegion];
  [self getPath:[ServerAPI getWildPokemon]
     parameters:regionInfo
        success:success
        failure:failure];
}

#pragma mark - Provate Methods

- (void)updateHeaderWithFlog:(HTTPHeaderFlag)flag {
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

// Set HTTP Header for URL request
//- (void)setHTTPHeaderForRequest:(NSMutableURLRequest *)request {
//  NSString * provider = [NSString stringWithFormat:@"%d",
//                         [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsLastUsedServiceProvider]];
//  [request setValue:@"123456" forHTTPHeaderField:@"key"];
//  [request setValue:provider forHTTPHeaderField:@"provider"];
//  [request setValue:[[OAuthManager sharedInstance] userEmailInMD5] forHTTPHeaderField:@"identity"];
//}

@end
