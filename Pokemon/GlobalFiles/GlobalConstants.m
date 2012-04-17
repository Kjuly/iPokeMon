//
//  GlobalNotificationConstants.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/24/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GlobalConstants.h"

#pragma mark - User Defaults

///UserDefautls
// Settings.bundle
NSString * const kUDKeyGeneralLocationServices = @"keyGeneralLocationServices"; // enable location tracking (bool)
NSString * const kUDKeyGeneralBandwidthUsage   = @"keyGeneralBandwidthUsage";   // bandwidth useage (number:0,1,2)
// Game settings
NSString * const kUDKeyGeneralGameSettings     = @"keyGeneralGameSettings";
NSString * const kUDKeyGameSettingsMasterTitle = @"keyGameSettingsMasterTitle";
NSString * const kUDKeyGameSettingsMaster      = @"keyGameSettingsMaster";      // master volume (slider [0,100])
NSString * const kUDKeyGameSettingsMusicTitle  = @"keyGameSettingsMusicTitle";
NSString * const kUDKeyGameSettingsMusic       = @"keyGameSettingsMusic";       // music volume (slider [0,100])
NSString * const kUDKeyGameSettingsSoundsTitle = @"keyGameSettingsSoundsTitle";
NSString * const kUDKeyGameSettingsSounds      = @"keyGameSettingsSounds";      // sounds volume (slider [0,100])
NSString * const kUDKeyGameSettingsAnimations  = @"keyGameSettingsAnimations";  // enable animations (switch)
// About
NSString * const kUDKeyAboutVersion            = @"keyAboutVersion";            // version for App

///Extra UserDefaults
NSString * const kUDKeyLastUsedServiceProvider = @"keyLastUsedServiceProvider"; // last Service Provider used
///END UserDefaults
//////

@implementation GlobalConstants

@end
