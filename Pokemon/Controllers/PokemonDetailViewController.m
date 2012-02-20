//
//  PokemonInfoViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonDetailViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "GlobalRender.h"

@implementation PokemonDetailViewController

@synthesize pokemonDataDict = pokemonDataDict_;

- (void)dealloc
{
  [pokemonDataDict_ release];
  
  [super dealloc];
}

- (id)initWithPokemonDataDict:(NSDictionary *)pokemonDataDict
{
  self = [self init];
  if (self) {
    self.pokemonDataDict = pokemonDataDict;
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
  
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
  self.view = view;
  [view release];
  
  [self.view setBackgroundColor:[UIColor whiteColor]];
  
  // Constants
  CGFloat const imageHeight       = 150.0f;
  CGFloat const imageWidth        = 150.0f;
  
  CGFloat const labelHeight       = 30.0f;
  CGFloat const labelWidth        = 80.0f;
  
  CGFloat const nameLabelWidth    = 300.0f - imageWidth;
  CGFloat const nameLabelHeight   = imageHeight / 2 - labelHeight;
  
  CGRect  const IDViewFrame       = CGRectMake(imageWidth + 20.0f, 50.0f, 300.0f - imageWidth, imageHeight - 50.0f);
  
  
  ///Left Image View
  UIView * imageContainer = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, imageWidth, imageHeight)];
  [imageContainer setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"PokemonDetailImageBackground.png"]]];
  [imageContainer setOpaque:NO];
  
  // Image
  UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imageWidth, imageHeight)];
  [imageView setUserInteractionEnabled:YES];
  [imageView setContentMode:UIViewContentModeCenter];
  [imageView setBackgroundColor:[UIColor clearColor]];
  [imageView setImage:[self.pokemonDataDict valueForKey:@"image"]];
  
  [imageContainer addSubview:imageView];
  [imageView release];
  [self.view addSubview:imageContainer];
  [imageContainer release];
  
  
  ///Right ID View
  UIView * IDView = [[UIView alloc] initWithFrame:IDViewFrame];
  
  // ID
  UILabel * IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, labelWidth, labelHeight)];
  [IDLabel setBackgroundColor:[UIColor clearColor]];
  [IDLabel setTextColor:[GlobalRender textColorBlue]];
  [IDLabel setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
  [IDLabel setText:[NSString stringWithFormat:@"#%.3d", [[self.pokemonDataDict valueForKey:@"sid"] intValue]]];
  [IDView addSubview:IDLabel];
  [IDLabel release];
  
  // Name
  UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, labelHeight, nameLabelWidth, nameLabelHeight)];
  [nameLabel setBackgroundColor:[UIColor clearColor]];
  [nameLabel setTextColor:[GlobalRender textColorOrange]];
  [nameLabel setFont:[GlobalRender textFontBoldInSizeOf:20.0f]];
  [nameLabel setText:NSLocalizedString([self.pokemonDataDict valueForKey:@"name"], nil)];
  [nameLabel.layer setShadowColor:[nameLabel.textColor CGColor]];
  [nameLabel.layer setShadowOpacity:1.0f];
  [nameLabel.layer setShadowOffset:CGSizeMake(0.0f, 1.0f)];
  [nameLabel.layer setShadowRadius:1.0f];
  [IDView addSubview:nameLabel];
  [nameLabel release];
  
  // Add Right ID View to |self.view| & Release it
  [self.view addSubview:IDView];
  [IDView release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.pokemonDataDict = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
