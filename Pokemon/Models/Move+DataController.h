//
//  Move+DataController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/22/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "Move.h"

@interface Move (DataController)

// Hard Initialize the DB data
+ (void)populateData;

// Data Query Mthods
+ (NSArray *)queryAllData;
+ (Move *)queryMoveDataWithID:(NSInteger)moveID;

@end
