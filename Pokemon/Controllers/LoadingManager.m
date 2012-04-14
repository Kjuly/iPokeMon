//
//  LoadingManager.m
//  Pokemon
//
//  Created by Kaijie Yu on 4/13/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "LoadingManager.h"


@interface LoadingManager () {
 @private
  NSInteger counter_;
}
@end


@implementation LoadingManager

// Singleton
static LoadingManager * loadingManager_ = nil;
+ (LoadingManager *)sharedInstance {
  if (loadingManager_ != nil)
    return loadingManager_;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    loadingManager_ = [[LoadingManager alloc] init];
  });
  return loadingManager_;
}

- (void)dealloc
{
  [super dealloc];
}

- (id)init {
  if (self = [super init]) {
    counter_ = 0;
  }
  return self;
}

#pragma mark - Public Methods

// Show loading view
- (void)show {
  if (++counter_ == 1)
    [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
  NSLog(@"LOADING SHOW: %d", counter_);
}

// Hide loading view
- (void)hide {
  --counter_;
  if (counter_ < 0)
    counter_ = 0;
  if (counter_ == 0)
    [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
  NSLog(@"LOADING HIDE: %d", counter_);
}

// Clean all loading view
- (void)clean {
  if (counter_ > 0) {
    [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
    counter_ = 0;
  }
}

@end
