//
//  GlobalNotificationConstants.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/24/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "Constants.h"

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
NSString * const kUDKeyResourceBundlePath      = @"keyResourceBundlePath";      // Resource bundle path
///END UserDefaults
//////

#pragma mark - Notifications

NSString * const kPMNPermitUserAction = @"PMNPermitUserAction"; // permit user action
NSString * const kPMNBanUserAction    = @"PMNBanUserAction";    // ban user action
NSString * const kPMNResetDeviceUID   = @"PMNResetDeviceUID";   // reset device's UID

NSString * const kPMNError        = @"PMNError";        // notification for ERROR
NSString * const kPMNUpdateRegion = @"PMNUpdateRegion"; // notification for updating region (code, ...)
NSString * const kPMNUserLogout   = @"PMNUserLogout";   // notif for reset data when user logout

// Notification for UserDefaults changed
NSString * const kPMNUDGeneralLocationServices  = @"PMNUDGeneralLocationServices";  // general - location service
NSString * const kPMNUDGeneralBandwidthUsage    = @"PMNUDGeneralBandwidthUsage";    // general - bandwidth useage
NSString * const kPMNUDGameSettingsVolumeMaster = @"PMNUDGameSettingsVolumeMaster"; // game settings - master volume
NSString * const kPMNUDGameSettingsVolumeMusic  = @"PMNUDGameSettingsVolumeMusic";  // game settings - music volume
NSString * const kPMNUDGameSettingsVolumeSounds = @"PMNUDGameSettingsVolumeSounds"; // game settings - sounds volume

// PMN: PokeMon Notification
NSString * const kPMNSessionIsInvalid               = @"PMNSessionIsInvalid";
NSString * const kPMNAuthenticating                 = @"PMNAuthenticating";
NSString * const kPMNLoginSucceed                   = @"PMNLoginSucceed";
NSString * const kPMNShowNewbieGuide                = @"PMNShowNewbiewGuide";
NSString * const kPMNShowConfirmButtonInNebbieGuide = @"PMNShowConfirmButtonInNebbieGuide";
NSString * const kPMNHideConfirmButtonInNebbieGuide = @"PMNHideConfirmButtonInNebbieGuide";

NSString * const kPMNUpdateStoreItemQuantity = @"PMNUpdateStoreItemQuantity";

NSString * const kPMNEnableTracking               = @"PMNEnableTracking";  // enable  tracking
NSString * const kPMNDisableTracking              = @"PMNDisableTracking"; // disable tracking
NSString * const kPMNCloseCenterMenu              = @"PMNCloseCenterMenu";
NSString * const kPMNChangeCenterMainButtonStatus = @"PMNChangeCenterMainButtonStatus";
//NSString * const kPMNBackToMainView               = @"PMNBackToMainView";

NSString * const kPMNGenerateNewWildPokemon = @"PMNGenerateNewWildPokemon";
NSString * const kPMNPokemonAppeared        = @"PMNPokemonAppeared";
NSString * const kPMNBattleEnd              = @"PMNBattleEnd";
NSString * const kPMNToggleSixPokemons      = @"kPMNToggleSixPokemons";

NSString * const kPMNUpdateGameMenuKeyView     = @"PMNUpdateGameMenuKeyView";
NSString * const kPMNReplacePokemon            = @"PMNReplacePokemon";
NSString * const kPMNReplacePlayerPokemon      = @"PMNReplacePlayerPokemon";
NSString * const kPMNCatchWildPokemon          = @"PMNCatchWildPokemon";        // Try to throw Pokeball to catch WildPokemon
NSString * const kPMNPokeballGetWildPokemon    = @"PMNPokeballGetWildPokemon";  // Pokeball get WildPokemon
NSString * const kPMNPokeballLossWildPokemon   = @"PMNPokeballLossWildPokemon"; // Pokeball loss WildPokemon
NSString * const kPMNPokeballChecking          = @"kPMNPokeballChecking";       // Pokeball checking for WildPokemon
NSString * const kPMNUseItemForSelectedPokemon = @"PMNUseItemForSelectedPokemon";
NSString * const kPMNUseBagItemDone            = @"PMNUseBagItemDone";
//NSString * const kPMNMoveEffect = @"PMNMoveEffect";
NSString * const kPMNUpdateGameBattleMessage   = @"PMNUpdateGameBattleMessage";
//NSString * const kPMNInitializePokemonStatus = @"PMNInitializePokemonStatus";
NSString * const kPMNUpdatePokemonStatus       = @"PMNUpdatePokemonStatus";
NSString * const kPMNShowPokemonStatus         = @"PMNShowPokemonStatus";
NSString * const kPMNToggleTopCancelButton     = @"PMNToggleTopCancelButton";
NSString * const kPMNPlayerPokemonFaint        = @"PMNPlayerPokemonFaint"; // Player Pokemon FAINT
NSString * const kPMNEnemyPokemonFaint         = @"PMNEnemyPokemonFaint";  // Enemy Pokemon FAINT

// Game Battle END
NSString * const kPMNGameBattleRunEvent     = @"PMNGameBattleRunEvent";     // Run EVENT for game battle
NSString * const kPMNGameBattleEnd          = @"PMNGameBattleEnd";          // END Game Battle
NSString * const kPMNGameBattleEndWithEvent = @"PMNGameBattleEndWithEvent"; // Battle END with Event

NSString * const kPMNLoadingDone = @"PMNLoadingDone"; // Loading done

@implementation Constants

@end
