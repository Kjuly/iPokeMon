//
//  SixPokemonsDetailTabViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/21/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SixPokemonsDetailTabViewController.h"

#import "GlobalConstants.h"
#import "GlobalRender.h"
#import "TrainerTamedPokemon.h"
#import "SixPokemonsInfoViewController.h"
#import "SixPokemonsMemoViewController.h"
#import "SixPokemonsSkillViewController.h"
#import "SixPokemonsMoveViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation SixPokemonsDetailTabViewController

@synthesize pokemon = pokemon_;
@synthesize sixPokemonsInfoViewController  = sixPokemonsInfoViewController_;
@synthesize sixPokemonsMemoViewController  = sixPokemonsMemoViewController_;
@synthesize sixPokemonsSkillViewController = sixPokemonsSkillViewController_;
@synthesize sixPokemonsMoveViewController  = sixPokemonsMoveViewController_;

-(void)dealloc
{
  [pokemon_ release];
  [sixPokemonsInfoViewController_  release];
  [sixPokemonsMemoViewController_  release];
  [sixPokemonsSkillViewController_ release];
  [sixPokemonsMoveViewController_  release];
  [super dealloc];
}

- (id)initWithPokemon:(TrainerTamedPokemon *)pokemon
{
  self = [super init];
  if (self) {
    // Set View Frame
    self.viewFrame = CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
    self.pokemon = pokemon;
    
    // Add child view controllers to each tab
    sixPokemonsInfoViewController_  = [[SixPokemonsInfoViewController alloc]  initWithPokemon:self.pokemon];
    sixPokemonsMemoViewController_  = [[SixPokemonsMemoViewController alloc]  initWithPokemon:self.pokemon];
    sixPokemonsSkillViewController_ = [[SixPokemonsSkillViewController alloc] initWithPokemon:self.pokemon];
    sixPokemonsMoveViewController_  = [[SixPokemonsMoveViewController alloc]  initWithPokemon:self.pokemon];
    
    // Add child views as tab bar items
    self.tabBarItems = [NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:@"PokemonDetail_Info.png", @"image", sixPokemonsInfoViewController_, @"viewController", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"PokemonDetail_Area.png", @"image", sixPokemonsMemoViewController_, @"viewController", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"PokemonDetail_Size.png", @"image", sixPokemonsSkillViewController_, @"viewController", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"PokemonDetail_Size.png", @"image", sixPokemonsMoveViewController_, @"viewController", nil],
                        nil];
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
  [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainViewBackgroundBlack.png"]]];
  
  // Constants
  CGFloat const imageHeight       = 150.0f;
  CGFloat const imageWidth        = 150.0f;
  
  CGFloat const labelHeight       = 30.0f;
  CGFloat const labelWidth        = 80.0f;
  
  CGFloat const nameLabelWidth    = 300.0f - imageWidth;
  CGFloat const nameLabelHeight   = imageHeight / 2 - labelHeight;
  
  CGRect  const imageContainerFrame = CGRectMake(10.0f, 10.0f + kTopBarHeight, imageWidth, imageHeight);
  CGRect  const IDViewFrame         = CGRectMake(imageWidth + 20.0f, 50.0f + kTopBarHeight, 300.0f - imageWidth, imageHeight - 50.0f);
  
  // Base information for Pokemon
  Pokemon * pokemonBaseInfo = self.pokemon.pokemon;
  
  ///Left Image View
  UIView * imageContainer = [[UIView alloc] initWithFrame:imageContainerFrame];
  [imageContainer setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"PokemonDetailImageBackground.png"]]];
  [imageContainer setOpaque:NO];
  
  // Image
  UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imageWidth, imageHeight)];
  [imageView setUserInteractionEnabled:YES];
  [imageView setContentMode:UIViewContentModeCenter];
  [imageView setBackgroundColor:[UIColor clearColor]];
  [imageView setImage:pokemonBaseInfo.image];
  
  [imageContainer addSubview:imageView];
  [imageView release];
  [self.view addSubview:imageContainer];
  [imageContainer release];
  
  
  ///Right ID View
  UIView * IDView = [[UIView alloc] initWithFrame:IDViewFrame];
  
  // ID
  PokemonInfoLabelView * idLabelView = [[PokemonInfoLabelView alloc]
                                        initWithFrame:CGRectMake(0.0f, 0.0f, labelWidth / 2, labelHeight)
                                        hasValueLabel:NO];
  [idLabelView.name setText:[NSString stringWithFormat:@"#%.3d", [pokemonBaseInfo.sid intValue]]];
  [idLabelView.name.layer setShadowColor:[UIColor blackColor].CGColor];
  [idLabelView.name.layer setShadowOpacity:1.0f];
  [idLabelView.name.layer setShadowOffset:CGSizeMake(-1.0f, -1.0f)];
  [idLabelView.name.layer setShadowRadius:0.0f];
  [IDView addSubview:idLabelView];
  [idLabelView release];
  
  // Name
  UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, labelHeight, nameLabelWidth, nameLabelHeight)];
  [nameLabel setBackgroundColor:[UIColor clearColor]];
  [nameLabel setTextColor:[GlobalRender textColorOrange]];
  [nameLabel setFont:[GlobalRender textFontBoldInSizeOf:20.0f]];
  [nameLabel setText:NSLocalizedString(([NSString stringWithFormat:@"PMSName%.3d", [pokemonBaseInfo.sid intValue]]), nil)];
  [nameLabel.layer setShadowColor:[UIColor blackColor].CGColor];
  [nameLabel.layer setShadowOpacity:1.0f];
  [nameLabel.layer setShadowOffset:CGSizeMake(-1.0f, -1.0f)];
  [nameLabel.layer setShadowRadius:0.0f];
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
  
  self.pokemon = nil;
  self.sixPokemonsInfoViewController  = nil;
  self.sixPokemonsMemoViewController  = nil;
  self.sixPokemonsSkillViewController = nil;
  self.sixPokemonsMoveViewController  = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
