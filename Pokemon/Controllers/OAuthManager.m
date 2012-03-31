//
//  OAuthManager.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "OAuthManager.h"

#import "PokemonServerAPI.h"
#import "TrainerCoreDataController.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"


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

#pragma mark - OAuthManager Constants
NSString * const kUserDefaultsLastUsedServiceProvider = @"keyLastUsedServiceProvider";

// TODO:
//   Encrypt them!!!
static NSString * const kOAuthGoogleClientID         = @"890704274988.apps.googleusercontent.com";
static NSString * const kOAuthGoogleClientSecret     = @"skqxc_5MysvtBsFFhIXqADr2";
static NSString * const kOAuthGoogleKeychainItemName = @"PMOAuth2_Google";
static NSString * const kOAuthGoogleScope            = @"https://www.googleapis.com/auth/plus.me"; // scope for Google+ API


#pragma mark -
#pragma mark - ServerAPI
@interface ServerAPI ()
// User
+ (NSURL *)getUserID;                                    // GET
+ (NSURL *)getUser;                                      // GET
+ (NSURL *)updateUser;                                   // POST
// User's Pokemon
+ (NSURL *)getPokemonWithPokemonID:(NSInteger)pokemonID; // GET
+ (NSURL *)getSixPokemons;                               // GET
+ (NSURL *)getPokedex;                                   // GET
@end


@implementation ServerAPI
// User
+ (NSURL *)getUserID {
  return [NSURL URLWithString:[kServerAPIRoot stringByAppendingString:kServerAPIGetUserID]];
}

+ (NSURL *)getUser {
  return [NSURL URLWithString:[kServerAPIRoot stringByAppendingString:kServerAPIGetUser]];
}

+ (NSURL *)updateUser {
  return [NSURL URLWithString:[kServerAPIRoot stringByAppendingString:kServerAPIUpdateUser]];
}

// User's Pokemon
+ (NSURL *)getPokemonWithPokemonID:(NSInteger)pokemonID {
  NSString * subPath = [NSString stringWithFormat:kServerAPIGetPokemon, pokemonID];
  return [NSURL URLWithString:[kServerAPIRoot stringByAppendingString:subPath]];
}

+ (NSURL *)getSixPokemons {
  return [NSURL URLWithString:[kServerAPIRoot stringByAppendingString:kServerAPIGet6Pokemons]];
}

+ (NSURL *)getPokedexWithProvider:(OAuthServiceProviderChoice)provider identity:(NSString *)identity {
  return [NSURL URLWithString:[kServerAPIRoot stringByAppendingString:kServerAPIGetPokedex]];
}

+ (NSURL *)getPokedex {
  return [NSURL URLWithString:[kServerAPIRoot stringByAppendingString:kServerAPIGetPokedex]];
}

@end


#pragma mark -
#pragma mark - OAuthManager
@interface OAuthManager () {
 @private
  NSOperationQueue           * operationQueue_;          // Operation Queue
  GTMOAuth2Authentication    * oauth_;                   // OAuth object
  OAuthServiceProviderChoice   selectedServiceProvider_; // Selected service provider
  BOOL                         isUserIDSynced_;          // Mark for whether user ID has been synced
}

@property (nonatomic, retain) NSOperationQueue           * operationQueue;
@property (nonatomic, retain) GTMOAuth2Authentication    * oauth;
@property (nonatomic, assign) OAuthServiceProviderChoice   selectedServiceProvider;
@property (nonatomic, assign) BOOL                         isUserIDSynced;

- (NSDictionary *)oauthDataFor:(OAuthServiceProviderChoice)serviceProvider;
- (void)syncUserID;                                      // Current authticated User's ID (Trainer's |uid|)
- (void)setHTTPHeaderForRequest:(NSMutableURLRequest *)request; // Set HTTP Header for URL request
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error;

@end


@implementation OAuthManager

@synthesize operationQueue          = operationQueue_;
@synthesize oauth                   = oauth_;
@synthesize selectedServiceProvider = selectedServiceProvider_;
@synthesize isUserIDSynced          = isUserIDSynced_;

