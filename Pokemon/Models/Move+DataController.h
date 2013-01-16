//
//  Move+DataController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/22/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "Move.h"

@interface Move (DataController)

+ (NSArray *)queryFourMovesDataWithIDs:(NSArray *)moveIDs;
+ (Move *)queryMoveDataWithID:(NSInteger)moveID;

@end
