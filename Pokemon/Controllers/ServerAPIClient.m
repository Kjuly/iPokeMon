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
NSString * const kServerAPIRoot         = @"http://localhost:8080";
// User
NSString * const kServerAPIGetUserID    = @"/id";      // /uid:User's Unique ID
NSString * const kServerAPIGetUser      = @"/u";      // /u:User
NSString * const kServerAPIUpdateUser   = @"/update";
// User's Pokemon
NSString * const kServerAPIGetPokemon   = @"/pm/%d";  // /pm:PokeMon/<PokemonID:Int>
NSString * const kServerAPIGet6Pokemons = @"/6pm";    // /6pm:SixPokeMons
NSString * const kServerAPIGetPokedex   = @"/pd";     // /pd:PokeDex
// WildPokemon
NSString * const kServerAPIGetWildPokemon = @"/wpm";  // /wp:WildPokeMon

#pragma mark -
#pragma mark - ServerAPI
@interface ServerAPI ()
// User
+ (NSString *)getUserID;                                    // GET
+ (NSString *)getUser;                                      // GET
+ (NSString *)updateUser;                                   // POST
// User's Pokemon
+ (NSString *)getPokemonWithPokemonID:(NSInteger)pokemonID; // GET
+ (NSString *)getSixPokemons;                               // GET
+ (NSString *)getPokedex;                                   // GET
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

// User's Pokemon
+ (NSString *)getPokemonWithPokemonID:(NSInteger)pokemonID {
  return [NSString stringWithFormat:kServerAPIGetPokemon, pokemonID];
}

+ (NSString *)getSixPokemons { return kServerAPIGet6Pokemons; }
+ (NSString *)getPokedex     { return kServerAPIGetPokedex; }

// WildPokemon
+ (NSString *)getWildPokemon { return kServerAPIGetWildPokemon; }

@end

#pragma mark -
#pragma mark - ServerAPIClient
@interface ServerAPIClient () {
 @private
  
}

- (void)updateHeaderWithRegion:(BOOL)withRegion;
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
  
  [self updateHeaderWithRegion:NO];
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
  else return;
  
  [self updateHeaderWithRegion:NO];
  NSLog(@"Sync Data Request - clientDescription:%@", [self description]);
  [self postPath:path parameters:data success:success failure:failure];
}

#pragma mark - Public Methods: WildPokemon

- (void)updateWildPokemonsForCurrentRegionSuccess:(void (^)(AFHTTPRequestOperation *, id))success
                                          failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
  [self updateHeaderWithRegion:YES];
  [self postPath:[ServerAPI getWildPokemon] parameters:nil success:success failure:failure];
}

#pragma mark - Provate Methods

- (void)updateHeaderWithRegion:(BOOL)withRegion {
  [self setDefaultHeader:@"provider" value:
    [NSString stringWithFormat:@"%d",
      [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsLastUsedServiceProvider]]];
  [self setDefaultHeader:@"identity" value:[[OAuthManager sharedInstance] userEmailInMD5]];
  
  // Include user location info if needed
  if (withRegion) {
    
  }
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
