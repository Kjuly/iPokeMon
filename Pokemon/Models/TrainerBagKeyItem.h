//
//  TrainerBagKeyItem.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/18/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BagKeyItem, Trainer;

@interface TrainerBagKeyItem : NSManagedObject

@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) BagKeyItem *data;
@property (nonatomic, retain) Trainer *owner;

@end
