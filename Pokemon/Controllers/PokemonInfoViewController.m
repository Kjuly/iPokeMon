//
//  PokemonInfoViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonInfoViewController.h"

#import "GlobalRender.h"

@implementation PokemonInfoViewController

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
  
  CGRect  const dataViewFrame     = CGRectMake(10.0f, imageHeight + 15.0f, 300.0f, 60.0f);
  CGRect  const descriptionFrame  = CGRectMake(10.0f,
                                               imageHeight + dataViewFrame.size.height + 20.0f,
                                               300.0f,
                                               130.0f);
  
  
  ///Data View in Center
  UIView * dataView = [[UIView alloc] initWithFrame:dataViewFrame];
  
  // Species
  UILabel * speciesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, labelWidth, labelHeight)];
  UILabel * speciesValue = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, 0.0f, valueWidth, valueHeight)];
  [speciesLabel setBackgroundColor:[UIColor clearColor]];
  [speciesValue setBackgroundColor:[UIColor clearColor]];
  [speciesLabel setTextColor:[GlobalRender textColorBlue]];
  [speciesLabel setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
  [speciesValue setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
  [speciesLabel setTextAlignment:UITextAlignmentRight];
  [speciesValue setTextAlignment:UITextAlignmentLeft];
  [speciesLabel setText:@"Species: "];
  [speciesValue setText:[[self.pokemonDataDict valueForKey:@"species"] stringValue]];
  [dataView addSubview:speciesLabel];
  [dataView addSubview:speciesValue];
  [speciesLabel release];
  [speciesValue release];
  
  // Type
  UILabel * typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, labelHeight, labelWidth, labelHeight)];
  UILabel * typeValue = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, labelHeight, valueWidth, valueHeight)];
  [typeLabel setBackgroundColor:[UIColor clearColor]];
  [typeValue setBackgroundColor:[UIColor clearColor]];
  [typeLabel setTextColor:[GlobalRender textColorBlue]];
  [typeLabel setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
  [typeValue setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
  [typeLabel setTextAlignment:UITextAlignmentRight];
  [typeValue setTextAlignment:UITextAlignmentLeft];
  [typeLabel setText:@"Type: "];
  [typeValue setText:[[self.pokemonDataDict valueForKey:@"type1"] stringValue]];
  [dataView addSubview:typeLabel];
  [dataView addSubview:typeValue];
  [typeLabel release];
  [typeValue release];
  
  // Add Data View to |self.view| & Release it
  [self.view addSubview:dataView];
  [dataView release];
  
  
  ///Description
  UITextView * descriptionField = [[UITextView alloc] initWithFrame:descriptionFrame];
  [descriptionField setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"PokemonDetailDescriptionBackground.png"]]];
  [descriptionField setOpaque:NO];
  [descriptionField setEditable:NO];
  [descriptionField setFont:[GlobalRender textFontNormalInSizeOf:14.0f]];
  [descriptionField setText:[self.pokemonDataDict valueForKey:@"info"]];
  [self.view addSubview:descriptionField];
  [descriptionField release];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
