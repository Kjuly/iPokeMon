//
//  GlobalConstants.h
//  iPokeMon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "KYConstants.h"

// Device System Version Checking
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#pragma mark - ERROR

typedef enum {
  kPMErrorUnknow               = 1 << 0,
  kPMErrorNetworkNotAvailable  = 1 << 1, // network NOT available
  kPMErrorAuthenticationFailed = 1 << 2  // authentication failed
}PMError;

#pragma mark - User Defaults

///UserDefautls
// Settings.bundle
extern NSString * const kUDKeyGeneralLocationServices; // enable location tracking (bool)
extern NSString * const kUDKeyGeneralBandwidthUsage;   // bandwidth useage (number:0,1,2)
// Game settings
extern NSString * const kUDKeyGeneralGameSettings;
extern NSString * const kUDKeyGameSettingsMasterTitle;
extern NSString * const kUDKeyGameSettingsMaster;      // master volume (slider [0,100])
extern NSString * const kUDKeyGameSettingsMusicTitle;
extern NSString * const kUDKeyGameSettingsMusic;       // music volume (slider [0,100])
extern NSString * const kUDKeyGameSettingsSoundsTitle;
extern NSString * const kUDKeyGameSettingsSounds;      // sounds volume (slider [0,100])
extern NSString * const kUDKeyGameSettingsAnimations;  // enable animations (switch)
// About
extern NSString * const kUDKeyAboutVersion;            // version for App

///Extra UserDefaults
extern NSString * const kUDKeyLastUsedServiceProvider; // last Service Provider used
extern NSString * const kUDKeyResourceBundlePath;      // Resource bundle path
///END UserDefaults
//////

#pragma mark - Notifications

extern NSString * const kPMNPermitUserAction; // permit user action
extern NSString * const kPMNBanUserAction;    // ban user action
extern NSString * const kPMNResetDeviceUID;   // reset device's UID

extern NSString * const kPMNError;        // notifi for ERROR
extern NSString * const kPMNUpdateRegion; // notifi for updating region (code, ...)
extern NSString * const kPMNUserLogout;   // notifi for reset data when user logout

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

extern NSString * const kPMNUpdateStoreItemQuantity;

extern NSString * const kPMNEnableTracking;  // enable  tracking
extern NSString * const kPMNDisableTracking; // disable tracking
extern NSString * const kPMNChangeCenterMainButtonStatus;
//extern NSString * const kPMNBackToMainView;

extern NSString * const kPMNGenerateNewWildPokemon;
extern NSString * const kPMNPokemonAppeared;
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

#pragma mark - Image & Icon name

