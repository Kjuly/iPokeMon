//
//  GameMenuSixPokemonViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuSixPokemonsViewController.h"

#import "GlobalConstants.h"
#import "GameMenuSixPokemonsUnitViewController.h"

@interface GameMenuSixPokemonsViewController () {
 @private
  UIView * backgroundView_;
}

@property (nonatomic, retain) UIView * backgroundView;

- (void)initSixPokemonsButton;

@end


@implementation GameMenuSixPokemonsViewController

@synthesize backgroundView = backgroundView_;

- (void)dealloc
{
  [backgroundView_ release];
  
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
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
  self.view = view;
  [view release];
  
  backgroundView_ = [[UIView alloc] initWithFrame:self.view.frame];
  [backgroundView_ setBackgroundColor:[UIColor blackColor]];
  [backgroundView_ setAlpha:0.f];
  [self.view addSubview:backgroundView_];
  
  [self initSixPokemonsButton];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.backgroundView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

- (void)loadSixPokemons
{
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationCurveEaseInOut
                   animations:^{
                     [self.backgroundView setAlpha:.75f];
                   }
                   completion:nil];
}

- (void)unloadSixPokemons
{
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationCurveEaseInOut
                   animations:^{
                     [self.backgroundView setAlpha:0.f];
                   }
                   completion:^(BOOL finished) {
                     [self.view removeFromSuperview];
                   }];
}

#pragma mark - Private Methods

- (void)initSixPokemonsButton
{
//  CGRect originRect = CGRectMake((kViewWidth - kCenterMenuSize) / 2,
//                                 kViewHeight - kCenterMenuSize / 2,
//                                 kCenterMenuSize,
//                                 kCenterMenuSize);
  
//  for (int i = 0; i < 6; ++i) {
    
//  }
  GameMenuSixPokemonsUnitViewController * gameMenuSixPokemonsUnitViewController
  = [[GameMenuSixPokemonsUnitViewController alloc] init];
  [self.view addSubview:gameMenuSixPokemonsUnitViewController.view];
//  [gameMenuSixPokemonsUnitViewController release];
}

@end
