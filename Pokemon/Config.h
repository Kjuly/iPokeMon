//
//  Config.h
//  iPokeMon
//
//  Created by Kjuly on 1/18/13.
//  Copyright (c) 2013 Kjuly. All rights reserved.
//

//
// NOTE:
//
// DO NOT modify content here if you just want to do configuration.
// Just copy these two files (Config-Sample.h/m) as Config.h/m,
//   and rename Config_Sample to Config in both .h/.m files.
// Then you can modify the configuration there.
// Config.h/m will be ignored when you commit to the repo, so keep a copy locally,
//   otherwise they'll disappear when you switch between branches.
//
// When you need a new MACRO or Configuration Param,
//   please DON't FORGET to add it here after you've added to Config.h/m,
//   and COMMENT IT OUT like ones shown below.
//

#import <Foundation/Foundation.h>

/*
 * Feature
 */
#define KY_ICLOUD_ENABLED 1                       // Use iCloud Service (ON)
#define KY_COPY_COREDATA_IF_NOT_EXIST 1           // Copy CoreData from bundle (ON)

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


@interface Config : NSObject

@end
