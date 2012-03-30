//
//  OAuthManager.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "OAuthManager.h"

#import "PokemonServerAPI.h"
#import "AFJSONRequestOperation.h"


#pragma mark - Constants
#pragma mark - ServerAPI Constants
NSString * const kServerAPIRootWithAuth = @"http://localhost:8080";
NSString * const kServerAPIOAuth        = @"/%d/%@"; // ROOT/<Provider:Int>/<Identity:String>
// User
NSString * const kServerAPIGetUser      = @"";
NSString * const kServerAPIUpdateUser   = @"/update";
// User's Pokemon
NSString * const kServerAPIGetPokemon   = @"/pm/%d"; // /pm:PokeMon/<PokemonID:Int>
NSString * const kServerAPIGet6Pokemons = @"/6pm";   // /6pm:SixPokeMons
NSString * const kServerAPIGetPokedex   = @"/pd";    // /pd:PokeDex

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
+ (NSURL *)getUserWithProvider:(OAuthServiceProviderChoice)provider        // GET
                      identity:(NSString *)identity;
+ (BOOL)updateUserWithProvider:(OAuthServiceProviderChoice)provider        // POST
                      identity:(NSString *)identity
                          data:(NSDictionary *)data;
// User's Pokemon
+ (NSURL *)getPokemonWithProvider:(OAuthServiceProviderChoice)provider     // GET
                         identity:(NSString *)identity
                        pokemonID:(NSInteger)pokemonID;
+ (NSURL *)getSixPokemonsWithProvider:(OAuthServiceProviderChoice)provider // GET
                             identity:(NSString *)identity;
+ (NSURL *)getPokedexWithProvider:(OAuthServiceProviderChoice)provider     // GET
                         identity:(NSString *)identity;
@end


@implementation ServerAPI
// User
// GET
+ (NSURL *)getUserWithProvider:(OAuthServiceProviderChoice)provider
                      identity:(NSString *)identity {
  NSString * oauthString = [NSString stringWithFormat:kServerAPIOAuth, provider, identity];
  NSString * subPath     = [oauthString stringByAppendingString:kServerAPIGetUser];
  return [NSURL URLWithString:[kServerAPIRootWithAuth stringByAppendingString:subPath]];
}

// POST
+ (BOOL)updateUserWithProvider:(OAuthServiceProviderChoice)provider
                      identity:(NSString *)identity
                          data:(NSDictionary *)data {
  return NO;
}

// User's Pokemon
// GET
+ (NSURL *)getPokemonWithProvider:(OAuthServiceProviderChoice)provider
                         identity:(NSString *)identity
                        pokemonID:(NSInteger)pokemonID {
  NSString * oauthString = [NSString stringWithFormat:kServerAPIOAuth, provider, identity];
  NSString * subPath     = [oauthString stringByAppendingString:
                            [NSString stringWithFormat:kServerAPIGetPokemon, pokemonID]];
  return [NSURL URLWithString:[kServerAPIRootWithAuth stringByAppendingString:subPath]];
}

+ (NSURL *)getSixPokemonsWithProvider:(OAuthServiceProviderChoice)provider
                             identity:(NSString *)identity {
  NSString * oauthString = [NSString stringWithFormat:kServerAPIOAuth, provider, identity];
  NSString * subPath     = [oauthString stringByAppendingString:kServerAPIGet6Pokemons];
  return [NSURL URLWithString:[kServerAPIRootWithAuth stringByAppendingString:subPath]];
}

+ (NSURL *)getPokedexWithProvider:(OAuthServiceProviderChoice)provider
                         identity:(NSString *)identity {
  NSString * oauthString = [NSString stringWithFormat:kServerAPIOAuth, provider, identity];
  NSString * subPath     = [oauthString stringByAppendingString:kServerAPIGetPokedex];
  return [NSURL URLWithString:[kServerAPIRootWithAuth stringByAppendingString:subPath]];
}

@end


#pragma mark -
#pragma mark - OAuthManager
@interface OAuthManager () {
 @private
  NSOperationQueue           * operationQueue_;          // Operation Queue
  GTMOAuth2Authentication    * oauth_;                   // OAuth object
  OAuthServiceProviderChoice   selectedServiceProvider_; // Selected service provider
}

@property (nonatomic, retain) NSOperationQueue           * operationQueue;
@property (nonatomic, retain) GTMOAuth2Authentication    * oauth;
@property (nonatomic, assign) OAuthServiceProviderChoice   selectedServiceProvider;

- (NSDictionary *)oauthDataFor:(OAuthServiceProviderChoice)serviceProvider;
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error;

@end


@implementation OAuthManager

@synthesize operationQueue          = operationQueue_;
@synthesize oauth                   = oauth_;
@synthesize selectedServiceProvider = selectedServiceProvider_;

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
- (void)logout
{
  
}

// Session status for User
- (BOOL)isSessionValid {
  NSLog(@"<::LOG::> OAuthManager - isSessionValid: Email:%@, VerifiedEmail:%@, ClientID:%@, ClientSecret:%@, TokenType:%@, AccessToken:%@, RefreshToken:%@, Code:%@, UserData:%@", self.oauth.userEmail,self.oauth.userEmailIsVerified, self.oauth.clientID, self.oauth.clientSecret, self.oauth.tokenType, self.oauth.accessToken, self.oauth.refreshToken, self.oauth.code, self.oauth.userData);
  return [self.oauth canAuthorize];
}

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
  }
}

#pragma mark - C/S Data Transfer Methods

- (void)fetchDataFor:(DataFetchTarget)target
             success:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id))success
             failure:(void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id))failure {
  OAuthServiceProviderChoice provider =
  [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsLastUsedServiceProvider];
  
  // Fetch data for Trainer
  if (target & kDataFetchTargetTrainer) {
    NSLog(@"RequestURL: %@", [ServerAPI getUserWithProvider:provider identity:self.oauth.userEmail]);
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[ServerAPI getUserWithProvider:provider
                                                                                     identity:self.oauth.userEmail]];
    AFJSONRequestOperation * operation;
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
    [request release];
    [operation start];
    [self.operationQueue addOperation:operation];
  }
  // Fetch data for Trainer's Pokedex
  if (target & kDataFetchTargetTamedPokemon) {
    NSLog(@"RequestURL: %@", [ServerAPI getPokedexWithProvider:provider identity:self.oauth.userEmail]);
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[ServerAPI getPokedexWithProvider:provider
                                                                                        identity:self.oauth.userEmail]];
    AFJSONRequestOperation * operation;
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
    [request release];
    [operation start];
    [self.operationQueue addOperation:operation];
  }
}

- (void)updateDataFor:(DataFetchTarget)target
              success:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id))success
              failure:(void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id))failure
{
  
}

@end
