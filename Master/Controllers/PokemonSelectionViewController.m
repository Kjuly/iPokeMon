//
//  GameMenuSixPokemonViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 3/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonSelectionViewController.h"

#import "WildPokemonController.h"
#import "WildPokemon+DataController.h"
#import "Pokemon.h"
#import "PokemonDetailTabViewController.h"

#import <QuartzCore/QuartzCore.h>


@interface PokemonSelectionViewController () {
 @private
  UIButton * pokemonSelectionButton_; // Button to show Pokemon Selection View
  UIView   * backgroundView_;
  
  NSArray                        * pokemons_;
  PokemonDetailTabViewController * pokemonDetailTabViewController_;
  CAAnimationGroup               * animationGroupForNotReplacing_;
  
  NSInteger   currOpeningUnitViewTag_;
  NSInteger   currSelectedPokemon_;
}

@property (nonatomic, strong) UIButton * pokemonSelectionButton;
@property (nonatomic, strong) UIView   * backgroundView;

@property (nonatomic, copy)   NSArray                        * pokemons;
@property (nonatomic, strong) PokemonDetailTabViewController * pokemonDetailTabViewController;
@property (nonatomic, strong) CAAnimationGroup               * animationGroupForNotReplacing;

- (void)_loadPokemonSelectionViewAnimated:(BOOL)animated;
- (void)_showPokemonSelectionView:(id)sender;

@end


@implementation PokemonSelectionViewController

@synthesize selectedPokemonSID               = selectedPokemonSID_;
@synthesize isSelectedPokemonInfoViewOpening = isSelectedPokemonInfoViewOpening_;

@synthesize pokemonSelectionButton = pokemonSelectionButton_;
@synthesize backgroundView         = backgroundView_;

@synthesize pokemons                       = pokemons_;
@synthesize pokemonDetailTabViewController = pokemonDetailTabViewController_;
@synthesize animationGroupForNotReplacing  = animationGroupForNotReplacing_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
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
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Basic Setting
  selectedPokemonSID_     = 0;
  currOpeningUnitViewTag_ = 0;
  currSelectedPokemon_    = 0;
  
  // Constants
  CGRect pokemonSelectionButtonFrame = CGRectMake((kViewWidth - kCenterMainButtonSize) / 2,
                                                  (kViewHeight - kCenterMainButtonSize) / 2,
                                                  kCenterMainButtonSize,
                                                  kCenterMainButtonSize);
  
  // Button to show Pokemon choosing view
  pokemonSelectionButton_ = [[UIButton alloc] initWithFrame:pokemonSelectionButtonFrame];
  [pokemonSelectionButton_ setAlpha:1.f];
  [pokemonSelectionButton_ setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal]
                                     forState:UIControlStateNormal];
  [pokemonSelectionButton_ setImage:[UIImage imageNamed:kPMINMainButtonUnknowOpposite] forState:UIControlStateNormal];
  [pokemonSelectionButton_ addTarget:self
                              action:@selector(_showPokemonSelectionView:)
                    forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:pokemonSelectionButton_];
  
  // Background view
  backgroundView_ = [[UIView alloc] initWithFrame:self.view.frame];
  [backgroundView_ setBackgroundColor:[UIColor blackColor]];
  [backgroundView_ setAlpha:0.f];
  [self.view addSubview:backgroundView_];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.pokemonSelectionButton = nil;
  self.backgroundView         = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - GameMenuSixPokemonsUnitViewDelegate

- (void)checkUnit:(id)sender
{
  if (currOpeningUnitViewTag_) {
    GameMenuSixPokemonsUnitView * unitView =
      (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:currOpeningUnitViewTag_];
    [unitView cancelUnitAnimated:YES];
    unitView = nil;
  }
  currOpeningUnitViewTag_ = ((UIButton *)sender).tag;
}

- (void)resetUnit
{
  currOpeningUnitViewTag_ = 0;
}

// Button action to confirm selected Pokemon
- (void)confirm:(id)sender
{
  [self unloadPokemonSelectionViewAnimated:YES];
  
  currSelectedPokemon_ = ((UIButton *)sender).tag;
  WildPokemon * pokemon = [self.pokemons objectAtIndex:(currSelectedPokemon_ - 1)];
  self.selectedPokemonSID = [pokemon.sid intValue];
  [self.pokemonSelectionButton setImage:pokemon.pokemon.image forState:UIControlStateNormal];
}