// Singleton
static OAuthManager * oauthManager_ = nil;
+ (OAuthManager *)sharedInstance
{
  if (oauthManager_ != nil) return oauthManager_;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    oauthManager_ = [[OAuthManager alloc] init];
  });
  return oauthManager_;
}

- (void)dealloc
{
  self.oauth = nil;
  
  [self.operationQueue cancelAllOperations];
  self.operationQueue = nil;
  
  [super dealloc];
}

- (id)init
{
  if (self = [super init]) {
    isUserIDSynced_ = NO;
    
    OAuthServiceProviderChoice lastUsedServiceProvider =
      [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsLastUsedServiceProvider];
    self.selectedServiceProvider = lastUsedServiceProvider;
    NSDictionary * oauthData = [self oauthDataFor:lastUsedServiceProvider];
    self.oauth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:[oauthData valueForKey:@"keychainItemName"]
                                                                       clientID:[oauthData valueForKey:@"clientID"]
                                                                   clientSecret:[oauthData valueForKey:@"clientSecret"]];
    oauthData = nil;
  }
  return self;
}

#pragma mark - Public Methods

// Login with a service provider
- (UIViewController *)loginWith:(OAuthServiceProviderChoice)serviceProvider
{
  self.selectedServiceProvider = serviceProvider;                             // Set selected service provider
  NSDictionary * oauthData     = [self oauthDataFor:serviceProvider];         // OAuth data for the service provider
  NSString * clientID          = [oauthData valueForKey:@"clientID"];         // Client ID
  NSString * clientSecret      = [oauthData valueForKey:@"clientSecret"];     // Client Secret
  NSString * keychainItemName  = [oauthData valueForKey:@"keychainItemName"]; // Keychain Item Name
  NSString * scope             = [oauthData valueForKey:@"scope"];            // Scope
  SEL finishedSelector         = @selector(viewController:finishedWithAuth:error:);
  
  GTMOAuth2ViewControllerTouch * loginViewController;
  loginViewController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:scope
                                                                   clientID:clientID
                                                               clientSecret:clientSecret
                                                           keychainItemName:keychainItemName
                                                                   delegate:self
                                                           finishedSelector:finishedSelector];
  // Optional: display some html briefly before the sign-in page loads
  NSString * html = @"<html><body bgcolor=silver><div align=center>Loading sign-in page...</div></body></html>";
  loginViewController.initialHTMLString = html;
  
  return [loginViewController autorelease];
}

// Revoke authorized service
- (void)revokeAuthorizedWith:(OAuthServiceProviderChoice)serviceProvider {
  NSDictionary * oauthData = [self oauthDataFor:serviceProvider];
  NSString * keychainItemName = [oauthData valueForKey:@"keychainItemName"];
  [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:keychainItemName];
  [GTMOAuth2ViewControllerTouch revokeTokenForGoogleAuthentication:self.oauth];
  self.oauth       = nil;
  oauthData        = nil;
  keychainItemName = nil;
}

// Logout
- (void)logout {
  self.isUserIDSynced = NO;
  self.oauth          = nil;
  [self.operationQueue cancelAllOperations];
}

// Session status for User
- (BOOL)isSessionValid {
  NSLog(@"<::LOG::> OAuthManager - isSessionValid: Email:%@, VerifiedEmail:%@, ClientID:%@, ClientSecret:%@, TokenType:%@, AccessToken:%@, RefreshToken:%@, Code:%@, UserData:%@", self.oauth.userEmail,self.oauth.userEmailIsVerified, self.oauth.clientID, self.oauth.clientSecret, self.oauth.tokenType, self.oauth.accessToken, self.oauth.refreshToken, self.oauth.code, self.oauth.userData);
  if (! [self.oauth canAuthorize]) return NO;
  if (! self.isUserIDSynced) [self syncUserID];
  return YES;
}

