//
//  Annotation.h
//  iPokeMon
//
//  Created by Kaijie Yu on 5/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Annotation : NSManagedObject

@property (nonatomic, retain) NSNumber * minZoomLevel;
@property (nonatomic, retain) NSNumber * maxZoomLevel;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;

@end
