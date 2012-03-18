//
//  GamePokemonStatusViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/7/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GamePokemonStatusViewController.h"

#import "GlobalRender.h"
#import "GlobalNotificationConstants.h"


@interface GamePokemonStatusViewController ()

- (void)showStatus:(NSNotification *)notification;

@end


@implementation GamePokemonStatusViewController

@synthesize pokemonHPBar   = pokemonHPBar_;
@synthesize pokemonName    = pokemonName_;
@synthesize pokemonLevel   = pokemonLevel_;
@synthesize pokemonGender  = pokemonGender_;

- (void)dealloc
{
  [pokemonHPBar_   release];
  [pokemonName_    release];
  [pokemonLevel_   release];
  [pokemonGender_  release];
  
  // Remove observer
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNShowPokemonStatus object:nil];
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
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 64.f)];
  self.view = view;
  [view release];
  [self.view setBackgroundColor:[UIColor whiteColor]];
  [self.view setAlpha:1.f];
  
  // Constants
  CGRect pokemonGenderFrame = CGRectMake(10.f, 22.f, 20.f, 20.f);
  CGRect pokemonNameFrame   = CGRectMake(30.f, 22.f, 150.f, 20.f);
  CGRect pokemonLevelFrame  = CGRectMake(180.f, 22.f, 70.f, 20.f);
  CGRect pokemonHPBarFrame  = CGRectMake(0.f, 56.f, 320.f, 8.f);
  
  // Pokemon Gender
  pokemonGender_ = [[UIImageView alloc] initWithFrame:pokemonGenderFrame];
  [pokemonGender_ setBackgroundColor:[UIColor clearColor]];
  [self.view addSubview:pokemonGender_];
  
  // Name
  pokemonName_ = [[UILabel alloc] initWithFrame:pokemonNameFrame];
  [pokemonName_ setBackgroundColor:[UIColor clearColor]];
  [pokemonName_ setTextColor:[GlobalRender textColorOrange]];
  [pokemonName_ setFont:[GlobalRender textFontBoldInSizeOf:14.f]];
  [self.view addSubview:pokemonName_];
  
  // Lv.
  pokemonLevel_ = [[UILabel alloc] initWithFrame:pokemonLevelFrame];
  [pokemonLevel_ setBackgroundColor:[UIColor clearColor]];
  [pokemonLevel_ setTextColor:[UIColor blackColor]];
  [pokemonLevel_ setFont:[GlobalRender textFontBoldInSizeOf:14.f]];
  [self.view addSubview:pokemonLevel_];
  
  // HP bar
  pokemonHPBar_ = [[PokemonHPBar alloc] initWithFrame:pokemonHPBarFrame];
  [self.view addSubview:pokemonHPBar_];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Add observer for notification to show status view
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(showStatus:)
                                               name:kPMNShowPokemonStatus
                                             object:nil];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.pokemonHPBar   = nil;
  self.pokemonName    = nil;
  self.pokemonLevel   = nil;
  self.pokemonGender  = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

// Update Pokemon's Status
- (void)updatePokemonStatus:(NSDictionary *)statusInfo
{
  if ([statusInfo objectForKey:@"name"])
    [self.pokemonName setText:[statusInfo objectForKey:@"name"]];
  if ([statusInfo objectForKey:@"gender"])
    [self.pokemonGender setImage:[UIImage imageNamed:[[statusInfo objectForKey:@"gender"] intValue]
                                  ? @"IconPokemonGenderM.png" : @"IconPokemonGenderF.png"]];
  if ([statusInfo objectForKey:@"level"])
    [self.pokemonLevel setText:[NSString stringWithFormat:@"Lv.%d", [[statusInfo objectForKey:@"level"] intValue]]];
  if ([statusInfo objectForKey:@"HP"])
    [self.pokemonHPBar updateHPBarWithHP:[[statusInfo objectForKey:@"HP"] intValue]];
  if ([statusInfo objectForKey:@"HPMax"])
    [self.pokemonHPBar updateHpBarWithHPMax:[[statusInfo objectForKey:@"HPMax"] intValue]];
}

- (void)prepareForNewScene {} // Overwired by child

- (void)reset {
  [self.view setAlpha:0.f];
}

#pragma mark - Private Methods

- (void)showStatus:(NSNotification *)notification
{
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationCurveEaseInOut
                   animations:^{
                     [self.view setAlpha:1.f];
                   }
                   completion:nil];
}

@end
