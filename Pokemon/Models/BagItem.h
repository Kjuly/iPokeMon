//
//  BagItem.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/18/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TrainerBagItem;

@interface BagItem : NSManagedObject

@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id icon;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSNumber * effectCode;
@property (nonatomic, retain) NSSet *ownedGroup;
@end

@interface BagItem (CoreDataGeneratedAccessors)

- (void)addOwnedGroupObject:(TrainerBagItem *)value;
- (void)removeOwnedGroupObject:(TrainerBagItem *)value;
- (void)addOwnedGroup:(NSSet *)values;
- (void)removeOwnedGroup:(NSSet *)values;

@end
