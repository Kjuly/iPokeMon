//
//  GameMenuSixPokemonViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuSixPokemonsViewController.h"

#import "GlobalConstants.h"
#import "GameMenuSixPokemonsUnitView.h"
//#import "GameMenuSixPokemonsUnitViewController.h"

@interface GameMenuSixPokemonsViewController () {
 @private
  NSInteger pokemonCount_;
  UIView  * backgroundView_;
}

@property (nonatomic, assign) NSInteger pokemonCount;
@property (nonatomic, retain) UIView  * backgroundView;

@end


@implementation GameMenuSixPokemonsViewController

@synthesize pokemonCount   = pokemonCount_;
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

#pragma mark - GameMenuSixPokemonsUnitViewDelegate

- (void)confirm:(id)sender
{
  
}

- (void)openInfoView:(id)sender
{
  
}

#pragma mark - Public Methods

- (void)loadSixPokemons
{
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationCurveEaseInOut
                   animations:^{
                     [self.backgroundView setAlpha:.75f];
                     CGFloat buttonSize = 60.f;
                     CGRect originFrame = CGRectMake((kViewWidth - buttonSize) / 2,
                                                     kViewHeight - buttonSize / 2,
                                                     buttonSize,
                                                     buttonSize);
                     for (int i = self.pokemonCount; i > 0; --i) {
                       GameMenuSixPokemonsUnitView * unitView
                       = (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:i];
                       originFrame.origin.y -= 70.f;
                       [unitView setAlpha:1.f];
                       [unitView setFrame:originFrame];
                       unitView = nil;
                     }
                   }
                   completion:nil];
}

- (void)unloadSixPokemons
{
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationCurveEaseInOut
                   animations:^{
                     CGFloat buttonSize = 60.f;
                     CGRect originFrame = CGRectMake((kViewWidth - buttonSize) / 2,
                                                     kViewHeight - buttonSize / 2,
                                                     buttonSize,
                                                     buttonSize);
                     for (int i = self.pokemonCount; i > 0; --i) {
                       GameMenuSixPokemonsUnitView * unitView
                       = (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:i];
                       [unitView setFrame:originFrame];
                       [unitView setAlpha:0.f];
                       unitView = nil;
                     }
                     [self.backgroundView setAlpha:0.f];
                   }
                   completion:^(BOOL finished) {
                     [self.view removeFromSuperview];
                   }];
}

#pragma mark - Private Methods

- (void)initWithPokemonCount:(NSInteger)pokemonCount
{
  pokemonCount_ = pokemonCount; // Min: 1, Max: 6
  CGFloat buttonSize = 60.f;
  CGRect originFrame = CGRectMake((kViewWidth - buttonSize) / 2,
                                  kViewHeight - buttonSize / 2,
                                  buttonSize,
                                  buttonSize);
  
  for (int i = 0; i < self.pokemonCount;) {
    NSLog(@"!");
    GameMenuSixPokemonsUnitView * gameMenuSixPokemonsUnitView
    = [[GameMenuSixPokemonsUnitView alloc] initWithFrame:originFrame tag:++i];
    [gameMenuSixPokemonsUnitView setTag:i];
    [gameMenuSixPokemonsUnitView setAlpha:0.f];
    [self.view addSubview:gameMenuSixPokemonsUnitView];
    [gameMenuSixPokemonsUnitView release];
  }
}

@end