// Button action to open |pokemonDetailTabViewController|'s view
- (void)openInfoView:(id)sender
{
  WildPokemon * pokemon = [self.pokemons objectAtIndex:((UIButton *)sender).tag - 1];
  NSInteger pokemonSID = [pokemon.sid intValue];
  
  PokemonDetailTabViewController * pokemonDetailTabViewController =
    [[PokemonDetailTabViewController alloc] initWithPokemonSID:pokemonSID withTopbar:NO];
  self.pokemonDetailTabViewController = pokemonDetailTabViewController;
  
  [self.view addSubview:self.pokemonDetailTabViewController.view];
  __block CGRect viewFrame = CGRectMake(0.f, kViewHeight, kViewWidth, kViewHeight);
  [self.pokemonDetailTabViewController.view setFrame:viewFrame];
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     viewFrame.origin.y = 0.f;
                     [self.pokemonDetailTabViewController.view setFrame:viewFrame];
                   }
                   completion:nil];
  self.isSelectedPokemonInfoViewOpening = YES;
}

#pragma mark - Public Methods

// Initialize the Pokemons' data for selection
- (void)initWithPokemonsWithSIDs:(NSArray *)pokemonSIDs
{
  NSInteger pokemonsCount = [pokemonSIDs count];
  self.pokemons = [WildPokemon queryUniquePokemonsWithSIDs:pokemonSIDs
                                                fetchLimit:pokemonsCount];
  
  // If fetched Pokemons number is less than |pokemonsCount|,
  //   add new Pokemons to |WildPokemon| with the |pokemonSIDs|
  //   and set added Pokemons as the |pokemons|
  if ([self.pokemons count] < pokemonsCount || self.pokemons == nil) {
    NSLog(@"!!! |[self.pokemons count] < pokemonsCount|");
    self.pokemons = [[WildPokemonController sharedInstance] pokemonsAddedWithSIDs:pokemonSIDs];
  }
  
  // If the number of |pokemons_| is still less than |pokemonsCount|, throw an ERROR
  if ([self.pokemons count] < pokemonsCount)
    NSLog(@"!!!ERROR: pokemons < [pokemonSIDs count]");
  
  // Constants
  CGFloat buttonSize  = kCenterMainButtonSize;
  CGFloat buttonDelta = buttonSize + 10.f;
  CGRect  originFrame = CGRectMake(0.f, kViewHeight - buttonSize * .5f - (pokemonsCount + 1) * buttonDelta,
                                   kViewWidth, buttonSize);
  
  // Create Pokemon unit views
  for (int i = 0; i < pokemonsCount;) {
    originFrame.origin.y += buttonDelta;
    WildPokemon * pokemon = [self.pokemons objectAtIndex:i];
    GameMenuSixPokemonsUnitView * unitView = (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:++i];
    if (unitView == nil) {
      NSLog(@"unitView == nil, create new one...");
      unitView = [[GameMenuSixPokemonsUnitView alloc] initWithFrame:originFrame image:pokemon.pokemon.image tag:i];
      unitView.delegate = self;
      [unitView setTag:i];
      [unitView setAlpha:0.f];
      [self.view addSubview:unitView];
    }
    
    // Set as normal for |unitView|
    [unitView setAsNormal];
    
    // Set as current selecetd one
    if (currSelectedPokemon_ == i)
      [unitView setAsCurrentBattleOne:YES];
    
    unitView = nil;
    pokemon  = nil;
  }
  
  // Basic Setting
  self.isSelectedPokemonInfoViewOpening = NO;
}

