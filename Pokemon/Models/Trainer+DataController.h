//
//  Trainer+DataController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/16/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "Trainer.h"

@interface Trainer (DataController)

+ (void)updateData;
+ (NSArray *)queryAllData;
+ (void)setTrainerWith:(NSInteger)id Name:(NSString *)name;

@end
