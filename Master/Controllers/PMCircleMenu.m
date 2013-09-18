//
//  PMCircleMenu.m
//  iPokeMon
//
//  Created by Kjuly on 2/2/13.
//  Copyright (c) 2013 Kjuly. All rights reserved.
//

#import "PMCircleMenu.h"

@implementation PMCircleMenu

// Change |centerMainButton_|'s status in main view
- (void)changeCenterMainButtonStatusToMove:(CenterMainButtonStatus)centerMainButtonStatus
{
  // |centerMainButtonStatus : 1|, move |centerMainButton_| to view bottom
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [NSNumber numberWithInt:centerMainButtonStatus], @"centerMainButtonStatus", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNChangeCenterMainButtonStatus
                                                      object:self
                                                    userInfo:userInfo];
}

@end
