//
//  GlobalNotificationConstants.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/24/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

// Notification for UserDefaults changed
extern NSString * const kPMNUDGeneralLocationServices;  // general - location service
extern NSString * const kPMNUDGeneralBandwidthUsage;    // general - bandwidth useage
extern NSString * const kPMNUDGameSettingsVolumeMaster; // game settings - master volume
extern NSString * const kPMNUDGameSettingsVolumeMusic;  // game settings - music volume
extern NSString * const kPMNUDGameSettingsVolumeSounds; // game settings - sounds volume

extern NSString * const kPMNSessionIsInvalid;
extern NSString * const kPMNAuthenticating;
extern NSString * const kPMNLoginSucceed;
extern NSString * const kPMNShowNewbieGuide;
extern NSString * const kPMNShowConfirmButtonInNebbieGuide;
extern NSString * const kPMNHideConfirmButtonInNebbieGuide;

extern NSString * const kPMNEnableTracking;  // enable  tracking
extern NSString * const kPMNDisableTracking; // disable tracking
extern NSString * const kPMNCloseCenterMenu;
extern NSString * const kPMNChangeCenterMainButtonStatus;
//extern NSString * const kPMNBackToMainView;
extern NSString * const kPMNToggleTabBar;

extern NSString * const kPMNPokemonAppeared;
extern NSString * const kPMNBattleStart;
extern NSString * const kPMNBattleEnd;
extern NSString * const kPMNToggleSixPokemons;

extern NSString * const kPMNUpdateGameMenuKeyView;
extern NSString * const kPMNReplacePokemon;
extern NSString * const kPMNReplacePlayerPokemon;
extern NSString * const kPMNCatchWildPokemon;
extern NSString * const kPMNPokeballGetWildPokemon;
extern NSString * const kPMNPokeballLossWildPokemon;
extern NSString * const kPMNPokeballChecking;
extern NSString * const kPMNUseItemForSelectedPokemon;
extern NSString * const kPMNUseBagItemDone;
//extern NSString * const kPMNMoveEffect;
extern NSString * const kPMNUpdateGameBattleMessage;
//extern NSString * const kPMNInitializePokemonStatus;
extern NSString * const kPMNUpdatePokemonStatus;
extern NSString * const kPMNShowPokemonStatus;
extern NSString * const kPMNToggleTopCancelButton;
extern NSString * const kPMNPlayerPokemonFaint;
extern NSString * const kPMNEnemyPokemonFaint;

extern NSString * const kPMNGameBattleRunEvent;
extern NSString * const kPMNGameBattleEnd;
extern NSString * const kPMNGameBattleEndWithEvent;

extern NSString * const kPMNLoadingDone;

@interface GlobalNotificationConstants : NSObject

@end
