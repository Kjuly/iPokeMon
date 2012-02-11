//
//  PokemonInfoViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonInfoViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "GlobalColor.h"
#import "PListParser.h"

@implementation PokemonInfoViewController

@synthesize pokemonID       = pokemonID_;
@synthesize pokemonInfoDict = pokemonInfoDict_;

- (void)dealloc
{
  [pokemonInfoDict_ release];
  
  [super dealloc];
}

- (id)initWithPokemonID:(NSInteger)pokemonID
{
  self = [self init];
  if (self) {
    self.pokemonID       = pokemonID;
    self.pokemonInfoDict = [PListParser pokemonInfo:pokemonID];
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
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
  [self.view setBackgroundColor:[UIColor whiteColor]];
  
  // Constants
  CGFloat const imageHeight       = 150.0f;
  CGFloat const imageWidth        = 150.0f;
  
  CGFloat const labelHeight       = 30.0f;
  CGFloat const labelWidth        = 70.0f;
  CGFloat const valueHeight       = 30.0f;
  CGFloat const valueWidth        = 300.0f - labelWidth;
  
  CGFloat const nameLabelWidth    = 300.0f - imageWidth;
  CGFloat const nameLabelHeight   = imageHeight / 2 - labelHeight;
  
  CGRect  const IDViewFrame       = CGRectMake(imageWidth + 20.0f, 50.0f, 300.0f - imageWidth, imageHeight - 50.0f);
  CGRect  const dataViewFrame     = CGRectMake(10.0f, imageHeight + 15.0f, 300.0f, 60.0f);
  CGRect  const descriptionFrame  = CGRectMake(10.0f,
                                               imageHeight + dataViewFrame.size.height + 20.0f,
                                               300.0f,
                                               130.0f);
  
  
  ///Left Image View
  UIView * imageContainer = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, imageWidth, imageHeight)];
  [imageContainer setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"PokemonDetailImageBackground.png"]]];
  
  // Image
  UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imageWidth, imageHeight)];
  [imageView setUserInteractionEnabled:YES];
  [imageView setContentMode:UIViewContentModeCenter];
  [imageView setBackgroundColor:[UIColor clearColor]];
  [imageView setImage:[PListParser pokedexGenerationOneImageForPokemon:self.pokemonID]];
  
  [imageContainer addSubview:imageView];
  [imageView release];
  [self.view addSubview:imageContainer];
  [imageContainer release];
  
  
  ///Right ID View
  UIView * IDView = [[UIView alloc] initWithFrame:IDViewFrame];
  
  // ID
  UILabel * IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, labelWidth, labelHeight)];
  [IDLabel setBackgroundColor:[UIColor clearColor]];
  [IDLabel setTextColor:[GlobalColor textColorBlue]];
  [IDLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:20.0f]];
  [IDLabel setText:[NSString stringWithFormat:@"#%.3d", self.pokemonID + 1]];
  [IDView addSubview:IDLabel];
  [IDLabel release];
  
  // Name
  UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, labelHeight, nameLabelWidth, nameLabelHeight)];
  [nameLabel setBackgroundColor:[UIColor clearColor]];
  [nameLabel setTextColor:[GlobalColor textColorOrange]];
  [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:26.0f]];
  [nameLabel setText:[self.pokemonInfoDict objectForKey:@"name"]];
  [nameLabel.layer setShadowColor:[nameLabel.textColor CGColor]];
  [nameLabel.layer setShadowOpacity:1.0f];
  [nameLabel.layer setShadowOffset:CGSizeMake(0.0f, 1.0f)];
  [nameLabel.layer setShadowRadius:1.0f];
  [IDView addSubview:nameLabel];
  [nameLabel release];
  
  // Add Right ID View to |self.view| & Release it
  [self.view addSubview:IDView];
  [IDView release];
  
  
  ///Data View in Center
  UIView * dataView = [[UIView alloc] initWithFrame:dataViewFrame];
  
  // Species
  UILabel * speciesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, labelWidth, labelHeight)];
  UILabel * speciesValue = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, 0.0f, valueWidth, valueHeight)];
  [speciesLabel setBackgroundColor:[UIColor clearColor]];
  [speciesValue setBackgroundColor:[UIColor clearColor]];
  [speciesLabel setTextColor:[GlobalColor textColorBlue]];
  [speciesLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18.0f]];
  [speciesLabel setTextAlignment:UITextAlignmentRight];
  [speciesValue setTextAlignment:UITextAlignmentLeft];
  [speciesLabel setText:@"Species: "];
  [speciesValue setText:[[self.pokemonInfoDict objectForKey:@"species"] stringValue]];
  [dataView addSubview:speciesLabel];
  [dataView addSubview:speciesValue];
  [speciesLabel release];
  
  // Type
  UILabel * typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, labelHeight, labelWidth, labelHeight)];
  UILabel * typeValue = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, labelHeight, valueWidth, valueHeight)];
  [typeLabel setBackgroundColor:[UIColor clearColor]];
  [typeValue setBackgroundColor:[UIColor clearColor]];
  [typeLabel setTextColor:[GlobalColor textColorBlue]];
  [typeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18.0f]];
  [typeLabel setTextAlignment:UITextAlignmentRight];
  [typeValue setTextAlignment:UITextAlignmentLeft];
  [typeLabel setText:@"Type: "];
  [typeValue setText:[[[self.pokemonInfoDict objectForKey:@"type"] objectAtIndex:0] stringValue]];
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
  [descriptionField setEditable:NO];
  [descriptionField setFont:[UIFont systemFontOfSize:14.0f]];
  [descriptionField setText:[self.pokemonInfoDict objectForKey:@"description"]];
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
  
  self.pokemonInfoDict = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
