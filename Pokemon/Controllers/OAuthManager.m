//
//  OAuthManager.m
//  iPokeMon
//
//  Created by Kaijie Yu on 3/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "OAuthManager.h"

#import "NSString+Algorithm.h"
#import "ServerAPIClient.h"
#import "TrainerController.h"
#import "LoadingManager.h"

#pragma mark -
#pragma mark - OAuthManager
@interface OAuthManager () {
 @private
  NSString * clientIdentifier_,
           * oAuthGoogleClientID_,
           * oAuthGoogleClientSecret_,
           * oAuthGoogleKeychainItemName_,
           * oAuthGoogleScope_;
  LoadingManager             * loadingManager_;          // Loading manager
  NSOperationQueue           * operationQueue_;          // Operation Queue
  GTMOAuth2Authentication    * oauth_;                   // OAuth object
  OAuthServiceProviderChoice   selectedServiceProvider_; // Selected service provider
  BOOL                         isUserIDSynced_;          // Mark for whether user ID has been synced
  BOOL                         isUserIDSyncing_;         // avoid multiple synces
}

@property (nonatomic, copy) NSString * clientIdentifier,
                                     * oAuthGoogleClientID,
                                     * oAuthGoogleClientSecret,
                                     * oAuthGoogleKeychainItemName,
                                     * oAuthGoogleScope;
@property (nonatomic, retain) LoadingManager          * loadingManager;
@property (nonatomic, retain) NSOperationQueue        * operationQueue;
@property (nonatomic, retain) GTMOAuth2Authentication * oauth;

- (NSDictionary *)_oauthDataFor:(OAuthServiceProviderChoice)serviceProvider;
- (void)_syncUserID;                                     // Current authticated User's ID (Trainer's |uid|)
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error;

@end


@implementation OAuthManager

@synthesize isNewworkAvailable = isNewworkAvailable_;
@synthesize clientIdentifier            = clientIdentifier_,
            oAuthGoogleClientID         = oAuthGoogleClientID_,
            oAuthGoogleClientSecret     = oAuthGoogleClientSecret_,
            oAuthGoogleKeychainItemName = oAuthGoogleKeychainItemName_,
            oAuthGoogleScope            = oAuthGoogleScope_;
@synthesize loadingManager = loadingManager_;
@synthesize operationQueue = operationQueue_;
@synthesize oauth          = oauth_;

// Singleton
static OAuthManager * oauthManager_ = nil;
+ (OAuthManager *)sharedInstance {
  if (oauthManager_ != nil) return oauthManager_;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    oauthManager_ = [[OAuthManager alloc] init];
  });
  return oauthManager_;
}

- (void)dealloc {
  self.clientIdentifier = nil;
  self.oAuthGoogleClientID =
    self.oAuthGoogleClientSecret =
    self.oAuthGoogleKeychainItemName,
    self.oAuthGoogleScope = nil;
  self.oauth = nil;
  [self.operationQueue cancelAllOperations];
  self.operationQueue = nil;
  
  [super dealloc];
}

- (id)init {
  if (self = [super init]) {
    self.loadingManager = [LoadingManager sharedInstance];
    isNewworkAvailable_ = YES;
    isUserIDSynced_     = NO;
    isUserIDSyncing_    = NO;
    
    // TODO:
    //   Encrypt them!!!
    self.clientIdentifier            = kOAuthClientIdentifier;
    self.oAuthGoogleClientID         = kOAuthGoogleClientID;
    self.oAuthGoogleClientSecret     = kOAuthGoogleClientSecret;
    self.oAuthGoogleKeychainItemName = kOAuthGoogleKeychainItemName;
    self.oAuthGoogleScope            = kOAuthGoogleScope;
    
    OAuthServiceProviderChoice lastUsedServiceProvider =
      [[NSUserDefaults standardUserDefaults] integerForKey:kUDKeyLastUsedServiceProvider];
    selectedServiceProvider_ = lastUsedServiceProvider;
    NSDictionary * oauthData = [self _oauthDataFor:lastUsedServiceProvider];
    self.oauth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:[oauthData valueForKey:@"keychainItemName"]
                                                                       clientID:[oauthData valueForKey:@"clientID"]
                                                                   clientSecret:[oauthData valueForKey:@"clientSecret"]];
    oauthData = nil;
  }
  return self;
}

#pragma mark - Public Methods

