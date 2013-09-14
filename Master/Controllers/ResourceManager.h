//
//  ResourceManager.h
//  iPokeMon
//
//  Created by Kjuly on 1/24/13.
//  Copyright (c) 2013 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBundleDirectoryOfImageSpriteIcon @"Resources/Images/SpriteIcon"
#define kBundleDirectoryOfImageSprite     @"Resources/Images/Sprite"
#define kBundleDirectoryOfImageSpriteBack @"Resources/Images/SpriteBack"
#define kBundleDirectoryOfPropertyList    @"Resources/PropertyLists"
#define kBundleDirectoryOfAnnotation      @"Resources/Annotations"
#define kBundleDirectoryOfSound           @"Resources/Sounds"

@interface ResourceManager : NSObject {
  NSBundle * defaultBundle_;
  NSBundle * bundle_;
}

@property (nonatomic, strong) NSBundle * defaultBundle;
@property (nonatomic, strong) NSBundle * bundle;

+ (ResourceManager *)sharedInstance;
- (NSBundle *)defaultBundle;
- (NSBundle *)bundle;

@end
