//
//  Ability.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/18/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Ability : NSManagedObject

@property (nonatomic, strong) NSNumber * sid;
@property (nonatomic, strong) NSString * info;
@property (nonatomic, strong) NSString * name;

@end
