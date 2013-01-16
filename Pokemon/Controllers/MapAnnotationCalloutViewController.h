//
//  MapAnnotationCalloutViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 5/22/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapAnnotationCalloutViewController : UIViewController

- (void)loadViewAnimated:(BOOL)animated;
- (void)unloadViewAnimated:(BOOL)animated;
- (void)switchViewAnimated:(BOOL)animated;

- (void)configureWithTitle:(NSString *)title
               description:(NSString *)description;

@end
