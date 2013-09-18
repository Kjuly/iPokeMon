//
//  PokemonInfoViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonDetailViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation PokemonDetailViewController

@synthesize pokemon = pokemon_;

- (id)initWithPokemon:(Pokemon *)pokemon
{
  if (self = [self init]) {
    self.pokemon = pokemon;
  }
  return self;
}

- (id)init
{
  return (self = [super init]);
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
  UIView * view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, {kViewWidth, kViewHeight}}];
  [view setBackgroundColor:[UIColor clearColor]];
  self.view = view;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Constants
  CGFloat const imageHeight     = 150.f;
  CGFloat const imageWidth      = 150.f;
  
  CGFloat const labelHeight     = 30.f;
  CGFloat const labelWidth      = 80.f;
  
  CGFloat const nameLabelWidth  = 300.f - imageWidth;
  CGFloat const nameLabelHeight = imageHeight / 2 - labelHeight;
  
  CGRect  const IDViewFrame     = CGRectMake(imageWidth + 20.f, 50.f, 300.f - imageWidth, imageHeight - 50.f);
  
  ///Left Image View
  UIView * imageContainer = [[UIView alloc] initWithFrame:CGRectMake(10.f, 10.f, imageWidth, imageHeight)];
  [imageContainer setBackgroundColor:
   [UIColor colorWithPatternImage:[UIImage imageNamed:kPMINPMDetailImageBackgound]]];
  [imageContainer setOpaque:NO];
  
  // Image
  UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, imageWidth, imageHeight)];
  [imageView setUserInteractionEnabled:YES];
  [imageView setContentMode:UIViewContentModeCenter];
  [imageView setBackgroundColor:[UIColor clearColor]];
  [imageView setImage:self.pokemon.image];
  
  [imageContainer addSubview:imageView];
  [self.view addSubview:imageContainer];
  
  
  ///Right ID View
  UIView * IDView = [[UIView alloc] initWithFrame:IDViewFrame];
  
  // ID
  PokemonInfoLabelView * idLabelView = [[PokemonInfoLabelView alloc]
                                        initWithFrame:CGRectMake(0.f, 0.f, labelWidth / 2, labelHeight)
                                        hasValueLabel:NO];
  [idLabelView.name setText:[NSString stringWithFormat:@"#%.3d", [self.pokemon.sid intValue]]];
  [idLabelView.name.layer setShadowColor:[UIColor blackColor].CGColor];
  [idLabelView.name.layer setShadowOpacity:1.f];
  [idLabelView.name.layer setShadowOffset:CGSizeMake(-1.f, -1.f)];
  [idLabelView.name.layer setShadowRadius:0.f];
  [IDView addSubview:idLabelView];
  
  // Name
  UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, labelHeight, nameLabelWidth, nameLabelHeight)];
  [nameLabel setBackgroundColor:[UIColor clearColor]];
  [nameLabel setTextColor:[GlobalRender textColorOrange]];
  [nameLabel setFont:[GlobalRender textFontBoldInSizeOf:20.f]];
  [nameLabel setText:
    KYResourceLocalizedString(([NSString stringWithFormat:@"PMSName%.3d", [self.pokemon.sid intValue]]), nil)];
  [nameLabel.layer setShadowColor:[UIColor blackColor].CGColor];
  [nameLabel.layer setShadowOpacity:1.f];
  [nameLabel.layer setShadowOffset:CGSizeMake(-1.f, -1.f)];
  [nameLabel.layer setShadowRadius:0.f];
  [IDView addSubview:nameLabel];
  
  // Add Right ID View to |self.view| & Release it
  [self.view addSubview:IDView];
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
