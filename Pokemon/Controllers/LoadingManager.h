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

// Loading over view
- (void)showOverView;
- (void)hideOverView;
- (void)cleanOverView;

// Loading over bar (status bar)
- (void)showOverBar;
- (void)hideOverBar;
- (void)cleanOverBar;

@end