// Unload view
- (void)unloadPokemonSelectionViewAnimated:(BOOL)animated
{
  // Post notification to |NewbieGuideViewController| to show |confirmButton_|
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNShowConfirmButtonInNebbieGuide
                                                      object:self
                                                    userInfo:nil];
  
  [self.pokemonSelectionButton setAlpha:1.f];
  void (^animation)() = ^(){
    for (int i = [self.pokemons count]; i > 0; --i) {
      GameMenuSixPokemonsUnitView * unitView = (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:i];
      [unitView setAlpha:0.f];
      unitView = nil;
    }
    [self.backgroundView setAlpha:0.f];
  };
  
  // If there's a unit view opening, close it first
  if (currOpeningUnitViewTag_ != 0) {
    GameMenuSixPokemonsUnitView * unitView;
    unitView = (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:currOpeningUnitViewTag_];
    [unitView cancelUnitAnimated:animated];
    unitView = nil;
    currOpeningUnitViewTag_ = 0;
  }
  
  if (! animated) { animation(); }
  else [UIView animateWithDuration:.3f
                             delay:(currOpeningUnitViewTag_ != 0 ? .6f : 0.f)
                           options:(UIViewAnimationOptions)UIViewAnimationCurveEaseInOut
                        animations:animation
                        completion:nil];
}

// Unload selected Pokemon's info view
- (void)unloadSelcetedPokemonInfoView
{
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     CGRect viewFrame = self.pokemonDetailTabViewController.view.frame;
                     viewFrame.origin.y = kViewHeight;
                     [self.pokemonDetailTabViewController.view setFrame:viewFrame];
                   }
                   completion:^(BOOL finished) {
                     [self.pokemonDetailTabViewController.view removeFromSuperview];
                     self.pokemonDetailTabViewController = nil;
                     self.isSelectedPokemonInfoViewOpening = NO;
                   }];
}

#pragma mark - Private Methods

// Load view
- (void)_loadPokemonSelectionViewAnimated:(BOOL)animated
{
  void (^animationsToShowPokemons)() = ^(){
    if (self.animationGroupForNotReplacing == nil) {
      CGFloat duration = .6f;
      CAKeyframeAnimation * animationScale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
      animationScale.duration = duration;
      animationScale.values   = [NSArray arrayWithObjects:[NSNumber numberWithFloat:.8f],
                                                          [NSNumber numberWithFloat:1.2f],
                                                          [NSNumber numberWithFloat:1.f], nil];
      animationScale.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.f],
                                                          [NSNumber numberWithFloat:.3f],
                                                          [NSNumber numberWithFloat:duration], nil];
      animationScale.timingFunctions = [NSArray arrayWithObjects:
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], nil];
      
      CABasicAnimation * animationFade = [CABasicAnimation animationWithKeyPath:@"opacity"];
      animationFade.duration       = duration * .4f;
      animationFade.fromValue      = [NSNumber numberWithFloat:0.f];
      animationFade.toValue        = [NSNumber numberWithFloat:1.f];
      animationFade.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
      animationFade.fillMode       = kCAFillModeForwards;
      
      self.animationGroupForNotReplacing = [CAAnimationGroup animation];
      self.animationGroupForNotReplacing.delegate = self;
      self.animationGroupForNotReplacing.duration = duration;
      NSArray * animations = [[NSArray alloc] initWithObjects:animationScale, animationFade, nil];
      [self.animationGroupForNotReplacing setAnimations:animations];
    }
    
    for (int i = [self.pokemons count]; i > 0; --i) {
      GameMenuSixPokemonsUnitView * unitView = (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:i];
      if (currSelectedPokemon_ == i) [unitView setAsCurrentBattleOne:YES];
      else                               [unitView setAsCurrentBattleOne:NO];
      [unitView setAlpha:1.f];
      [unitView.layer addAnimation:self.animationGroupForNotReplacing forKey:@"animationToShow"];
      unitView = nil;
    }
  };
  
  [self.pokemonSelectionButton setAlpha:0.f];
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:(UIViewAnimationOptions)UIViewAnimationCurveEaseInOut
                   animations:^{ [self.backgroundView setAlpha:.85f]; }
                   completion:^(BOOL finished) { if (finished) animationsToShowPokemons(); }];
}

// Show Pokemon Selection view
- (void)_showPokemonSelectionView:(id)sender
{
  // Post notification to |NewbieGuideViewController| to hide |confirmButton_|
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNHideConfirmButtonInNebbieGuide object:self userInfo:nil];
  [self _loadPokemonSelectionViewAnimated:YES];
}

@end
