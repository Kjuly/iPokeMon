//
//  Config.h
//  iPokeMon
//
//  Created by Kjuly on 1/18/13.
//  Copyright (c) 2013 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

// - Basic
#define KY_ICLOUD_ENABLED 1             // Use iCloud Service
//#define KY_COPY_COREDATA_IF_NOT_EXIST 1 // Copy CoreData from bundle

// - DEV
// #define THE_MACRO                                // DEV: Macro Description (Defualt Value)
//#define KY_TAKE_LAUNCH_SCREENSHOT 1               // DEV: Take screenshow for launch image (OFF)
//#define KY_POPULATE_COREDATA  1                   // DEV: Populate CoreData from plist files (OFF)
#define KY_LOCAL_SERVER_ON 1                      // DEV: Use local server for testing (OFF)
#define KY_TESTFLIGHT_ON 1                        // DEV: Turn on TestFlight (OFF)
//#define KY_SESSION_MODE_ON 1                      // DEV: Turn on session mode (ON)
// - - LBS
#define KY_CORELOCATION_ON 1                      // DEV: Turn on Core Lcation service (ON)
//#define KY_LOCATION_SERVICE_LOW_BATTERY_MODE_ON 1 // DEV: Turn on low battery mode for location service (ON)
#define KY_PLAYER_MOVEMENT_SIMULATION_ON 1        // DEV: Turn on palyer movement simulation (OFF)

// - - Game
//#define KY_DEFAULT_VIEW_GAME_BATTLE_ON 1        // DEV: Set game battle view as the default view (OFF)
//#define KY_SUPER_POKEMON_MODE_ON 1              // DEV: Turn on super PokeMon mode (OFF)


@interface Config : NSObject

@end
