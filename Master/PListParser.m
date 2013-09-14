//
//  PListParser.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/5/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PListParser.h"

@implementation PListParser

+ (NSString *)_pathOfPropertyList:(NSString *)propertyList
                         inBundle:(NSBundle *)bundle {
  return [bundle pathForResource:propertyList
                          ofType:@"plist"
                     inDirectory:kBundleDirectoryOfPropertyList];
}

#pragma mark - Pokedex

// Get All Pokemons as an Array for Pokedex
+ (NSArray *)pokedexInBundle:(NSBundle *)bundle {
  return [NSArray arrayWithContentsOfFile:[self _pathOfPropertyList:@"Pokedex"
                                                           inBundle:bundle]];
}

// Get Pokemons that User Brought
+ (NSMutableArray *)sixPokemons:(NSMutableArray *)sixPokemonsID {
  NSArray * pokedex = [self pokedexInBundle:[[ResourceManager sharedInstance] defaultBundle]];
  NSMutableArray * sixPokemons = [[NSMutableArray alloc] init];
  for (int i = 0; i < [sixPokemonsID count]; ++i) {
    NSInteger pokemonID = [[sixPokemonsID objectAtIndex:i] intValue] >> 4;
    NSLog(@">>> %d", pokemonID);
    [sixPokemons addObject:[pokedex objectAtIndex:pokemonID]];
  }
  return sixPokemons;
}

// Get Info for One Pokemon
+ (NSDictionary *)pokemonInfo:(NSInteger)pokemonID {
  return [[self pokedexInBundle:[[ResourceManager sharedInstance] defaultBundle]] objectAtIndex:pokemonID];
}

// Get All Pokemon Photo as an Array for Pokedex
+ (NSArray *)pokedexGenerationOneImageArray {
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
      UIImage * singleImage = [[UIImage alloc] initWithCGImage:cgImage];
      CGImageRelease(cgImage);
      
      // Add |singleImage| to Array
      [pokedexGenerationOneImageArray addObject:singleImage];
    }
  }
  
  return pokedexGenerationOneImageArray;
}

// Return A Single Image for One Pokemon
+ (UIImage *)pokedexGenerationOneImageForPokemon:(NSInteger)pokemonID {
  UIImage * fullImage = [UIImage imageNamed:@"GenerationOne.png"];
  NSInteger singleImageHeight = 96;
  NSInteger singleImageWidth  = 96;
  
  CGImageRef cgImage = CGImageCreateWithImageInRect(fullImage.CGImage,
                                                    CGRectMake(singleImageWidth * (pokemonID % 13),
                                                               singleImageHeight * (pokemonID / 13),
                                                               singleImageWidth,
                                                               singleImageHeight));
  UIImage * pokemonImage = [UIImage imageWithCGImage:cgImage];
  CGImageRelease(cgImage);
  
  return pokemonImage;
}

// Image Array for Six Pokemons
+ (NSArray *)sixPokemonsImageArrayFor:(NSString *)IDSequence {
  NSMutableArray * imageArray = [[NSMutableArray alloc] init];
  UIImage * fullImage = [UIImage imageNamed:@"AllPokemonImageSmall.png"];
  
  for (int i = 0; i < [IDSequence length]; i += 4) {
    // Decode Hex to int value
    NSScanner * scanner = [[NSScanner alloc] initWithString:[IDSequence substringWithRange:NSMakeRange(i, 4)]];
    uint_fast32_t pokemonID;
    [scanner scanHexInt:&pokemonID];
    
    // Get right Image
    CGImageRef cgImage = CGImageCreateWithImageInRect(fullImage.CGImage,
                                                      CGRectMake(32.0f * (pokemonID % 27),
                                                                 32.0f * (pokemonID / 27),
                                                                 32.0f,
                                                                 32.0f));
    UIImage * pokemonImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    // Add Image to |imageArray|
    [imageArray addObject:pokemonImage];
  }
  
  return [NSArray arrayWithArray:imageArray];
}

#pragma mark - Moves & Ability

+ (NSArray *)movesInBundle:(NSBundle *)bundle {
  return [NSArray arrayWithContentsOfFile:[self _pathOfPropertyList:@"Moves" inBundle:bundle]];
}

#pragma mark - Bag[Item]

+ (NSArray *)bagItemsInBundle:(NSBundle *)bundle {
  return [NSArray arrayWithContentsOfFile:[self _pathOfPropertyList:@"BagItems" inBundle:bundle]];
}

+ (NSArray *)bagMedicineInBundle:(NSBundle *)bundle {
  return [NSArray arrayWithContentsOfFile:[self _pathOfPropertyList:@"BagMedicine" inBundle:bundle]];
}

+ (NSArray *)bagPokeballsInBundle:(NSBundle *)bundle {
  return [NSArray arrayWithContentsOfFile:[self _pathOfPropertyList:@"BagPokeballs" inBundle:bundle]];
}

+ (NSArray *)bagTMsHMsInBundle:(NSBundle *)bundle {
  return [NSArray arrayWithContentsOfFile:[self _pathOfPropertyList:@"BagTMsHMs" inBundle:bundle]];
}

+ (NSArray *)bagBerriesInBundle:(NSBundle *)bundle {
  return [NSArray arrayWithContentsOfFile:[self _pathOfPropertyList:@"BagBerries" inBundle:bundle]];
}

+ (NSArray *)bagMailInBundle:(NSBundle *)bundle {
  return [NSArray arrayWithContentsOfFile:[self _pathOfPropertyList:@"BagMail" inBundle:bundle]];
}

+ (NSArray *)bagBattleItemsInBundle:(NSBundle *)bundle {
  return [NSArray arrayWithContentsOfFile:[self _pathOfPropertyList:@"BagBattleItems" inBundle:bundle]];
}

+ (NSArray *)bagKeyItemsInBundle:(NSBundle *)bundle {
  return [NSArray arrayWithContentsOfFile:[self _pathOfPropertyList:@"BagKeyItems" inBundle:bundle]];
}

#pragma mark - Game Setting Options

+ (NSArray *)gameSettingOptionsInBundle:(NSBundle *)bundle {
  return [NSArray arrayWithContentsOfFile:[self _pathOfPropertyList:@"GameSettingOptions" inBundle:bundle]];
}

@end
