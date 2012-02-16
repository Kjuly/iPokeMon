//
//  TrainerModel.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/15/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TrainerModel : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * pokedex;
@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSNumber * badges;
@property (nonatomic, retain) NSDate * adventure_started;


+ (void)initializeData;
+ (NSArray *)trainerData;
+ (void)setTrainerWith:(NSInteger)id Name:(NSString *)name;

@end
