//
//  DataDecoder.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/4/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "DataDecoder.h"

#import "PListParser.h"

#define kDataLengthPokedex 4

const NSRange kRangePokemonName = {0, 4};


@implementation DataDecoder

// Decode data for Pokedex
+ (NSMutableArray *)decodePokedexFrom:(NSString *)data
{
  NSMutableArray * resultArray = [[NSMutableArray alloc] init];
  
  for (int i = 0; i < [data length] - 1; i += kDataLengthPokedex)
    [resultArray addObject:[data substringWithRange:NSMakeRange(i, kDataLengthPokedex)]];
  
  return [resultArray autorelease];
}

// Decode Name form HEX
+ (NSString *)decodeNameFrom:(NSString *)hex
{
  // Decode the Pokemon ID form HEX
  NSUInteger pokemonID;
  NSScanner * scanner = [NSScanner scannerWithString:[hex substringWithRange:kRangePokemonName]];
  [scanner setScanLocation:0];
  [scanner scanHexInt:&pokemonID];
  
  // Got Pokemon's Name form Pokedex Data
  NSArray * pokedex = [PListParser pokedex];
  NSString * pokemonName = [NSString stringWithString:[[pokedex objectAtIndex:pokemonID] objectForKey:@"name"]];
  
  return pokemonName;
}

@end
