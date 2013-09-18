//
//  ResourceManager.m
//  iPokeMon
//
//  Created by Kjuly on 1/24/13.
//  Copyright (c) 2013 Kjuly. All rights reserved.
//

#import "ResourceManager.h"

@implementation ResourceManager

@synthesize defaultBundle = defaultBundle_;
@synthesize bundle        = bundle_;


// Singleton
static ResourceManager * manager_;
+ (ResourceManager *)sharedInstance
{
  if (manager_ != nil)
    return manager_;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager_ = [[ResourceManager alloc] init];
  });
  return manager_;
}

// Return default resource bundle
- (NSBundle *)defaultBundle
{
  if (! defaultBundle_) {
    NSString * bundlePath = [[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"bundle"];
    if (! bundlePath) return [NSBundle mainBundle];
    defaultBundle_ = [NSBundle bundleWithPath:bundlePath];
  }
  return defaultBundle_;
}

// Return resource bundle
- (NSBundle *)bundle
{
  if (! bundle_) {
    NSString * pathToResourceBundle =
      [[NSUserDefaults standardUserDefaults] valueForKey:kUDKeyResourceBundlePath];
    if (! pathToResourceBundle) return nil;
    bundle_ = [[NSBundle alloc] initWithPath:pathToResourceBundle];
    //[bundle_ load];
  }
  return bundle_;
}

@end
