//
//  BagDataController.h
//  Pokemon
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

typedef enum {
  kBagQueryTargetTypeItem       = 0,
  kBagQueryTargetTypeMedicine   = 1 << 0,
  kBagQueryTargetTypePokeball   = 1 << 1,
  kBagQueryTargetTypeTMHM       = 1 << 2,
  kBagQueryTargetTypeBerry      = 1 << 3,
  kBagQueryTargetTypeMail       = 1 << 4,
  kBagQueryTargetTypeBattleItem = 1 << 5,
  kBagQueryTargetTypeKeyItem    = 1 << 6
}BagQueryTargetType;


@interface BagDataController : NSObject

+ (BagDataController *)sharedInstance;
- (NSArray *)queryAllDataFor:(BagQueryTargetType)targetType;

@end
