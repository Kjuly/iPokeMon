//
//  PokemonSizeViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonSizeViewController.h"

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
  CGFloat const imageHeight = 150.0f;
  CGFloat const labelHeight = 30.0f;
  
  CGRect  const sizeViewFrame    = CGRectMake(10.0f, imageHeight + 15.0f, 300.0f, labelHeight);
  CGRect  const heightLabelFrame = CGRectMake(0.0f, 0.0f, 140.0f, labelHeight);
  CGRect  const weightLabelFrame = CGRectMake(140.0f, 0.0f, 160.0f, labelHeight);
  
  
  ///Size View
  UIView * sizeView = [[UIView alloc] initWithFrame:sizeViewFrame];
  
  // Heigth
  PokemonInfoLabelView * heightLabelView = [[PokemonInfoLabelView alloc] initWithFrame:heightLabelFrame hasValueLabel:YES];
  [heightLabelView.name  setText:NSLocalizedString(@"PMSLabelHeight", nil)];
  [heightLabelView.value setText:[NSString stringWithFormat:@"%.2f m",
                                  [[self.pokemonDataDict valueForKey:@"height"] floatValue]]];
  [sizeView addSubview:heightLabelView];
  [heightLabelView release];
  
  // Weight
  PokemonInfoLabelView * weightLabelView = [[PokemonInfoLabelView alloc] initWithFrame:weightLabelFrame hasValueLabel:YES];
  [weightLabelView.name  setText:NSLocalizedString(@"PMSLabelWeight", nil)];
  [weightLabelView.value setText:[NSString stringWithFormat:@"%.2f kg",
                                  [[self.pokemonDataDict valueForKey:@"weight"] floatValue]]];
  [sizeView addSubview:weightLabelView];
  [weightLabelView release];
  
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