// Current authticated User's ID (Trainer's |uid|)
//- (NSInteger)userID {
//  ///Fetch Data from server & populate the |trainer|
//  // Success Block Method
//  void (^success)(NSURLRequest *, NSHTTPURLResponse *, id) =
//  ^(NSURLRequest * request, NSHTTPURLResponse * response, id JSON) {
//    NSLog(@"...Get |userID| for current user succeed...userID:%d", [[JSON valueForKey:@"userID"] intValue]);
//  };
//  
//  // Failure Block Method
//  void (^failure)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id) =
//  ^(NSURLRequest *request, NSHTTPURLResponse * response, NSError * error, id JSON) {
//    NSLog(@"!!! Get |userID| for current user failed. ERROR: %@", error);
//  };
//  
//  [[OAuthManager sharedInstance] fetchDataFor:kDataFetchTargetTrainer success:success failure:failure];
//}

// Current service provider user using
- (OAuthServiceProviderChoice)serviceProvider {
  return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsLastUsedServiceProvider];
}

#pragma mark - Private Methods

// Get OAuth data for the service provider
- (NSDictionary *)oauthDataFor:(OAuthServiceProviderChoice)serviceProvider
{
  NSString * clientID;         // Client ID
  NSString * clientSecret;     // Client Secret
  NSString * keychainItemName; // Keychain Item Name
  NSString * scope;            // Scope
  switch (serviceProvider) {
    case kOAuthServiceProviderChoiceFacebook:
      //clientID         = kOAuthGoogleClientID;
      //clientSecret     = kOAuthGoogleClientSecret;
      //keychainItemName = kOAuthGoogleKeychainItemName;
      //scope            = kOAuthGoogleScope;
      break;
      
    case kOAuthServiceProviderChoiceGithub:
      //clientID         = kOAuthGoogleClientID;
      //clientSecret     = kOAuthGoogleClientSecret;
      //keychainItemName = kOAuthGoogleKeychainItemName;
      //scope            = kOAuthGoogleScope;
      break;
      
    case kOAuthServiceProviderChoiceGoogle:
      clientID         = kOAuthGoogleClientID;
      clientSecret     = kOAuthGoogleClientSecret;
      keychainItemName = kOAuthGoogleKeychainItemName;
      scope            = kOAuthGoogleScope;
      break;
      
    case kOAuthServiceProviderChoiceTwitter:
      //clientID         = kOAuthGoogleClientID;
      //clientSecret     = kOAuthGoogleClientSecret;
      //keychainItemName = kOAuthGoogleKeychainItemName;
      //scope            = kOAuthGoogleScope;
      break;
      
    case kOAuthServiceProviderChoiceWeibo:
      //clientID         = kOAuthGoogleClientID;
      //clientSecret     = kOAuthGoogleClientSecret;
      //keychainItemName = kOAuthGoogleKeychainItemName;
      //scope            = kOAuthGoogleScope;
      break;
      
    default:
      break;
  }
  return [NSDictionary dictionaryWithObjectsAndKeys:
          clientID,         @"clientID",
          clientSecret,     @"clientSecret",
          keychainItemName, @"keychainItemName",
          scope,            @"scope", nil];
}

// Current authticated User's ID (Trainer's |uid|)
- (void)syncUserID {
  // Success Block Method
  void (^success)(NSURLRequest *, NSHTTPURLResponse *, id) =
    ^(NSURLRequest * request, NSHTTPURLResponse * response, id JSON) {
      self.isUserIDSynced = YES;
      NSInteger userID = [[JSON valueForKey:@"userID"] intValue];
      NSLog(@"|syncUserID| - Get |userID| for current user succeed... userID:%d", userID);
      [[TrainerCoreDataController sharedInstance] initTrainerWithUserID:userID];
    };
  // Failure Block Method
  void (^failure)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id) =
    ^(NSURLRequest *request, NSHTTPURLResponse * response, NSError * error, id JSON) {
      NSLog(@"!!! |syncUserID| - Get |userID| for current user failed. ERROR: %@", error);
    };
  
  // Fetch data for Trainer
  NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[ServerAPI getUserID]];
  [self setHTTPHeaderForRequest:request];
  [request setHTTPMethod:@"GET"];
  NSLog(@"|syncUserID| - Request URL:%@ --- HTTPHeader:%@", [ServerAPI getUserID], [request allHTTPHeaderFields]);
  AFJSONRequestOperation * operation;
  operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
  [request release];
  [operation start];
  [self.operationQueue addOperation:operation];
}