// PMIN: PokeMon Image Name
#define kPMINLaunchViewBackground  @"MainViewBackgroundBlackWithFog.png"
#define kPMINBackgroundBlack       @"MainViewBackgroundBlack.png"
#define kPMINBackgroundEmpty       @"EmptyTableViewBackground.png"
// center menu
#define kPMINMainMenuBackground            @"MainViewCenterCircle.png"
#define kPMINMainViewCenterCircleBackgound @"MainViewCenterMainButtonTouchDownCircleViewBackground.png"
#define kPMINMainViewCenterCircle          @"MainViewCenterMainButtonTouchDownCircleViewForeground.png"
#define kPMINMainMenuButtonBackground      @"MainViewCenterMenuButtonBackground.png"
#define kPMINMainMenuUtilityButton         @"MainViewCenterMenuButton%d.png" // %d: 1 - 6
// center main button
#define kPMINMainButtonBackgoundNormal  @"MainViewCenterButtonBackground.png"
#define kPMINMainButtonBackgoundEnable  @"MainViewCenterButtonBackgroundEnable.png"
#define kPMINMainButtonBackgoundDisable @"MainViewCenterButtonBackgroundDisable.png"
#define kPMINMainButtonNormal           @"MainViewCenterButtonImageNormal.png"
#define kPMINMainButtonWarning          @"MainViewCenterButtonImageWarning.png"
#define kPMINMainButtonConfirm          @"MainViewCenterButtonImageConfirm.png"
#define kPMINMainButtonConfirmOpposite  @"MainViewCenterButtonImageConfirmOpposite.png"
#define kPMINMainButtonInfo             @"MainViewCenterButtonImageInfo.png"
#define kPMINMainButtonInfoOpposite     @"MainViewCenterButtonImageInfoOpposite.png"
#define kPMINMainButtonUnknow           @"MainViewCenterButtonImageUnknow.png"
#define kPMINMainButtonUnknowOpposite   @"MainViewCenterButtonImageUnknowOpposite.png"
#define kPMINMainButtonCancel           @"MainViewCenterButtonImageCancel.png"
#define kPMINMainButtonCancelOpposite   @"MainViewCenterButtonImageCancelOpposite.png"
#define kPMINMainButtonHalfCancel       @"MainViewCenterButtonImageHalfCancel.png"
// map view button
#define kPMINMapButtonBackgound    @"MainViewMapButtonBackground.png"
#define kPMINMapButtonNormal       @"MainViewMapButtonImageNormal.png"
#define kPMINMapButtonDisabled     @"MainViewMapButtonImageLBSDisabled.png"
#define kPMINMapButtonHalfCancel   @"MainViewMapButtonImageHalfCancel.png"
#ifdef KY_INVITATION_ONLY
#define kPMINMapButtonLocked       @"MainViewMapButtonImageLocked.png"
#endif
// other buttons
#define kPMINRectButtonConfirm @"RectButtonConfirm.png"
#define kPMINRectButtonUndo    @"RectButtonUndo.png"
// TAB BAR
#define kPMINTabBarBackground          @"TabBarBackground.png"
#define kPMINTabBarArrow               @"TabBarArrow.png"
#define kPMINTabBarItemPMDetailInfo    @"TabBarItemPMDetailInfo.png"
#define kPMINTabBarItemPMDetailArea    @"TabBarItemPMDetailArea.png"
#define kPMINTabBarItemPMDetailSize    @"TabBarItemPMDetailSize.png"
#define kPMINTabBarItem6PMsDetailMemo  @"TabBarItemPMDetailMemo.png"
#define kPMINTabBarItem6PMsDetailSkill @"TabBarItemPMDetailSkill.png"
#define kPMINTabBarItem6PMsDetailMove  @"TabBarItemPMDetailMove.png"
// TABLE VIEW
// NAV BAR
#define kPMINNavBarBackground       @"NavigationBarBackground.png"
#define kPMINNavBarBackToRootButton @"CustomNavigationBar_backButtonToRoot.png"
#define kPMINNavBarBackButton       @"CustomNavigationBar_backButton.png"
// table view cell
#define kPMINTableViewCellPokedex         @"PokedexTableViewCellBackground.png"
#define kPMINTableViewCellPokedexSelected @"PokedexTableViewCellSelectedBackground.png"
#define kPMINTableViewCellSetting         @"SettingTableViewCellBackground.png"
#define kPMINTableViewCellSettingSelected @"SettingTableViewCellSelectedBackground.png"
#define kPMINTableViewCellSettingCenterTitleStyle @"SettingTableViewCellCenterTitleStyleBackground.png"
#define kPMINTableViewCellBag             @"BagTableViewCellBackground.png"
#define kPMINTableViewCellBagSelected     @"BagTableViewCellSelectedBackground.png"
#define kPMINTableViewCellBagItem         @"BagItemTableViewCellBackground.png"
#define kPMINTableViewCellBagItemSelected @"BagItemTableViewCellSelectedBackground.png"
#define kPMINTableViewCell                @"BagItemTableViewCellSelectedBackground.png"
#define kPMINTableViewCellBagMedicine     @"BagMedicineTableViewCellBackground.png"
// table veew cell related - Store
#define kPMINStoreItemQuantityButtonBackground @"StoreItemQuantityButtonBackground.png"
#define kPMINStoreItemQuantityIcreaseButton    @"StoreItemQuantityIcreaseButton.png"
#define kPMINStoreItemQuantityDcreaseButton    @"StoreItemQuantityDcreaseButton.png"
// table view header
#define kPMINTableViewHeaderSetting       @"SettingTableViewSectionHeaderBackground.png"
// table view other elements
#define kPMINTableViewPokedexDefaultImage @"PokedexDefaultImage.png"
#define kPMINFeedbackTextFieldBackground  @"FeedbackTextFieldBackground.png"
// table view detail view elements
#define kPMINPMDetailImageBackgound        @"PokemonDetailImageBackground.png"
#define kPMINPMDetailDescriptionBackground @"PokemonDetailDescriptionBackground.png"
#define kPMINPMHPBarBackground             @"PokemonHPBarBackground.png"
#define kPMINPMHPBar                       @"PokemonHPBar.png"
#define kPMINPMExpBarBackground            @"PokemonExpBarBackground.png"
#define kPMINPMExpBar                      @"PokemonExpBar.png"
// GAME BATTLE
#define kPMINBattleSceneBackground @"GameBattleSceneBackground_%.2d.png" // %.2d: 01 - 09
#define kPMINBattleScenePMPoint    @"GameBattleScenePMPoint.png"
#define kPMINBattleElementPokeball @"GamePokeball.png"
// ICONs
// Map View
#define kPMINIconLocateMe  @"IconLocateMe.png"
#define kPMINIconShowWorld @"IconShowWorld.png"
// Pokemon related icons
#define kPMINIconPMGender         @"IconPokemonGender%d.png" // %d: 0(F) - 1(M)
#define kPMINIconMoveBackground   @"IconMoveBackground.png"
#define kPMINGameBagIconBackground @"GameBagIconBackground.png"
#define kPMINGameBagIcon           @"GameBagIcon_%d.png" // %d: 1 - 6
// bag table view related icons
#define kPMINIconBagTableViewCell     @"BagTableViewCellIcon_%d.png" // %d: 1 - 8
#define kPMINIconCurrencyExchange     @"CurrencyExchangeIcon.png"
#define kPMINIconCurrencyExchangeIcon @"CurrencyExchangeTier%dIcon.png" // %d: 1- 3
#define kPMINIconBagItemUse           @"IconBagItemUse.png"
#define kPMINIconBagItemGive          @"IconBagItemGive.png"
#define kPMINIconBagItemInfo          @"IconBagItemInfo.png"
#define kPMINIconBagItemToss          @"IconBagItemToss.png"
#define kPMINIconBagItemCancel        @"IconBagItemCancel.png"
// trainer card related icons
#define kPMINTrainerAvatarDefault  @"UserAvatar.png"
#define kPMINIconBadgeGold         @"IconBadgeGold.png"
#define kPMINIconBadgeSilver       @"IconBadgeSilver.png"
#define kPMINIconBadgeBronze       @"IconBadgeBronze.png"
#define kPMINIconTrainerCardModify @"IconSettingModify.png"
// social media
#define kPMINIconSocialFacebook @"SocialIconFacebook.png"
#define kPMINIconSocialGoogle   @"SocialIconGoogle.png"
#define kPMINIconSocialTwitter  @"SocialIconTwitter.png"
// others
#define kPMINIconRefresh @"IconRefresh.png"
/////

