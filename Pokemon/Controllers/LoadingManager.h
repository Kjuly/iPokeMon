//
//  LoadingManager.h
//  Pokemon
//
//  Created by Kaijie Yu on 4/13/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBProgressHUD.h"

@interface LoadingManager : NSObject <MBProgressHUDDelegate>

+ (LoadingManager *)sharedInstance;

- (void)show;  // Show loading view
- (void)hide;  // Hide loading view
- (void)clean; // Clean all loading view

@end
