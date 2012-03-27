//
//  OAuthManager.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "OAuthManager.h"

static NSString * const kOAuthGoogleClientID         = @"890704274988.apps.googleusercontent.com";
static NSString * const kOAuthGoogleClientSecret     = @"skqxc_5MysvtBsFFhIXqADr2";
static NSString * const kOAuthGoogleKeychainItemName = @"PM: Google+ OAuth2";
static NSString * const kOAuthGoogleScope            = @"https://www.googleapis.com/auth/plus.me"; // scope for Google+ API


@interface OAuthManager () {
 @private
  GTMOAuth2Authentication * oauth_;
}

@property (nonatomic, retain) GTMOAuth2Authentication * oauth;

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error;

@end

@implementation OAuthManager

@synthesize oauth = oauth_;

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
  
  [super dealloc];
}

- (id)init
{
  if (self = [super init]) {
    oauth_ = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kOAuthGoogleKeychainItemName
                                                                   clientID:kOAuthGoogleClientID
                                                               clientSecret:kOAuthGoogleClientSecret];
  }
  return self;
}

#pragma mark - Public Methods

- (UIViewController *)loginWith:(OAuthServiceProviderChoice)loginProvider
{
  NSString * clientID;         // Client ID
  NSString * clientSecret;     // Client Secret
  NSString * keychainItemName; // Keychain Item Name
  NSString * scope;            // Scope
  SEL finishedSelector = @selector(viewController:finishedWithAuth:error:);
  
  switch (loginProvider) {
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

// Session status for User
- (BOOL)isSessionValid {
  NSLog(@"<::LOG::> OAuthManager - isSessionValid: Email:%@, VerifiedEmail:%@, ClientID:%@, ClientSecret:%@, TokenType:%@, AccessToken:%@, RefreshToken:%@, Code:%@, UserData:%@", self.oauth.userEmail,self.oauth.userEmailIsVerified, self.oauth.clientID, self.oauth.clientSecret, self.oauth.tokenType, self.oauth.accessToken, self.oauth.refreshToken, self.oauth.code, self.oauth.userData);
  return [self.oauth canAuthorize];
}

#pragma mark - Private Methods

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
  if (error != nil) {
    // Authentication failed (perhaps the user denied access, or closed the
    // window before granting access)
    NSLog(@"Authentication error: %@", error);
    NSData *responseData = [[error userInfo] objectForKey:@"data"]; // kGTMHTTPFetcherStatusDataKey
    if ([responseData length] > 0) {
      // show the body of the server's authentication failure response
      NSString *str = [[[NSString alloc] initWithData:responseData
                                             encoding:NSUTF8StringEncoding] autorelease];
      NSLog(@"%@", str);
    }
    
    self.oauth = nil;
  } else {
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
  }
}

@end
