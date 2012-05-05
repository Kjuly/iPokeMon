//
//  Region.h
//  iPokemon
//
//  Created by Kaijie Yu on 5/5/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Region : NSManagedObject

@property (nonatomic, retain) NSString * administrativeArea;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * countryCode;
@property (nonatomic, retain) NSString * locality;
@property (nonatomic, retain) NSString * subLocality;
@property (nonatomic, retain) NSString * flag;

@end
