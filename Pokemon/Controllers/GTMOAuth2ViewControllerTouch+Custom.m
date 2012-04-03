//
//  GTMOAuth2ViewControllerTouch+Custom.m
//  Pokemon
//
//  Created by Kaijie Yu on 4/3/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GTMOAuth2ViewControllerTouch+Custom.h"

#import "CustomNavigationBar.h"


@implementation GTMOAuth2ViewControllerTouch (Custom)

// Overwrite method:|popView|
- (void)popView {
  if (self.navigationController.topViewController == self) {
    if (!self.view.isHidden) {
      // Set the flag to our viewWillDisappear method so it knows
      // this is a disappearance initiated by the sign-in object,
      // not the user cancelling via the navigation controller
      didDismissSelf_ = YES;
      
      [(CustomNavigationBar *)self.navigationController.navigationBar backToRoot:nil];
      self.view.hidden = YES;
    }
  }
}

@end
