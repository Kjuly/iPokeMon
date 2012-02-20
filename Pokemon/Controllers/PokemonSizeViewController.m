//
//  PokemonSizeViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonSizeViewController.h"

#import "GlobalRender.h"

@implementation PokemonSizeViewController

- (void)dealloc
{
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
  [super loadView];
  
  // Constants
  CGFloat const imageHeight       = 150.0f;
  
  CGFloat const labelHeight       = 30.0f;
  CGFloat const labelWidth        = 80.0f;
  CGFloat const valueHeight       = 30.0f;
  CGFloat const valueWidth        = 300.0f - labelWidth;
  
  CGRect  const sizeViewFrame = CGRectMake(10.0f, imageHeight + 15.0f, 300.0f, labelHeight);
  
  
  ///Size View
  UIView * sizeView = [[UIView alloc] initWithFrame:sizeViewFrame];
  
  // Heigth
  UILabel * heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, labelWidth, labelHeight)];
  UILabel * heightValue = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, 0.0f, valueWidth, labelHeight)];
  [heightLabel setBackgroundColor:[UIColor clearColor]];
  [heightValue setBackgroundColor:[UIColor clearColor]];
  [heightLabel setTextColor:[GlobalRender textColorBlue]];
  [heightLabel setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
  [heightValue setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
  [heightLabel setTextAlignment:UITextAlignmentRight];
  [heightValue setTextAlignment:UITextAlignmentLeft];
  [heightLabel setText:@"Height: "];
  [heightValue setText:[NSString stringWithFormat:@"%.2f m", [[self.pokemonDataDict valueForKey:@"height"] floatValue]]];
  [sizeView addSubview:heightLabel];
  [sizeView addSubview:heightValue];
  [heightLabel release];
  [heightValue release];
  
  // Weight
  UILabel * weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(130.0f, 0.0f, labelWidth, labelHeight)];
  UILabel * weightValue = [[UILabel alloc] initWithFrame:CGRectMake(130.0f + labelWidth, 0.0f,  valueWidth, valueHeight)];
  [weightLabel setBackgroundColor:[UIColor clearColor]];
  [weightValue setBackgroundColor:[UIColor clearColor]];
  [weightLabel setTextColor:[GlobalRender textColorBlue]];
  [weightLabel setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
  [weightValue setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
  [weightLabel setTextAlignment:UITextAlignmentRight];
  [weightValue setTextAlignment:UITextAlignmentLeft];
  [weightLabel setText:@"Weight: "];
  [weightValue setText:[NSString stringWithFormat:@"%.2f kg", [[self.pokemonDataDict valueForKey:@"weight"] floatValue]]];
  [sizeView addSubview:weightLabel];
  [sizeView addSubview:weightValue];
  [weightLabel release];
  [weightValue release];
  
  // Add Size View to |self.view| & Release it
  [self.view addSubview:sizeView];
  [sizeView release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

@end
