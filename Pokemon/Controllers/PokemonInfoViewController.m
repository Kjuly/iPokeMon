//
//  PokemonInfoViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonInfoViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "../GlobalConstants.h"
#import "GlobalColor.h"
#import "PListParser.h"

@implementation PokemonInfoViewController

@synthesize pokemonID = pokemonID_;
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
  
  CGFloat imageHeight       = 150.0f;
  CGFloat imageWidth        = 150.0f;
  CGFloat labelHeight       = 30.0f;
  CGFloat labelWidth        = 70.0f;
  CGFloat valueHeight       = 30.0f;
  CGFloat valueWidth        = 320.0f - imageWidth - labelWidth;
  CGFloat nameLabelWidth    = 320.0f - imageWidth;
  CGFloat nameLabelHeight   = imageHeight / 2 - labelHeight;
  
  // Image
  UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imageWidth, imageHeight)];
  [imageView setBackgroundColor:[UIColor clearColor]];
  [imageView setUserInteractionEnabled:YES];
  [imageView setContentMode:UIViewContentModeCenter];
  [imageView setImage:[PListParser pokedexGenerationOneImageForPokemon:self.pokemonID]];
  [self.view addSubview:imageView];
  [imageView release];
  
  // ID 
  UILabel * IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth, 10.0f, labelWidth, labelHeight)];
  [IDLabel setBackgroundColor:[UIColor clearColor]];
  [IDLabel setTextColor:[GlobalColor textColorBlue]];
  [IDLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:14.0f]];
  [IDLabel setText:[NSString stringWithFormat:@"#%.3d", self.pokemonID + 1]];
  [self.view addSubview:IDLabel];
  [IDLabel release];
  
  // Name
  UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth, labelHeight, nameLabelWidth, nameLabelHeight)];
  [nameLabel setBackgroundColor:[UIColor clearColor]];
  [nameLabel setTextColor:[GlobalColor textColorOrange]];
  [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:26.0f]];
  [nameLabel setText:[self.pokemonInfoDict objectForKey:@"name"]];
  [nameLabel.layer setShadowColor:[nameLabel.textColor CGColor]];
  [nameLabel.layer setShadowOpacity:1.0f];
  [nameLabel.layer setShadowOffset:CGSizeMake(0.0f, 1.0f)];
  [nameLabel.layer setShadowRadius:1.0f];
  [self.view addSubview:nameLabel];
  [nameLabel release];
  
  // Species
  UILabel * speciesLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth,
                                                                     nameLabelHeight + labelHeight,
                                                                     labelWidth,
                                                                     labelHeight)];
  UILabel * speciesValue = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth + labelWidth,
                                                                     nameLabelHeight + labelHeight,
                                                                     valueWidth,
                                                                     valueHeight)];
  [speciesLabel setBackgroundColor:[UIColor clearColor]];
  [speciesValue setBackgroundColor:[UIColor clearColor]];
  [speciesLabel setTextColor:[GlobalColor textColorBlue]];
  [speciesLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18.0f]];
  [speciesLabel setTextAlignment:UITextAlignmentRight];
  [speciesValue setTextAlignment:UITextAlignmentLeft];
  [speciesLabel setText:@"Species: "];
  [speciesValue setText:[[self.pokemonInfoDict objectForKey:@"species"] stringValue]];
  [self.view addSubview:speciesLabel];
  [self.view addSubview:speciesValue];
  [speciesLabel release];
  
  // Type
  UILabel * typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth,
                                                                  nameLabelHeight + labelHeight * 2,
                                                                  labelWidth,
                                                                  labelHeight)];
  UILabel * typeValue = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth + labelWidth,
                                                                  nameLabelHeight + labelHeight * 2,
                                                                  valueWidth,
                                                                  valueHeight)];
  [typeLabel setBackgroundColor:[UIColor clearColor]];
  [typeValue setBackgroundColor:[UIColor clearColor]];
  [typeLabel setTextColor:[GlobalColor textColorBlue]];
  [typeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18.0f]];
  [typeLabel setTextAlignment:UITextAlignmentRight];
  [typeValue setTextAlignment:UITextAlignmentLeft];
  [typeLabel setText:@"Type: "];
  [typeValue setText:[[[self.pokemonInfoDict objectForKey:@"type"] objectAtIndex:0] stringValue]];
  [self.view addSubview:typeLabel];
  [self.view addSubview:typeValue];
  [typeLabel release];
  [typeValue release];
  
  // Heigth
  UILabel * heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, imageHeight, labelWidth, labelHeight)];
  UILabel * heightValue = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, imageHeight, valueWidth, labelHeight)];
  [heightLabel setBackgroundColor:[UIColor clearColor]];
  [heightValue setBackgroundColor:[UIColor clearColor]];
  [heightLabel setTextColor:[GlobalColor textColorBlue]];
  [heightLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18.0f]];
  [heightLabel setTextAlignment:UITextAlignmentRight];
  [heightValue setTextAlignment:UITextAlignmentLeft];
  [heightLabel setText:@"Height: "];
  [heightValue setText:[NSString stringWithFormat:@"%.2f m", [[self.pokemonInfoDict objectForKey:@"height"] floatValue] / 100.0f]];
  [self.view addSubview:heightLabel];
  [self.view addSubview:heightValue];
  [heightLabel release];
  [heightValue release];
  
  // Weight
  UILabel * weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(150.0f, imageHeight, labelWidth, labelHeight)];
  UILabel * weightValue = [[UILabel alloc] initWithFrame:CGRectMake(150.0f + labelWidth, imageHeight,  valueWidth, valueHeight)];
  [weightLabel setBackgroundColor:[UIColor clearColor]];
  [weightValue setBackgroundColor:[UIColor clearColor]];
  [weightLabel setTextColor:[GlobalColor textColorBlue]];
  [weightLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18.0f]];
  [weightLabel setTextAlignment:UITextAlignmentRight];
  [weightValue setTextAlignment:UITextAlignmentLeft];
  [weightLabel setText:@"Weight: "];
  [weightValue setText:[NSString stringWithFormat:@"%.2f kg", [[self.pokemonInfoDict objectForKey:@"weight"] floatValue] / 1000.0f]];
  [self.view addSubview:weightLabel];
  [self.view addSubview:weightValue];
  [weightLabel release];
  [weightValue release];
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
