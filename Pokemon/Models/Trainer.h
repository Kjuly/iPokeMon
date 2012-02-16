//
//  Trainer.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/16/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Trainer : NSManagedObject

@property (nonatomic, retain) NSDate * adventureStarted;
@property (nonatomic, retain) NSNumber * badges;
@property (nonatomic, retain) NSNumber * trainerID;
@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSString * name;

@end
