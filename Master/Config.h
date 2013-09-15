//
//  Config.h
//  Master
//
//  Created by Kjuly on 1/18/13.
//  Copyright (c) 2013 Kjuly. All rights reserved.
//

//
// NOTE:
//
// Use
//
//     $ git update-index --assume-unchanged Master/Config.*
//
// to ignore changes in Config.h/m files.
//
// When you need a new MACRO or Configuration Param,
//   recover the content in Config.* files to original & add what you want,
//   then start tracking changes again
//
//     $ git update-index --no-assume-unchanged Master/Config.*
//     $ git checkout // Reset configuration back to default
//     <Do modification>
//     $ git add Master/Config.*
//     $ git commit -m "Modify Config.*"
//     $ git update-index --assume-unchanged Master/Config.*
//

#import <Foundation/Foundation.h>

/*
 * Feature
 */
#define KY_ICLOUD_ENABLED 1                       // Use iCloud Service (ON)
#define KY_COPY_COREDATA_IF_NOT_EXIST 1           // Copy CoreData from bundle (ON)
//#define KY_INVITATION_ONLY 1                      // Invitation only (OFF)

/*
 * DEV
 */
// - DEV (#define THE_MACRO - DEV: Macro Description (Defualt Value))
//#define KY_TAKE_LAUNCH_SCREENSHOT 1               // DEV: Take screenshow for launch image (OFF)
//#define KY_POPULATE_COREDATA  1                   // DEV: Populate CoreData from plist files (OFF)
//#define KY_LOCAL_SERVER_ON 1                      // DEV: Use local server for testing (OFF)
//#define KY_TESTFLIGHT_ON 1                        // DEV: Turn on TestFlight (OFF)
#define KY_SESSION_MODE_ON 1                      // DEV: Turn on session mode (ON)

/*
 * Resource Management
 */
// Update if Resource Bundle is offered
#define KY_RESOURCE_UPDATE_IMAGE 1                  // DEV: Update Image (ON)
//#define KY_RESOURCE_UPDATE_PROPERTY_LIST 1          // DEV: Update Property List (ON)
#define KY_RESOURCE_UPDATE_SOUND 1                  // DEV: Update Sound (ON)

/*
 * LBS Related
 */
#define KY_CORELOCATION_ON 1                      // DEV: Turn on Core Lcation service (ON)
#define KY_LOCATION_SERVICE_LOW_BATTERY_MODE_ON 1 // DEV: Turn on low battery mode for location service (ON)
//#define KY_PLAYER_MOVEMENT_SIMULATION_ON 1        // DEV: Turn on palyer movement simulation (OFF)

/*
 * Game Battle Scene Related
 */
//#define KY_DEFAULT_VIEW_GAME_BATTLE_ON 1          // DEV: Set game battle view as the default view (OFF)
//#define KY_SUPER_POKEMON_MODE_ON 1                // DEV: Turn on super PokeMon mode (OFF)

/*
 * TestFilght
 */
#ifdef KY_TESTFLIGHT_ON
extern NSString * const kTestFlightToken;
#endif

/*
 * Device UID
 */
// Use secret Device UID key for security reason (ON)
#define APPLY_SECRET_DEVICE_UID_KEY 1
//
// Define a custom key for the Device UID in the keychain
//   e.g. "your_secret_device_identifier"
#ifdef APPLY_SECRET_DEVICE_UID_KEY
extern NSString * const kDeviceUIDKey;
#endif

/*
 * Server
 */
// e.g. http://123.123.123.123:8080
extern NSString * const kServerAPIRoot;

/*
 * OAuth Configuration
 */
// Client Identifier to match C/S,
//   any string value is okay, but alpha is better
//   e.g. "iPokeMonClientIdentifier"
extern NSString * const kOAuthClientIdentifier;
//
// Google
// Client ID for Google's Authentication
//   e.g. "123456789012.apps.googleusercontent.com"
extern NSString * const kOAuthGoogleClientID;
//
// Client Secret for Google's Authentication
//   e.g. "O0vXxXPUR7xXxYKz7xX6SLQ"
extern NSString * const kOAuthGoogleClientSecret;
//
// Item name to be stored in keychain for Google OpenID
// Any string value is okay, but alpha is better
//   e.g. "PMOAuth2_Google"
extern NSString * const kOAuthGoogleKeychainItemName;
//
// Scope for Google+ API,
extern NSString * const kOAuthGoogleScope;

/*
 * In-App Purchase Configuration
 */
// Tiers
extern NSString * const kIAPCurrencyTier1;
extern NSString * const kIAPCurrencyTier2;
extern NSString * const kIAPCurrencyTier3;


// LIBs
/*
 * KYUnlockCodeManager
 */
// Use a unique code as a general code to unlock the feature in any device,
//   and it's mainly for Apple's Review Process.
//#define kKYUnlockCodeManagerUniqueCodeDefined 1
// Define a unique code for KYUnlockCodeManager
//   e.g. "abcdef"
#ifdef kKYUnlockCodeManagerUniqueCodeDefined
extern NSString * const kKYUnlockCodeManagerUniqueCode;
#endif


@interface Config : NSObject

@end