// Session status for User
- (BOOL)isSessionValid {
  NSLog(@"CHECKING SESSION...");
//  NSLog(@"Email:%@, VerifiedEmail:%@, ClientID:%@, ClientSecret:%@, TokenType:%@, AccessToken:%@, RefreshToken:%@, Code:%@, UserData:%@", self.oauth.userEmail,self.oauth.userEmailIsVerified, self.oauth.clientID, self.oauth.clientSecret, self.oauth.tokenType, self.oauth.accessToken, self.oauth.refreshToken, self.oauth.code, self.oauth.userData);
  if (! [self.oauth canAuthorize]) {
    NSLog(@"INVALID SESSION...");
    return NO;
  }
  // if newwork not available, no need to sync |userID_|
  if (! self.isNewworkAvailable)
    return NO;
  
  // if |userID_| not synced & current is not doing sync work, do it
  if (! isUserIDSynced_ && ! isUserIDSyncing_)
    [self _syncUserID];
  NSLog(@"VALID SESSION...");
  return YES;
}

// User Email in MD5
- (NSString *)userEmailInMD5 {
  return [[[self.oauth.userEmail stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]] lowercaseString] toMD5];
}

// Current service provider user using
- (OAuthServiceProviderChoice)serviceProvider {
  return [[NSUserDefaults standardUserDefaults] integerForKey:kUDKeyLastUsedServiceProvider];
}

// Login with a service provider
- (UIViewController *)loginWith:(OAuthServiceProviderChoice)serviceProvider {  
  selectedServiceProvider_ = serviceProvider;                      // Set selected service provider
  NSDictionary * oauthData = [self _oauthDataFor:serviceProvider]; // OAuth data for the service provider
  SEL finishedSelector     = @selector(viewController:finishedWithAuth:error:);
  GTMOAuth2ViewControllerTouch * loginViewController;
  loginViewController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:[oauthData valueForKey:@"scope"]
                                                                   clientID:[oauthData valueForKey:@"clientID"]
                                                               clientSecret:[oauthData valueForKey:@"clientSecret"]
                                                           keychainItemName:[oauthData valueForKey:@"keychainItemName"]
                                                                   delegate:self
                                                           finishedSelector:finishedSelector];
  // Optional: display some html briefly before the sign-in page loads
  loginViewController.initialHTMLString = @"SHOW";
  
  return [loginViewController autorelease];
}

// Revoke authorized service
- (void)revokeAuthorizedWith:(OAuthServiceProviderChoice)serviceProvider {
  NSDictionary * oauthData = [self _oauthDataFor:serviceProvider];
  NSString * keychainItemName = [oauthData valueForKey:@"keychainItemName"];
  [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:keychainItemName];
  [GTMOAuth2ViewControllerTouch revokeTokenForGoogleAuthentication:self.oauth];
  self.oauth              = nil;
  self.isNewworkAvailable = YES;
  isUserIDSynced_         = NO;
  isUserIDSyncing_        = NO;
  oauthData               = nil;
  keychainItemName        = nil;
}

// Logout
- (void)logout {
  NSLog(@"LOGOUT...");
  [self.operationQueue cancelAllOperations];
  [self revokeAuthorizedWith:[[NSUserDefaults standardUserDefaults] integerForKey:kUDKeyLastUsedServiceProvider]];
  // Session is invalid, so post notification to |MainViewController| to open login view
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNSessionIsInvalid object:self userInfo:nil];
  // post notif to |TrainerController| to reset data
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUserLogout object:nil];
}

#pragma mark - Private Methods

