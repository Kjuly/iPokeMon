//
//  PokemonMove.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/17/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PokemonMove : NSManagedObject

@property (nonatomic, retain) NSNumber * moveID;
@property (nonatomic, retain) NSString * name;

@end
