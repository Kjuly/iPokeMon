//
//  PListParser.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/5/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PListParser.h"

@implementation PListParser

+ (NSArray *)pokedex
{
  NSString * pokedexPList = [[NSBundle mainBundle] pathForResource:@"Pokedex" ofType:@"plist"];
  return [NSArray arrayWithContentsOfFile:pokedexPList];
}

@end
