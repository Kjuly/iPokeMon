//
//  KYConstants.h
//  KYiOSFoundation
//
//  Created by Kaijie Yu on 6/24/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kKYBundleIdentifier [[NSBundle mainBundle] bundleIdentifier]
#define kKYAppBundleIdentifier \
  [[[[NSBundle mainBundle] bundleIdentifier] substringFromIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@"_"]
#define kKYBundleIdentifierForEmail \
  [[[[NSBundle mainBundle] bundleIdentifier] substringFromIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@"."]
#define kKYAppBundleName [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]
#define kKYAppBundleDisplayName [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define kKYAppBundleLocalizedName [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]

// KYResourceLocalizedString(,)
//   Localized string for resource
#define KYResourceLocalizedString(key, comment) \
  [ResourceManager sharedInstance].bundle ? \
  [[ResourceManager sharedInstance].bundle localizedStringForKey:(key) value:@"" table:@"KYLocalizable"] : \
  NSLocalizedString(key, comment)
// KYLocalizedStringFromTableInBundle(,,)
#define KYLocalizedStringFromTableInBundle(key, bundle, comment) \
  bundle ? [bundle localizedStringForKey:(key) value:@"" table:@"KYLocalizable"] : \
  NSLocalizedString(key, comment)
// KYLocalizedString(,)
#define KYLocalizedString(key, comment) \
  [[[NSBundle mainBundle] localizedStringForKey:(key) value:nil table:@"KYLocalizable"] isEqualToString:(key)] ? \
  [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil] : \
  [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:@"KYLocalizable"]

#pragma mark - Key of Settings.bundle - prefix: KYS

#define kKYSKeyiCloudService @"KYSKeyiCloudService"
#define kKYSKeyAboutApp      @"KYSKeyAboutApp"

#pragma mark - Key of UserDefaults - prefix: KYK

#define kKYKDeviceType @"KYKDeviceType"

#pragma mark - Key of Notification Name - prefix: KYN

// iCloud Service
#define kKYNRefreshAllViews           @"KYNRefreshAllViews"           // Refresh all views
#define kKYNRefetchAllDatabaseData    @"KYNRefetchAllDatabaseData"    // Refetch all data
#define kKYNiCloudServiceStateChanged @"KYNiCloudServiceStateChanged" // iCloud Service State Chenaged
// Settings Table View
#define kKYNSettingsValueChanged @"KYNSettingsValueChanged"


#pragma mark - Image - prefix: KYI
// Image
#define kKYIBackgroundWhite @"KYIBackgroundWhite.png"
// Icon
#define kKYIIconSettings  @"KYIIconSettings.png"
// Logo Icon
#define kKYILogoTwitter   @"KYILogoTwitter.png"
#define kKYILogoSinaWeibo @"KYILogoSinaWeibo.png"


#pragma mark -
#pragma mark - View  - prefix: KY
// Original UI Size
#define kKYKeyboardHeight 216.f

// App View Basic
#define kKYViewHeight    CGRectGetHeight([UIScreen mainScreen].applicationFrame)
#define kKYViewWidth     CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define kKYViewHalfWidth CGRectGetWidth([UIScreen mainScreen].applicationFrame) / 2.f

#define kKYLabelInMiniHeight   16.f
#define kKYLabelInSmallHeight  32.f
#define kKYLabelInNormalHeight 64.f

#define kKYContentMargin 10.f
#define kKYContentWidth  300.f

#define kKYContentMarginLevel_1 5.f
#define kKYContentMarginLevel_2 10.f
#define kKYContentMarginLevel_3 15.f
#define kKYContentMarginLevel_4 20.f
#define kKYContentMarginLevel_5 25.f
#define kKYContentMarginLevel_6 30.f

#define kKYContentIndentationLevel_1 10.f
#define kKYContentIndentationLevel_2 20.f
#define kKYContentIndentationLevel_3 30.f
#define kKYContentIndentationLevel_4 40.f
#define kKYContentIndentationLevel_5 50.f

#define kKYFontInMinSize        8.f
#define kKYFontInMiniSize       12.f
#define kKYFontInSmallSize      16.f
#define kKYFontInNormalSize     20.f
#define kKYFontInLargeSize      32.f
#define kKYFontInSuperLargeSize 42.f

// Status Bar
#define kKYStatusBarHeight 20.f
// Navigation Bar
#define kKYNavigationBarHeight               44.f
#define kKYNavigationBarBackButtonHeight     44.f
#define kKYNavigationBarBackButtonWidth      44.f
#define kKYNavigationBarBackButtonArrowScale .5f
#define kKYNavigationBarBackButtonArrowThick 3.f

// Button Size
#define kKYButtonInMiniSize          16.f
#define kKYButtonInSmallSize         32.f
#define kKYButtonInNormalSize        64.f
#define kKYButtonInNavigationBarSize 44.f // button size to fit navigation bar

// Root View

// Settings TableView
#define kKYSettingsTableViewCellHeight        44.f
#define kKYSettingsTableViewSectionViewHeight 40.f
// App Info
#define kKYAppInfoContentMargin 30.f


#pragma mark -
#pragma mark - enum

// Device Type
typedef enum {
  kKYDeviceUnknown = 0,
  kKYDeviceiPhone,
  kKYDeviceiPhone568h,
  kKYDeviceiPad
}KYDeviceType;

// Direction
typedef enum {
  kKYDirectionNone  = 0,
  kKYDirectionRight = 1 << 0,
  kKYDirectionLeft  = 1 << 1,
  kKYDirectionUp    = 1 << 2,
  kKYDirectionDown  = 1 << 3
}KYDirection;


@interface KYConstants : NSObject

@end