#pragma mark -

// View Basic
// Not include status bar height
//#define kViewHeight CGRectGetHeight([UIScreen mainScreen].applicationFrame)
//#define kViewWidth  CGRectGetWidth([UIScreen mainScreen].applicationFrame)
// Include status bar height
#define kViewHeight CGRectGetHeight([UIScreen mainScreen].bounds)
#define kViewWidth  CGRectGetWidth([UIScreen mainScreen].bounds)

// Main view settings
#define kCenterMainButtonSize kKYButtonInNormalSize
#define kCenterMainButtonTouchDownCircleViewSize 230.0f
#define kCenterMenuSize       305.0f
#define kCenterMenuButtonSize kKYButtonInNormalSize

#define kMapButtonSize kKYButtonInNormalSize
#define kRectButtonHeight 44.f
#define kRectButtonWidth  160.f
#define kRectButtonBottomLineHeight 10.f
#define kFeedbackTextFieldBackgroundHeight 210.f

#define kMapViewHeight                    200.0f
#define kMapAnnotationSize                44.f
#define kMapAnnotationImageSize           32.f
#define kMapAnnotationCalloutViewHeight   130.f
#define kMapAnnotationCalloutViewWidth    300.f
//#define kMapAnnotationCalloutMainViewSize 280.f
#define kMapAnnotationCalloutSubViewSize  100.f
#define kUtilityBarHeight                 40.0f

