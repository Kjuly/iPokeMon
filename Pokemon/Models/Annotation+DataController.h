//
//  Annotation+DataController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 5/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "Annotation.h"

@interface Annotation (DataController)

+ (void)updateForCurrentRegion;
+ (NSArray *)annotationsAtZoomLevel:(NSInteger)zoomLevel;

@end
