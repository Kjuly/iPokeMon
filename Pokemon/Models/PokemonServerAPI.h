//
//  PokemonConfiguration.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/21/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

@interface PokemonServerAPI : NSObject

+ (NSURL *)APIGetTrainerWithTrainerID:(NSInteger)trainerID;
+ (NSURL *)APIGetPokedexWithTrainerID:(NSInteger)trainerID;
+ (NSURL *)APIGetBagWithTrainerID:(NSInteger)trainerID;
+ (NSURL *)APIGetWildPokemonsForCurrentRegion:(NSInteger)regionID;

+ (BOOL)APIPostTrainerWithTrainerID:(NSInteger)trainerID;
+ (BOOL)APIPostPokedexWithTrainerID:(NSInteger)trainerID;
+ (BOOL)APIPostBagWithTrainerID:(NSInteger)trainerID;

@end