// Get OAuth data for the service provider
- (NSDictionary *)_oauthDataFor:(OAuthServiceProviderChoice)serviceProvider {
  NSString * clientID;         // Client ID
  NSString * clientSecret;     // Client Secret
  NSString * keychainItemName; // Keychain Item Name
  NSString * scope;            // Scope
  switch (serviceProvider) {
    //case kOAuthServiceProviderChoiceFacebook:
      //clientID         = kOAuthGoogleClientID;
      //clientSecret     = kOAuthGoogleClientSecret;
      //keychainItemName = kOAuthGoogleKeychainItemName;
      //scope            = kOAuthGoogleScope;
      //break;
      
    //case kOAuthServiceProviderChoiceGithub:
      //clientID         = kOAuthGoogleClientID;
      //clientSecret     = kOAuthGoogleClientSecret;
      //keychainItemName = kOAuthGoogleKeychainItemName;
      //scope            = kOAuthGoogleScope;
      //break;
      
    case kOAuthServiceProviderChoiceGoogle:
      clientID         = oAuthGoogleClientID_;
      clientSecret     = oAuthGoogleClientSecret_;
      keychainItemName = oAuthGoogleKeychainItemName_;
      scope            = oAuthGoogleScope_;
      break;
      
    //case kOAuthServiceProviderChoiceTwitter:
      //clientID         = kOAuthGoogleClientID;
      //clientSecret     = kOAuthGoogleClientSecret;
      //keychainItemName = kOAuthGoogleKeychainItemName;
      //scope            = kOAuthGoogleScope;
      //break;
      
    //case kOAuthServiceProviderChoiceWeibo:
      //clientID         = kOAuthGoogleClientID;
      //clientSecret     = kOAuthGoogleClientSecret;
      //keychainItemName = kOAuthGoogleKeychainItemName;
      //scope            = kOAuthGoogleScope;
      //break;
      
    default:
      clientID         = oAuthGoogleClientID_;
      clientSecret     = oAuthGoogleClientSecret_;
      keychainItemName = oAuthGoogleKeychainItemName_;
      scope            = oAuthGoogleScope_;
      break;
  }
  return [NSDictionary dictionaryWithObjectsAndKeys:
          clientID,         @"clientID",
          clientSecret,     @"clientSecret",
          keychainItemName, @"keychainItemName",
          scope,            @"scope", nil];
}

// Current authticated User's ID (Trainer's |uid|)
- (void)_syncUserID {
  // Block: |success| & |failure|
  void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"Request for |_syncUserID| SUCCEED...Start INIT trainer...");
    isUserIDSynced_  = YES;
    isUserIDSyncing_ = NO;
    // Init data from SERVER to CLIENT for Trainer, including TrainerTamedPokemon, six PMs, etc
    [[TrainerController sharedInstance] initTrainerWithUserID:[[responseObject valueForKey:@"userID"] intValue]];
    // Hide loading
    [self.loadingManager hideOverBar];
  };
  void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"!!! |_syncUserID| - Get |userID| for current user failed. ERROR: %@", error);
    self.isNewworkAvailable = NO;
    isUserIDSyncing_ = NO;
    // Hide loading
    [self.loadingManager hideOverBar];
#ifdef KY_SESSION_MODE_ON
    // Post notification to |MainViewController| to warn Network not available view
    NSDictionary * userInfo =
      [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:kPMErrorNetworkNotAvailable], @"error", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNError object:self userInfo:userInfo];
    [userInfo release];
#endif
  };
  
  // Show loading
  [self.loadingManager showOverBar];
  isUserIDSyncing_ = YES;
  // Fetch userID for current user
  [[ServerAPIClient sharedInstance] fetchUserIDSuccess:success failure:failure];
}

// Callback for method:|loginWith:|
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
  if (error != nil) {
    // Authentication failed (perhaps the user denied access, or closed the
    // window before granting access)
    NSLog(@"Authentication FAILED. ERROR: %@", error);
    NSData * responseData = [[error userInfo] objectForKey:@"data"]; // kGTMHTTPFetcherStatusDataKey
    if ([responseData length] > 0) {
      // show the body of the server's authentication failure response
      NSString * str = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
      NSLog(@"%@", str);
      [str release];
    }
    self.oauth = nil;
    selectedServiceProvider_ = [[NSUserDefaults standardUserDefaults] integerForKey:kUDKeyLastUsedServiceProvider];
    // Post notification to |MainViewController| to show view of |FullScreenLoadingViewController|
    //   that the authentication failed.
    NSDictionary * userInfo =
      [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:kPMErrorAuthenticationFailed], @"error", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNError object:self userInfo:userInfo];
    [userInfo release];
  } else {
    NSLog(@"Authentication SUCCEED...");
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
    [userDefaults setInteger:selectedServiceProvider_ forKey:kUDKeyLastUsedServiceProvider];
    [userDefaults synchronize];
    userDefaults = nil;
    // Current authticated User's ID (Trainer's |uid|)
    [self _syncUserID];
    // Post notification to |LoginTableViewController| to hide login view
    NSDictionary * userInfo =
      [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"succeed", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNLoginSucceed object:self userInfo:userInfo];
    [userInfo release];
  }
}

@end
