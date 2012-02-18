//
//  BagMail.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/18/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TrainerBagMail;

@interface BagMail : NSManagedObject

@property (nonatomic, retain) NSNumber * effectCode;
@property (nonatomic, retain) id icon;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *ownedGroup;
@end

@interface BagMail (CoreDataGeneratedAccessors)

- (void)addOwnedGroupObject:(TrainerBagMail *)value;
- (void)removeOwnedGroupObject:(TrainerBagMail *)value;
- (void)addOwnedGroup:(NSSet *)values;
- (void)removeOwnedGroup:(NSSet *)values;

@end
