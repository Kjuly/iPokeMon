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

@property (nonatomic, strong) NSNumber * minZoomLevel;
@property (nonatomic, strong) NSNumber * maxZoomLevel;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSNumber * longitude;
@property (nonatomic, strong) NSNumber * latitude;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * subtitle;

@end
