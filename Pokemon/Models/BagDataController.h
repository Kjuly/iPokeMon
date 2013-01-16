//
//  BagDataController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 3/17/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BagItem.h"
#import "BagMedicine.h"
#import "BagPokeball.h"
#import "BagTMHM.h"
#import "BagBerry.h"
#import "BagMail.h"
#import "BagBattleItem.h"
#import "BagKeyItem.h"


@interface BagDataController : NSObject

+ (BagDataController *)sharedInstance;
- (NSArray *)queryAllDataFor:(BagQueryTargetType)targetType;
- (NSArray *)queryDataFor:(BagQueryTargetType)targetType withIDsInString:(NSString *)targetIDsInString;
- (id)queryDataFor:(BagQueryTargetType)targetType withID:(NSInteger)targetID;

@end
