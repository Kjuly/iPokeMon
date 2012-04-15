//
//  GlobalNotificationConstants.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/24/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GlobalNotificationConstants.h"

// PMN: PokeMon Notification
NSString * const kPMNSessionIsInvalid               = @"PMNSessionIsInvalid";
NSString * const kPMNAuthenticating                 = @"PMNAuthenticating";
NSString * const kPMNLoginSucceed                   = @"PMNLoginSucceed";
NSString * const kPMNShowNewbieGuide                = @"PMNShowNewbiewGuide";
NSString * const kPMNShowConfirmButtonInNebbieGuide = @"PMNShowConfirmButtonInNebbieGuide";
NSString * const kPMNHideConfirmButtonInNebbieGuide = @"PMNHideConfirmButtonInNebbieGuide";

NSString * const kPMNCloseCenterMenu              = @"PMNCloseCenterMenu";
NSString * const kPMNChangeCenterMainButtonStatus = @"PMNChangeCenterMainButtonStatus";
//NSString * const kPMNBackToMainView               = @"PMNBackToMainView";
NSString * const kPMNToggleTabBar                 = @"PMNToggleTabBar";

NSString * const kPMNPokemonAppeared   = @"PMNPokemonAppeared";
NSString * const kPMNBattleStart       = @"PMNBattleStart";
NSString * const kPMNBattleEnd         = @"PMNBattleEnd";
NSString * const kPMNToggleSixPokemons = @"kPMNToggleSixPokemons";

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

@implementation GlobalNotificationConstants

@end
