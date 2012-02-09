//
//  PListParser.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/5/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PListParser.h"

@implementation PListParser

+ (NSString *)getFilePath:(NSString *)fileName {
  return [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
}

#pragma mark - Pokedex

// Get All Pokemons as an Array for Pokedex
+ (NSArray *)pokedex {
  return [NSArray arrayWithContentsOfFile:[self getFilePath:@"Pokedex"]];
}

// Get Pokemons that User Brought
+ (NSMutableArray *)sixPokemons:(NSMutableArray *)sixPokemonsID
{
  NSArray * pokedex = [self pokedex];
  NSMutableArray * sixPokemons = [[NSMutableArray alloc] init];
  for (int i = 0; i < [sixPokemonsID count]; ++i) {
    NSInteger pokemonID = [[sixPokemonsID objectAtIndex:i] intValue] >> 4;
    NSLog(@">>> %d", pokemonID);
    [sixPokemons addObject:[pokedex objectAtIndex:pokemonID]];
  }
  return [sixPokemons autorelease];
}

// Get Info for One Pokemon
+ (NSDictionary *)pokemonInfo:(NSInteger)pokemonID {
  return [[self pokedex] objectAtIndex:pokemonID];
}

// Get All Pokemon Photo as an Array for Pokedex
+ (NSArray *)pokedexGenerationOneImageArray
{
  NSMutableArray * pokedexGenerationOneImageArray = [[NSMutableArray alloc] init];
  
  UIImage * fullImage = [UIImage imageNamed:@"GenerationOne.png"];
  NSInteger fullImageHeight = fullImage.size.height;
  NSInteger fullImageWidth  = fullImage.size.width;
  NSInteger singleImageHeight = 96;
  NSInteger singleImageWidth  = 96;
  
  for (int height = 0; height <= fullImageHeight - singleImageHeight; height += singleImageHeight) {
    for (int width = 0; width <= fullImageWidth - singleImageWidth; width += singleImageWidth) {
      CGImageRef cgImage = CGImageCreateWithImageInRect(fullImage.CGImage,
                                                        CGRectMake(width, height, singleImageWidth, singleImageHeight));
      
      // Add ImageView to Array
      [pokedexGenerationOneImageArray addObject:[UIImage imageWithCGImage:cgImage]];
    }
  }
  
  return [pokedexGenerationOneImageArray autorelease];
}

// Return A Single Image for One Pokemon
+ (UIImage *)pokedexGenerationOneImageForPokemon:(NSInteger)pokemonID
{
  UIImage * fullImage = [UIImage imageNamed:@"GenerationOne.png"];
  NSInteger singleImageHeight = 96;
  NSInteger singleImageWidth  = 96;
  
  CGImageRef cgImage = CGImageCreateWithImageInRect(fullImage.CGImage,
                                                    CGRectMake(singleImageWidth * (pokemonID % 13),
                                                               singleImageHeight * (pokemonID / 13),
                                                               singleImageWidth,
                                                               singleImageHeight));
  
  return [UIImage imageWithCGImage:cgImage];
}

#pragma mark - Bag[Item]

+ (NSArray *)bagItems {
  return [NSArray arrayWithContentsOfFile:[self getFilePath:@"BagItems"]];
}

+ (NSArray *)bagMedicine {
  return [NSArray arrayWithContentsOfFile:[self getFilePath:@"BagMedicine"]];
}

+ (NSArray *)bagPokeballs {
  return [NSArray arrayWithContentsOfFile:[self getFilePath:@"BagPokeballs"]];
}

+ (NSArray *)bagTMsHMs {
  return [NSArray arrayWithContentsOfFile:[self getFilePath:@"BagTMsHMs"]];
}

+ (NSArray *)bagBerries {
  return [NSArray arrayWithContentsOfFile:[self getFilePath:@"BagBerries"]];
}

+ (NSArray *)bagMail {
  return [NSArray arrayWithContentsOfFile:[self getFilePath:@"BagMail"]];
}

+ (NSArray *)bagBattleItems {
  return [NSArray arrayWithContentsOfFile:[self getFilePath:@"BagBattleItems"]];
}

+ (NSArray *)bagKeyItems {
  return [NSArray arrayWithContentsOfFile:[self getFilePath:@"BagKeyItems"]];
}

@end
