//
//  Move.h
//  iPokeMon
//
//  Created by Kaijie Yu on 3/15/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Move : NSManagedObject

@property (nonatomic, strong) NSNumber * additionalEffectChance;
@property (nonatomic, strong) NSNumber * baseDamage;
@property (nonatomic, strong) NSNumber * basePP;
@property (nonatomic, strong) NSNumber * category;
@property (nonatomic, strong) NSNumber * contestType;
@property (nonatomic, strong) NSNumber * effectCode;
@property (nonatomic, strong) NSNumber * flags;
@property (nonatomic, strong) NSNumber * hitChance;
@property (nonatomic, strong) NSString * info;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * priority;
@property (nonatomic, strong) NSNumber * sid;
@property (nonatomic, strong) NSNumber * target;
@property (nonatomic, strong) NSNumber * type;

@end
