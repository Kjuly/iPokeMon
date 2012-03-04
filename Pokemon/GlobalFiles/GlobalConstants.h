//
//  GlobalConstants.h
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

// Debug Settings
#define kPupulateData 0

// Device System Version Checking
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

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

#define kTabBarHeight 115.0f
#define kTabBarWdith  215.0f

#define kTopBarHeight    55.0f  // 60 - 5(shadow)
#define kTopIDViewHeight 160.0f // 150 + 10

#define kTabArrowImageTag   2394859
#define kSelectedTabItemTag 2394860
#define kPoketchSelectedViewControllerTag 98456345