// Set HTTP Header for URL request
- (void)setHTTPHeaderForRequest:(NSMutableURLRequest *)request {
  NSString * provider = [NSString stringWithFormat:@"%d",
                         [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsLastUsedServiceProvider]];
  [request setValue:@"123456" forHTTPHeaderField:@"key"];
  [request setValue:provider forHTTPHeaderField:@"provider"];
  [request setValue:self.oauth.userEmail forHTTPHeaderField:@"identity"];
}

// Callback for method:|loginWith:|
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
  if (error != nil) {
    // Authentication failed (perhaps the user denied access, or closed the
    // window before granting access)
    NSLog(@"Authentication error: %@", error);
    NSData * responseData = [[error userInfo] objectForKey:@"data"]; // kGTMHTTPFetcherStatusDataKey
    if ([responseData length] > 0) {
      // show the body of the server's authentication failure response
      NSString * str = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
      NSLog(@"%@", str);
    }
    self.oauth = nil;
    self.selectedServiceProvider =
      [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsLastUsedServiceProvider];
  } else {
    NSLog(@"Authentication succeeded..");
    // Authentication succeeded
    //
    // At this point, we either use the authentication object to explicitly
    // authorize requests, like
    //
    //  [auth authorizeRequest:myNSURLMutableRequest
    //       completionHandler:^(NSError *error) {
    //         if (error == nil) {
    //           // request here has been authorized
    //         }
    //       }];
    //
    // or store the authentication object into a fetcher or a Google API service
    // object like
    //
    //   [fetcher setAuthorizer:auth];
    
    // save the authentication object
    self.oauth = auth;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:self.selectedServiceProvider forKey:kUserDefaultsLastUsedServiceProvider];
    [userDefaults synchronize];
    userDefaults = nil;
    
    // Current authticated User's ID (Trainer's |uid|)
    [self syncUserID];
  }
}

#pragma mark - C/S Data Transfer Methods

- (void)fetchDataFor:(DataFetchTarget)target
             success:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id))success
             failure:(void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id))failure {
  // Fetch data for Trainer
  if (target & kDataFetchTargetTrainer) {
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[ServerAPI getUser]];
    [self setHTTPHeaderForRequest:request];
    [request setHTTPMethod:@"GET"];
    NSLog(@"Request URL:%@ --- HTTPHeader:%@", [ServerAPI getUser], [request allHTTPHeaderFields]);
    AFJSONRequestOperation * operation;
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
    [request release];
    [operation start];
    [self.operationQueue addOperation:operation];
  }
  // Fetch data for Trainer's Pokedex
  if (target & kDataFetchTargetTamedPokemon) {
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[ServerAPI getPokedex]];
    [self setHTTPHeaderForRequest:request];
    [request setHTTPMethod:@"GET"];
    NSLog(@"Request URL:%@ --- HTTPHeader:%@", [ServerAPI getPokedex], [request allHTTPHeaderFields]);
    AFJSONRequestOperation * operation;
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
    [request release];
    [operation start];
    [self.operationQueue addOperation:operation];
  }
}

- (void)updateData:(NSDictionary *)data
         forTarget:(DataFetchTarget)target
           success:(void (^)(AFHTTPRequestOperation *, id))success
           failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
  NSString * provider = [NSString stringWithFormat:@"%d",
                         [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsLastUsedServiceProvider]];
  // Update data for Trainer
  if (target & kDataFetchTargetTrainer) {
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[ServerAPI updateUser]];
    [client setDefaultHeader:@"key"      value:@"123456"];
    [client setDefaultHeader:@"provider" value:provider];
    [client setDefaultHeader:@"identity" value:self.oauth.userEmail];
    NSLog(@"Sync Data Request - clientDescription:%@", [client description]);
    [client postPath:@"" parameters:data success:success failure:failure];
    [client release];
  }
}

@end
