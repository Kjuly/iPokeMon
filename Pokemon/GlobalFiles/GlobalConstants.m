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

#pragma mark - Image & Icon name
// PMIN: PokeMon Image Name
NSString * const kPMINLaunchViewBackground  = @"MainViewBackgroundBlackWithFog.png";
NSString * const kPMINBackgroundBlack       = @"MainViewBackgroundBlack.png";
NSString * const kPMINBackgroundEmpty       = @"EmptyTableViewBackground.png";
// center menu
NSString * const kPMINMainMenuBackground            = @"MainViewCenterCircle.png";
NSString * const kPMINMainViewCenterCircleBackgound = @"MainViewCenterMainButtonTouchDownCircleViewBackground.png";
NSString * const kPMINMainViewCenterCircle          = @"MainViewCenterMainButtonTouchDownCircleViewForeground.png";
NSString * const kPMINMainMenuButtonBackground      = @"MainViewCenterMenuButtonBackground.png";
NSString * const kPMINMainMenuUtilityButton         = @"MainViewCenterMenuButton%d.png"; // %d: 1 - 6
// center main button
NSString * const kPMINMainButtonBackgoundNormal  = @"MainViewCenterButtonBackground.png";
NSString * const kPMINMainButtonBackgoundEnable  = @"MainViewCenterButtonBackgroundEnable.png";
NSString * const kPMINMainButtonBackgoundDisable = @"MainViewCenterButtonBackgroundDisable.png";
NSString * const kPMINMainButtonNormal           = @"MainViewCenterButtonImageNormal.png";
NSString * const kPMINMainButtonWarning          = @"MainViewCenterButtonImageWarning.png";
NSString * const kPMINMainButtonConfirm          = @"MainViewCenterButtonImageConfirm.png";
NSString * const kPMINMainButtonConfirmOpposite  = @"MainViewCenterButtonImageConfirmOpposite.png";
NSString * const kPMINMainButtonInfo             = @"MainViewCenterButtonImageInfo.png";
NSString * const kPMINMainButtonInfoOpposite     = @"MainViewCenterButtonImageInfoOpposite.png";
NSString * const kPMINMainButtonUnknow           = @"MainViewCenterButtonImageUnknow.png";
NSString * const kPMINMainButtonUnknowOpposite   = @"MainViewCenterButtonImageUnknowOpposite.png";
NSString * const kPMINMainButtonCancel           = @"MainViewCenterButtonImageCancel.png";
NSString * const kPMINMainButtonCancelOpposite   = @"MainViewCenterButtonImageCancelOpposite.png";
NSString * const kPMINMainButtonHalfCancel       = @"MainViewCenterButtonImageHalfCancel.png";
// map button
NSString * const kPMINMapButtonBackgound    = @"MainViewMapButtonBackground.png";
NSString * const kPMINMapButtonNormal       = @"MainViewMapButtonImageNormal.png";
NSString * const kPMINMapButtonDisabled     = @"MainViewMapButtonImageLBSDisabled.png";
NSString * const kPMINMapButtonHalfCancel   = @"MainViewMapButtonImageHalfCancel.png";
// other buttons
NSString * const kPMINRectButtonConfirm = @"RectButtonConfirm.png";
NSString * const kPMINRectButtonUndo    = @"RectButtonUndo.png";
// TAB BAR
NSString * const kPMINTabBarBackground          = @"TabBarBackground.png";
NSString * const kPMINTabBarArrow               = @"TabBarArrow.png";
NSString * const kPMINTabBarItemPMDetailInfo    = @"TabBarItemPMDetailInfo.png";
NSString * const kPMINTabBarItemPMDetailArea    = @"TabBarItemPMDetailArea.png";
NSString * const kPMINTabBarItemPMDetailSize    = @"TabBarItemPMDetailSize.png";
NSString * const kPMINTabBarItem6PMsDetailMemo  = @"TabBarItemPMDetailMemo.png";
NSString * const kPMINTabBarItem6PMsDetailSkill = @"TabBarItemPMDetailSkill.png";
NSString * const kPMINTabBarItem6PMsDetailMove  = @"TabBarItemPMDetailMove.png";
// TABLE VIEW
// NAV BAR
NSString * const kPMINNavBarBackground       = @"NavigationBarBackground.png";
NSString * const kPMINNavBarBackToRootButton = @"CustomNavigationBar_backButtonToRoot.png";
NSString * const kPMINNavBarBackButton       = @"CustomNavigationBar_backButton.png";
// table view cell
NSString * const kPMINTableViewCellPokedex         = @"PokedexTableViewCellBackground.png";
NSString * const kPMINTableViewCellPokedexSelected = @"PokedexTableViewCellSelectedBackground.png";
NSString * const kPMINTableViewCellSetting         = @"SettingTableViewCellBackground.png";
NSString * const kPMINTableViewCellSettingSelected = @"SettingTableViewCellSelectedBackground.png";
NSString * const kPMINTableViewCellBag             = @"BagTableViewCellBackground.png";
NSString * const kPMINTableViewCellBagSelected     = @"BagTableViewCellSelectedBackground.png";
NSString * const kPMINTableViewCellBagItem         = @"BagItemTableViewCellBackground.png";
NSString * const kPMINTableViewCellBagItemSelected = @"BagItemTableViewCellSelectedBackground.png";
NSString * const kPMINTableViewCell                = @"BagItemTableViewCellSelectedBackground.png";
NSString * const kPMINTableViewCellBagMedicine     = @"BagMedicineTableViewCellBackground.png";
// table view header
NSString * const kPMINTableViewHeaderSetting       = @"SettingTableViewSectionHeaderBackground.png";
// table view other elements
NSString * const kPMINTableViewPokedexDefaultImage = @"PokedexDefaultImage.png";
NSString * const kPMINFeedbackTextFieldBackground  = @"FeedbackTextFieldBackground.png";
// table view detail view elements
NSString * const kPMINPMDetailImageBackgound        = @"PokemonDetailImageBackground.png";
NSString * const kPMINPMDetailDescriptionBackground = @"PokemonDetailDescriptionBackground.png";
NSString * const kPMINPMHPBarBackground             = @"PokemonHPBarBackground.png";
NSString * const kPMINPMHPBar                       = @"PokemonHPBar.png";
NSString * const kPMINPMExpBarBackground            = @"PokemonExpBarBackground.png";
NSString * const kPMINPMExpBar                      = @"PokemonExpBar.png";
// GAME BATTLE
NSString * const kPMINBattleSceneBackground           = @"GameBattleSceneBackground_%.2d.png"; // %.2d: 01 - 09
NSString * const kPMINBattleScenePMPoint              = @"GameBattleScenePMPoint.png";
NSString * const kPMINBattleMenuMessageViewBackground = @"GameMessageViewBackground.png";
NSString * const kPMINBattleElementPokeball = @"GamePokeball.png";
// ICONs
// Pokemon related icons
NSString * const kPMINIconPMGender         = @"IconPokemonGender%d.png"; // %d: 0(F) - 1(M)
// bag table view related icons
NSString * const kPMINIconBagTableViewCell = @"BagTableViewCellIcon_%d.png"; // %d: 1 - 8
NSString * const kPMINIconBagItemUse       = @"IconBagItemUse.png";
NSString * const kPMINIconBagItemGive      = @"IconBagItemGive.png";
NSString * const kPMINIconBagItemInfo      = @"IconBagItemInfo.png";
NSString * const kPMINIconBagItemToss      = @"IconBagItemToss.png";
NSString * const kPMINIconBagItemCancel    = @"IconBagItemCancel.png";
// trainer card related icons
NSString * const kPMINTrainerAvatarDefault  = @"UserAvatar.png";
NSString * const kPMINIconBadgeGold         = @"IconBadgeGold.png";
NSString * const kPMINIconBadgeSilver       = @"IconBadgeSilver.png";
NSString * const kPMINIconBadgeBronze       = @"IconBadgeBronze.png";
NSString * const kPMINIconTrainerCardModify = @"IconSettingModify.png";
// social media
NSString * const kPMINIconSocialFacebook = @"SocialIconFacebook.png";
NSString * const kPMINIconSocialGoogle   = @"SocialIconGoogle.png";
NSString * const kPMINIconSocialTwitter  = @"SocialIconTwitter.png";
// others
NSString * const kPMINIconRefresh = @"IconRefresh.png";
/////


@implementation GlobalConstants

@end
