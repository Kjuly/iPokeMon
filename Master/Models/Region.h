//
//  Region.h
//  iPokeMon
//
//  Created by Kaijie Yu on 5/5/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Region : NSManagedObject

@property (nonatomic, strong) NSString * administrativeArea;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSString * countryCode;
@property (nonatomic, strong) NSString * locality;
@property (nonatomic, strong) NSString * subLocality;
@property (nonatomic, strong) NSString * flag;

@end
