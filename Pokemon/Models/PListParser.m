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

@end
