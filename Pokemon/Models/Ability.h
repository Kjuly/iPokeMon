//
//  Ability.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/18/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Ability : NSManagedObject

@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * name;

@end
