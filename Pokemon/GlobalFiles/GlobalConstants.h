//
//  GlobalConstants.h
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

// Device System Version Checking
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// View Basic
#define kViewHeight 460.f
#define kViewWidth  320.f

// Main view settings
#define kCenterMainButtonSize 64.0f
#define kCenterMainButtonTouchDownCircleViewSize 230.0f
#define kCenterMenuSize       305.0f
#define kCenterMenuButtonSize 64.0f

#define kMapButtonSize 64.0f

#define kMapViewHeight      200.0f
#define kUtilityBarHeight  40.0f

#define kTagMainViewCenterMainButton 1001
#define kTagMainViewMapButton        1002

// Data Modify Flag
typedef enum {
  kDataModifyTrainer                 = 1 << 0,  // Trainer
  kDataModifyTrainerName             = 1 << 1,
  kDataModifyTrainerMoney            = 1 << 2,
  kDataModifyTrainerBadges           = 1 << 4,
  kDataModifyTrainerPokedex          = 1 << 3,
  kDataModifyTrainerSixPokemons      = 1 << 4,
  kDataModifyTrainerBag              = 1 << 5,
  kDataModifyTamedPokemon            = 1 << 8,  // Tamed Pokemon
  kDataModifyTamedPokemonBasic       = 1 << 9,  // For all except |box|, |memo|
  kDataModifyTamedPokemonExtra       = 1 << 10, // For |box|, |memo|
  kDataModifyTamedPokemonStatus      = 1 << 11,
  kDataModifyTamedPokemonhappiness   = 1 << 12,
  kDataModifyTamedPokemonLevel       = 1 << 13,
  kDataModifyTamedPokemonFourMoves   = 1 << 14,
  kDataModifyTamedPokemonMaxStats    = 1 << 15,
  kDataModifyTamedPokemonCurrHP      = 1 << 16,
  kDataModifyTamedPokemonCurrEXP     = 1 << 17,
  kDataModifyTamedPokemonToNextLevel = 1 << 18,
  kDataModifyTamedPokemonBox         = 1 << 19,
  kDataModifyTamedPokemonMemo        = 1 << 20
}DataModifyFlag;

// For |centerMainButton_| status
typedef enum {
  kCenterMainButtonStatusNormal          = 0,
  kCenterMainButtonStatusAtBottom        = 1,
  kCenterMainButtonStatusPokemonAppeared = 2,
}CenterMainButtonStatus;

typedef enum {
  kCenterMainButtonMessageSignalNone            = 0,
  kCenterMainButtonMessageSignalPokemonAppeared = 1
}CenterMainButtonMessageSignal;

// For |centerMainButton_| & |mapButton_|'s layouts animation
typedef enum {
  kMainViewButtonLayoutNormal                     = 0,
  kMainViewButtonLayoutCenterMainButtonToBottom   = 1 << 0,
  kMainViewButtonLayoutCenterMainButtonToOffcreen = 1 << 1,
  kMainViewButtonLayoutMapButtonToTop             = 1 << 2,
  kMainViewButtonLayoutMapButtonToOffcreen        = 1 << 3
}MainViewButtonLayout;

enum {
  kTagUtilityBallButtonShowPokedex = 2001,
  kTagUtilityBallButtonShowPokemon,
  kTagUtilityBallButtonShowBag,
  kTagUtilityBallButtonShowTrainerCard,
  kTagUtilityBallButtonHotkey,
  kTagUtilityBallButtonSetGame,
  kTagUtilityBallButtonClose
};

// Bag data query target type
typedef enum {
  kBagQueryTargetTypeItem           = 1 << 0,
  kBagQueryTargetTypeMedicine       = 1 << 1, // If it is 1, check last three
  kBagQueryTargetTypePokeball       = 1 << 2,
  kBagQueryTargetTypeTMHM           = 1 << 3,
  kBagQueryTargetTypeBerry          = 1 << 4,
  kBagQueryTargetTypeMail           = 1 << 5,
  kBagQueryTargetTypeBattleItem     = 1 << 6,
  kBagQueryTargetTypeKeyItem        = 1 << 7,
  kBagQueryTargetTypeMedicineStatus = 1 << 8,
  kBagQueryTargetTypeMedicineHP     = 1 << 9,
  kBagQueryTargetTypeMedicinePP     = 1 << 10
}BagQueryTargetType;

// Pokemon Status
typedef enum {
  kPokemonStatusNormal    = 0,      // Normal
  kPokemonStatusBurn      = 1 << 0, // Burn
  kPokemonStatusConfused  = 1 << 1, // Confused
  kPokemonStatusFlinch    = 1 << 2, // Flinch
  kPokemonStatusFreeze    = 1 << 3, // Freeze
  kPokemonStatusParalyze  = 1 << 4, // Paralyze
  kPokemonStatusPoison    = 1 << 5, // Poison
  kPokemonStatusSleep     = 1 << 6, // Sleep
  kPokemonStatusFaint     = 1 << 7  // Faint
}PokemonStatus;

// Move Real Target
typedef enum {
  kMoveRealTargetNone   = 0,      // None
  kMoveRealTargetEnemy  = 1 << 0, // Enemy
  kMoveRealTargetPlayer = 1 << 1, // Player
}MoveRealTarget;

#define kTabBarHeight 115.0f
#define kTabBarWdith  215.0f

#define kTopBarHeight    55.0f  // 60 - 5(shadow)
#define kTopIDViewHeight 160.0f // 150 + 10

// Table View
#define kCellHeightOfTrainerBadgesTableView 52.5f
#define kCellHeightOfPokedexTableView       70.f
#define kCellHeightOfSixPokemonsTableView   70.f
#define kCellHeightOfBagTableView           52.f
#define kCellHeightOfBagMedicineTableView   128.f //(kViewHeight - 60.f) / 3.f
#define kCellHeightOfBagItemTableView       64.f
#define kCellHeightOfSettingTableView       44.f

#define kSectionHeaderHeightOfSettingTableView 32.f

// Others
#define kTabArrowImageTag   2394859
#define kSelectedTabItemTag 2394860
#define kPoketchSelectedViewControllerTag 98456345