#define kTagMainViewCenterMainButton 1001
#define kTagMainViewMapButton        1002


// Device Blocking Type
typedef enum {
  kPMDeviceBlockingTypeNone = 0,
  kPMDeviceBlockingTypeOfInvitationOnly,
  kPMDeviceBlockingTypeOfUIDNotMatched,
}PMDeviceBlockingType;

// Data Modify Flag
typedef enum {
  kDataModifyTrainer                 = 1 << 0,  // Trainer
  kDataModifyTrainerName             = 1 << 1,
  kDataModifyTrainerMoney            = 1 << 2,
  kDataModifyTrainerBadges           = 1 << 3,
  kDataModifyTrainerPokedex          = 1 << 4,
  kDataModifyTrainerSixPokemons      = 1 << 5,
  kDataModifyTrainerBag              = 1 << 6,
  kDataModifyTamedPokemon            = 1 << 8,  // Tamed Pokemon
  kDataModifyTamedPokemonNew         = 1 << 9,  // Flag for new Tamed Pokemon
  kDataModifyTamedPokemonBasic       = 1 << 10, // For all except |box|, |memo|
  kDataModifyTamedPokemonExtra       = 1 << 11, // For |box|, |memo|
  kDataModifyTamedPokemonStatus      = 1 << 12,
  kDataModifyTamedPokemonhappiness   = 1 << 13,
  kDataModifyTamedPokemonLevel       = 1 << 14,
  kDataModifyTamedPokemonFourMoves   = 1 << 15,
  kDataModifyTamedPokemonMaxStats    = 1 << 16,
  kDataModifyTamedPokemonCurrHP      = 1 << 17,
  kDataModifyTamedPokemonCurrEXP     = 1 << 18,
  kDataModifyTamedPokemonToNextLevel = 1 << 19,
  kDataModifyTamedPokemonBox         = 1 << 20,
  kDataModifyTamedPokemonMemo        = 1 << 21
}DataModifyFlag;

// color types
typedef enum {
  kColorTypeNone      = 0,
  kColorTypeBlack     = 1 << 0,
  kColorTypeWhite     = 1 << 1,
  kColorTypeOrange    = 1 << 2,
  kColorTypeGolden    = 1 << 3,
  kColorTypeBlue      = 1 << 4,
  kColorTypeRed       = 1 << 5,
  kColorTypeGreen     = 1 << 6,
  kColorTypeGray      = 1 << 7,
  kColorTypeDarkGray  = 1 << 8,
  kColorTypeLightGray = 1 << 9
}ColorType;

