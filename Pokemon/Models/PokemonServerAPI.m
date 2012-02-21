//
//  PokemonConfiguration.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/21/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonServerAPI.h"


NSString * const kServerAPIRoot        = @"http://localhost:8080";

NSString * const kServerAPIGetTrainer  = @"/user/%d";
NSString * const kServerAPIGetPokedex  = @"/user/%d/pokedex";
NSString * const kServerAPIGetBag      = @"/user/%d/bag";

NSString * const kServerAPIPostTrainer = @"/user/%d";
NSString * const kServerAPIPostPokedex = @"/user/%d/pokedex";
NSString * const kServerAPIPostBag     = @"/user/%d/bag";


@implementation PokemonServerAPI

#pragma mark - GET methods

+ (NSURL *)APIGetTrainerWithTrainerID:(NSInteger)trainerID {
  NSString * subPath = [NSString stringWithFormat:kServerAPIGetTrainer, trainerID];
  return [NSURL URLWithString:[kServerAPIRoot stringByAppendingString:subPath]];
}

+ (NSURL *)APIGetPokedexWithTrainerID:(NSInteger)trainerID {
  NSString * subPath = [NSString stringWithFormat:kServerAPIGetPokedex, trainerID];
  return [NSURL URLWithString:[kServerAPIRoot stringByAppendingString:subPath]];
}

+ (NSURL *)APIGetBagWithTrainerID:(NSInteger)trainerID {
  NSString * subPath = [NSString stringWithFormat:kServerAPIGetBag, trainerID];
  return [NSURL URLWithString:[kServerAPIRoot stringByAppendingString:subPath]];
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

