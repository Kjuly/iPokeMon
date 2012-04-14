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
  NSInteger overViewLoadingCounter_;
  NSInteger overBarLoadingCounter_;
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
    overViewLoadingCounter_ = 0;
    overBarLoadingCounter_  = 0;
  }
  return self;
}

#pragma mark - Public Methods

#pragma mark - Loading over View

// Show loading over view
- (void)showOverView {
  if (++overViewLoadingCounter_ == 1)
    [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
  NSLog(@"LOADING OVER VIEW SHOW: %d", overViewLoadingCounter_);
}

// Hide loading over view
- (void)hideOverView {
  --overViewLoadingCounter_;
  if (overViewLoadingCounter_ < 0)
    overViewLoadingCounter_ = 0;
  if (overViewLoadingCounter_ == 0)
    [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
  NSLog(@"LOADING OVER VIEW HIDE: %d", overViewLoadingCounter_);
}

// Clean all loading over view
- (void)cleanOverView {
  if (overViewLoadingCounter_ > 0) {
    [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
    overViewLoadingCounter_ = 0;
  }
}

#pragma mark - Loading over Bar

// Show loading over bar
- (void)showOverBar {
  if (++overBarLoadingCounter_ == 1)
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  NSLog(@"LOADING OVER BAR SHOW: %d", overBarLoadingCounter_);
}

// Hide loading over bar
- (void)hideOverBar {
  --overBarLoadingCounter_;
  if (overBarLoadingCounter_ < 0)
    overBarLoadingCounter_ = 0;
  if (overBarLoadingCounter_ == 0)
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  NSLog(@"LOADING OVER BAR HIDE: %d", overBarLoadingCounter_);
}

// Clean all loading over bar
- (void)cleanOverBar {
  if (overBarLoadingCounter_ > 0) {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    overBarLoadingCounter_ = 0;
  }
}

@end
