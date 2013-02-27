//
//  Config.m
//  Master
//
//  Created by Kjuly on 1/18/13.
//  Copyright (c) 2013 Kjuly. All rights reserved.
//

#import "Config.h"

/*
 * Server
 */
// e.g. http://123.123.123.123:8080
NSString * const kServerAPIRoot = @"";

/*
 *pragma mark - OAuth Configuration
 */
// Client Identifier to match C/S,
//   any string value is okay, but alpha is better
//   e.g. "iPokeMonClientIdentifier"
NSString * const kOAuthClientIdentifier = @"";
//
// Google
// Client ID for Google's Authentication
//   e.g. "123456789012.apps.googleusercontent.com"
NSString * const kOAuthGoogleClientID = @"<id>.apps.googleusercontent.com";
//
// Client Secret for Google's Authentication
//   e.g. "O0vXxXPUR7xXxYKz7xX6SLQ"
NSString * const kOAuthGoogleClientSecret = @"";
//
// Item name to be stored in keychain for Google OpenID
// Any string value is okay, but alpha is better
//   e.g. "PMOAuth2_Google"
NSString * const kOAuthGoogleKeychainItemName = @"";
//
// Scope for Google+ API,
NSString * const kOAuthGoogleScope = @"https://www.googleapis.com/auth/plus.me";

/*
 * In-App Purchase Configuration
 */
// Tiers
NSString * const kIAPCurrencyTier1 = @"<your_identifier>.coin.tier1";
NSString * const kIAPCurrencyTier2 = @"<your_identifier>.coin.tier2";
NSString * const kIAPCurrencyTier3 = @"<your_identifier>.coin.tier3";


/*
 * LIB: UIApplication+UIID
 */
// If APPLY_SECRET_UIID_KEY if on,
//   define a key for the UIID in the keychain or UserDefaults
//   e.g. "uniqueInstallationIdentifier"
#ifdef APPLY_SECRET_UIID_KEY
NSString * const kUIIDKey = @"<your_secret_unique_installation_identifier>";
#endif


@implementation Config

@end