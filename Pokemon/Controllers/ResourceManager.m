//
//  ResourceManager.m
//  iPokeMon
//
//  Created by Kjuly on 1/24/13.
//  Copyright (c) 2013 Kjuly. All rights reserved.
//

#import "ResourceManager.h"

@implementation ResourceManager

// Singleton
static ResourceManager * manager_;
+ (ResourceManager *)sharedInstance {
  if (manager_ != nil)
    return manager_;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager_ = [[ResourceManager alloc] init];
  });
  return manager_;
}

@end
