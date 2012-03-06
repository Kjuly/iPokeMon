//
//  PokemonInfoViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonInfoViewController.h"

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
  CGFloat const imageHeight = 150.f;
  CGFloat const labelHeight = 30.f;
  
  CGRect  const speciesLabelViewFrame = CGRectMake(0.f, 0.f, 300.f, labelHeight);
  CGRect  const typeLabelViewFrame    = CGRectMake(0.f, labelHeight, 300.f, labelHeight);
  CGRect  const dataViewFrame     = CGRectMake(10.f, imageHeight + 15.f, 300.f, 60.f);
  CGRect  const descriptionFrame  = CGRectMake(10.f,
                                               imageHeight + dataViewFrame.size.height + 20.f,
                                               300.f,
                                               130.f);
  
  
  ///Data View in Center
  UIView * dataView = [[UIView alloc] initWithFrame:dataViewFrame];
  
  // Species
  PokemonInfoLabelView * speciesLabelView = [[PokemonInfoLabelView alloc] initWithFrame:speciesLabelViewFrame hasValueLabel:YES];
  [speciesLabelView.name  setText:NSLocalizedString(@"PMSLabelSpecies", nil)];
  [speciesLabelView.value setText:NSLocalizedString(([NSString stringWithFormat:@"PMSSpecies%.3d",
                                                      [[self.pokemonDataDict valueForKey:@"species"] intValue]]), nil)];
  [dataView addSubview:speciesLabelView];
  [speciesLabelView release];
  
  // Type
  PokemonInfoLabelView * typeLabelView = [[PokemonInfoLabelView alloc] initWithFrame:typeLabelViewFrame hasValueLabel:YES];
  NSString * types = NSLocalizedString(([NSString stringWithFormat:@"PMSType%.2d",
                                         [self.pokemonDataDict.type1 intValue]]), nil);
  if ([self.pokemonDataDict.type2 intValue])
    types = [types stringByAppendingString:[NSString stringWithFormat:@", %@",
                                            NSLocalizedString(([NSString stringWithFormat:@"PMSType%.2d",
                                                                [self.pokemonDataDict.type2 intValue]]), nil)]];
  [typeLabelView.name  setText:NSLocalizedString(@"PMSLabelType", nil)];
  [typeLabelView.value setText:types];
  [dataView addSubview:typeLabelView];
  [typeLabelView release];
  
  // Add Data View to |self.view| & Release it
  [self.view addSubview:dataView];
  [dataView release];
  
  
  ///Description
  UITextView * descriptionField = [[UITextView alloc] initWithFrame:descriptionFrame];
  [descriptionField setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"PokemonDetailDescriptionBackground.png"]]];
  [descriptionField setOpaque:NO];
  [descriptionField setEditable:NO];
  [descriptionField setFont:[GlobalRender textFontNormalInSizeOf:14.f]];
  [descriptionField setTextColor:[GlobalRender textColorNormal]];
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
