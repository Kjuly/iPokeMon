//
//  PokemonConfiguration.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/21/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonServerAPI.h"


NSString * const kPokemonServerAPIRoot        = @"http://localhost:8080";

NSString * const kPokemonServerAPIGetTrainer  = @"/user/%d";
NSString * const kPokemonServerAPIGetPokedex  = @"/user/%d/pokedex";
NSString * const kPokemonServerAPIGetBag      = @"/user/%d/bag";
NSString * const kPokemonServerAPIGetWildPokemons = @"/region/%d/wildpokemons";

NSString * const kPokemonServerAPIPostTrainer = @"/user/%d";
NSString * const kPokemonServerAPIPostPokedex = @"/user/%d/pokedex";
NSString * const kPokemonServerAPIPostBag     = @"/user/%d/bag";


@implementation PokemonServerAPI

#pragma mark - GET methods

+ (NSURL *)APIGetTrainerWithTrainerID:(NSInteger)trainerID {
  NSString * subPath = [NSString stringWithFormat:kPokemonServerAPIGetTrainer, trainerID];
  return [NSURL URLWithString:[kPokemonServerAPIRoot stringByAppendingString:subPath]];
}

+ (NSURL *)APIGetPokedexWithTrainerID:(NSInteger)trainerID {
  NSString * subPath = [NSString stringWithFormat:kPokemonServerAPIGetPokedex, trainerID];
  return [NSURL URLWithString:[kPokemonServerAPIRoot stringByAppendingString:subPath]];
}

+ (NSURL *)APIGetBagWithTrainerID:(NSInteger)trainerID {
  NSString * subPath = [NSString stringWithFormat:kPokemonServerAPIGetBag, trainerID];
  return [NSURL URLWithString:[kPokemonServerAPIRoot stringByAppendingString:subPath]];
}

+ (NSURL *)APIGetWildPokemonsForCurrentRegion:(NSInteger)regionID {
  NSString * subPath = [NSString stringWithFormat:kPokemonServerAPIGetWildPokemons, regionID];
  return [NSURL URLWithString:[kPokemonServerAPIRoot stringByAppendingFormat:subPath]];
}

#pragma mark - POST methods

+ (BOOL)APIPostTrainerWithTrainerID:(NSInteger)trainerID {
  return false;
}

+ (BOOL)APIPostPokedexWithTrainerID:(NSInteger)trainerID {
  return false;
}

+ (BOOL)APIPostBagWithTrainerID:(NSInteger)trainerID {
  return false;
}

@end

