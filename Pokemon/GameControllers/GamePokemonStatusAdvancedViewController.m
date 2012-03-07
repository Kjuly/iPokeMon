//
//  GamePokemonStatusViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/7/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GamePokemonStatusAdvancedViewController.h"

#import "GlobalRender.h"
#import "PokemonHPBar.h"
#import "PokemonEXPBar.h"


@interface GamePokemonStatusAdvancedViewController () {
 @private
  UILabel  * pokemonHP_;
  BOOL       isStatusBarOpening_;
  UIButton * transparentButton_;
}

@property (nonatomic, retain) UILabel  * pokemonHP;
@property (nonatomic, assign) BOOL       isStatusBarOpening;
@property (nonatomic, retain) UIButton * transparentButton;

- (void)toggleStatusBar;

@end


@implementation GamePokemonStatusAdvancedViewController

@synthesize pokemonEXPBar      = pokemonEXPBar_;
@synthesize pokemonHP          = pokemonHP_;
@synthesize isStatusBarOpening = isStatusBarOpening_;
@synthesize transparentButton  = transparentButton_;

- (void)dealloc
{
  [pokemonEXPBar_     release];
  [pokemonHP_         release];
  [transparentButton_ release];
  
  [super dealloc];
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
  
  // Constants
  CGRect backgroundViewFrame = CGRectMake(100.f, 0.f, 280.f, 65.f);
  CGRect pokemonGenderFrame  = CGRectMake(10.f, 5.f, 26.f, 26.f);
  CGRect pokemonNameFrame    = CGRectMake(36.f, 5.f, 130.f, 32.f);
  CGRect pokemonLevelFrame   = CGRectMake(210.f, 6.f, 70.f, 32.f);
  CGRect pokemonHPFrame      = CGRectMake(210.f, 28.f, 70.f, 32.f);
  CGRect pokemonHPBarFrame   = CGRectMake(10.f, 36.f, 150.f, 13.f);
  CGRect pokemonEXPBarFrame  = CGRectMake(10.f, 51.f, 150.f, 6.f);
  
  // Reset |backgroundView_|
  [backgroundView_ setFrame:backgroundViewFrame];
  [backgroundView_ setImage:[UIImage imageNamed:@"GamePokemonStatusAdvancedBackground.png"]];
  [backgroundView_ setOpaque:NO];
  [backgroundView_ setUserInteractionEnabled:YES];
  
  // Reset gender, name, Lv., HPBar's frame
  [pokemonGender_ setFrame:pokemonGenderFrame];
  [pokemonName_ setFrame:pokemonNameFrame];
  [pokemonHPBar_ setFrame:pokemonHPBarFrame];
  [pokemonLevel_ setFrame:pokemonLevelFrame];
  [pokemonLevel_ setTextColor:[GlobalRender textColorTitleWhite]];
  
  // Add HP
  pokemonHP_ = [[UILabel alloc] initWithFrame:pokemonHPFrame];
  [pokemonHP_ setBackgroundColor:[UIColor clearColor]];
  [pokemonHP_ setTextColor:[GlobalRender textColorTitleWhite]];
  [pokemonHP_ setFont:[GlobalRender textFontBoldInSizeOf:14.f]];
  [backgroundView_ addSubview:pokemonHP_];
  
  // Add Exp Bar
  pokemonEXPBar_ = [[PokemonEXPBar alloc] initWithFrame:pokemonEXPBarFrame EXP:50.f EXPMax:100.f];
  [backgroundView_ addSubview:pokemonEXPBar_];
  
  // Add a transparent button for toggling status view
  transparentButton_ = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 280.f, 65.f)];
  [transparentButton_ addTarget:self action:@selector(toggleStatusBar) forControlEvents:UIControlEventTouchUpInside];
  [self.backgroundView addSubview:transparentButton_];
  isStatusBarOpening_ = NO;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [pokemonName_ setText:@"Pokemon Name"];
  [pokemonGender_ setImage:[UIImage imageNamed:
                            1 ? @"IconPokemonGenderM.png" : @"IconPokemonGenderF.png"]];
  [pokemonLevel_ setText:@"12"];
  [pokemonHP_ setText:[NSString stringWithFormat:@"%d / %d", 123, 125]];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.pokemonEXPBar     = nil;
  self.pokemonHP         = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

- (void)toggleStatusBar
{
  CGRect backgroundViewFrame = CGRectMake(0.f, 0.f, 280.f, 65.f);
  if (self.isStatusBarOpening)
    backgroundViewFrame.origin.x += 100.f;
  
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationCurveEaseInOut
                   animations:^{
                     [self.backgroundView setFrame:backgroundViewFrame];
                   }
                   completion:nil];
  self.isStatusBarOpening = ! self.isStatusBarOpening;
}

@end