// For |centerMainButton_| status
typedef enum {
  kCenterMainButtonStatusNormal = 0,
  kCenterMainButtonStatusAtBottom,
  kCenterMainButtonStatusPokemonAppeared
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

// map's annotation type
typedef enum {
  kAnnotationTypeNone               = 0,
  kAnnotationTypeContinentAndOcean  = 1 << 0,  // continent & ocean
  kAnnotationTypeCountryAndSea      = 1 << 1,  // country & sea
  kAnnotationTypeAdministrativeArea = 1 << 2,  // administrative (province)
  kAnnotationTypeLocality           = 1 << 3,  // locality (city)
  kAnnotationTypeLake               = 1 << 4,  // lake
  kAnnotationTypeSubLocality        = 1 << 5,  // sub-locality (district)
  kAnnotationTypeHotPoint           = 1 << 6   // hot point: shop, etc.
}AnnotationType;

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

#define kTabBarHeight   88.f
#define kTabBarWdith    kViewWidth
#define kTabBarItemSize 44.f

#define kNavigationBarHeight            60.f
#define kNavigationBarBottomAlphaHegiht 5.f
#define kNavigationBarBackButtonHeight  60.f
#define kNavigationBarBackButtonWidth   40.f

#define kTopBarHeight    55.0f  // 60 - 5(shadow)
#define kTopIDViewHeight 160.0f // 150 + 10

#define kGameMenuBattleLogViewHeight       150.f // Game Menu: game battle log view height
#define kGameMenuPMStatusViewHeight        64.f  //       ...: Pokemon Status view height
#define kGameMenuPMStatusHPBarHeight       8.f   //       ...:            ...'s HP Bar height
#define kGameMenuPokeballSize              60.f  // Size of Pokeball (which is used for replacing & catching PM)
#define kGameBattleSceneBackgroundHeight   310.f // Height of battle scene background
#define kGameBattlePMSize                  96.f  // Size of Pokemon Image
#define kGameBattlePlayerPMPointHeight     35.f  // height of PM's Point
#define kGameBattlePlayerPMPointWidth      145.f // width of PM's Point
#define kGameBattlePlayerPMPointPosX       80.f  // Pokemons' Point
#define kGameBattlePlayerPMPointPosY       190.f 
#define kGameBattleEnemyPMPointPosX        240.f
#define kGameBattleEnemyPMPointPosY        320.f
#define kGameBattlePlayerPokemonPosOffsetX 410.f // Offscreen's position X
#define kGameBattlePlayerPokemonPosX       80.f
#define kGameBattlePlayerPokemonPosY       225.f // ccp(70.f, 230.f) = CGPoint(70,kViewHeight-230.f)
#define kGameBattleEnemyPokemonPosOffsetX  -90.f
#define kGameBattleEnemyPokemonPosX        240.f
#define kGameBattleEnemyPokemonPosY        350.f
#define kGameBattlePokemonFaintedOffsetY   50.f

// Table View
#define kCellHeightOfLoginTableView         44.f
#define kCellHeightOfTrainerBadgesTableView 52.5f
#define kCellHeightOfPokedexTableView       70.f
#define kCellHeightOfSixPokemonsTableView   70.f
#define kCellHeightOfBagTableView           52.f
#define kCellHeightOfBagMedicineTableView   128.f //(kViewHeight - 60.f) / 3.f
#define kCellHeightOfBagItemTableView       64.f
#define kCellHeightOfStoreItemTableView     64.f
#define kCellHeightOfCurrencyExchange       128.f
#define kCellHeightOfSettingTableView       44.f
#define kCellHeightOfSettingTableViewCenterTitleStyle 64.f // center title style: feedback, logout
#define kCellHeightOfGameBattleLogTableView 50.f
// Header
#define kSectionHeaderHeightOfSettingTableView 32.f
// Others
#define kStoreItemQuantityI_DcreaseButtonHeight 44.f
#define kStoreItemQuantityI_DcreaseButtonWidth  128.f

// Others
#define kTabArrowImageTag   2394859
#define kSelectedTabItemTag 2394860
#define kPoketchSelectedViewControllerTag 98456345

/*
 * LIBs
 */
// KYArcTab
#define kKYArcTabViewHeight kViewHeight
#define kKYArcTabViewWidth  kViewWidth

@interface Constants : KYConstants

@end
