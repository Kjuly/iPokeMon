//
//  GameMenuSixPokemonViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonSelectionViewController.h"

#import "GlobalConstants.h"
#import "GlobalNotificationConstants.h"
//#import "TrainerController.h"
#import "WildPokemon+DataController.h"
#import "Pokemon.h"
#import "PokemonDetailTabViewController.h"

#import <QuartzCore/QuartzCore.h>


@interface PokemonSelectionViewController () {
 @private
  UIButton  * pokemonSelectionButton_; // Button to show Pokemon Selection View
  NSInteger   currOpeningUnitViewTag_;
  NSInteger   currSelectedPokemon_;
  UIView    * backgroundView_;
  NSArray   * pokemons_;
  PokemonDetailTabViewController     * pokemonDetailTabViewController_;
  CAAnimationGroup                   * animationGroupForNotReplacing_;
}

@property (nonatomic, retain) UIButton  * pokemonSelectionButton;
@property (nonatomic, assign) NSInteger   currOpeningUnitViewTag;
@property (nonatomic, assign) NSInteger   currSelectedPokemon;
@property (nonatomic, retain) UIView    * backgroundView;
@property (nonatomic, copy)   NSArray   * pokemons;
@property (nonatomic, retain) PokemonDetailTabViewController * pokemonDetailTabViewController;
@property (nonatomic, retain) CAAnimationGroup               * animationGroupForNotReplacing;

- (void)loadPokemonSelectionViewAnimated:(BOOL)animated;
- (void)showPokemonSelectionView:(id)sender;

@end


@implementation PokemonSelectionViewController

@synthesize selectedPokemonUID               = selectedPokemonUID_;
@synthesize isSelectedPokemonInfoViewOpening = isSelectedPokemonInfoViewOpening_;

@synthesize pokemonSelectionButton = pokemonSelectionButton_;
@synthesize currOpeningUnitViewTag = currOpeningUnitViewTag_;
@synthesize currSelectedPokemon    = currSelectedPokemon_;
@synthesize backgroundView         = backgroundView_;
@synthesize pokemons               = pokemons_;
@synthesize pokemonDetailTabViewController = pokemonDetailTabViewController_;
@synthesize animationGroupForNotReplacing  = animationGroupForNotReplacing_;

- (void)dealloc
{
  [pokemonSelectionButton_         release];
  [backgroundView_                 release];
  [pokemons_                       release];
  [pokemonDetailTabViewController_ release];
  
  self.pokemonDetailTabViewController = nil;
  self.animationGroupForNotReplacing  = nil;
  
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
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
  
  // Constants
  CGRect pokemonSelectionButtonFrame = CGRectMake((kViewWidth - kCenterMainButtonSize) / 2,
                                                  (kViewHeight - kCenterMainButtonSize) / 2,
                                                  kCenterMainButtonSize,
                                                  kCenterMainButtonSize);
  
  // Button to show Pokemon choosing view
  pokemonSelectionButton_ = [[UIButton alloc] initWithFrame:pokemonSelectionButtonFrame];
  [pokemonSelectionButton_ setAlpha:1.f];
  [pokemonSelectionButton_ setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"]
                                     forState:UIControlStateNormal];
  [pokemonSelectionButton_ setImage:[UIImage imageNamed:@"ButtonIconUnknow.png"] forState:UIControlStateNormal];
  [pokemonSelectionButton_ addTarget:self
                              action:@selector(showPokemonSelectionView:)
                    forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:pokemonSelectionButton_];
  
  // Background view
  backgroundView_ = [[UIView alloc] initWithFrame:self.view.frame];
  [backgroundView_ setBackgroundColor:[UIColor blackColor]];
  [backgroundView_ setAlpha:0.f];
  [self.view addSubview:backgroundView_];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Basic Setting
  selectedPokemonUID_     = 0;
  currOpeningUnitViewTag_ = 0;
  currSelectedPokemon_    = 0;
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.pokemonSelectionButton         = nil;
  self.backgroundView                 = nil;
  self.pokemons                       = nil;
  self.pokemonDetailTabViewController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - GameMenuSixPokemonsUnitViewDelegate

- (void)checkUnit:(id)sender
{
  if (self.currOpeningUnitViewTag) {
    GameMenuSixPokemonsUnitView * unitView =
      (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:self.currOpeningUnitViewTag];
    [unitView cancelUnitAnimated:YES];
    unitView = nil;
  }
  self.currOpeningUnitViewTag = ((UIButton *)sender).tag;
}

- (void)resetUnit {
  self.currOpeningUnitViewTag = 0;
}

// Button action to confirm selected Pokemon
- (void)confirm:(id)sender {
  [self unloadPokemonSelectionViewAnimated:YES];
  
  self.currSelectedPokemon = ((UIButton *)sender).tag;
  WildPokemon * pokemon = [self.pokemons objectAtIndex:(self.currSelectedPokemon - 1)];
  self.selectedPokemonUID = [pokemon.uid intValue];
  [self.pokemonSelectionButton setImage:pokemon.pokemon.image forState:UIControlStateNormal];
}

// Button action to open |pokemonDetailTabViewController|'s view
- (void)openInfoView:(id)sender
{
  WildPokemon * pokemon = [self.pokemons objectAtIndex:((UIButton *)sender).tag - 1];
  NSInteger pokemonID = [pokemon.sid intValue];
  
  PokemonDetailTabViewController * pokemonDetailTabViewController =
    [[PokemonDetailTabViewController alloc] initWithPokemonID:pokemonID withTopbar:NO];
  self.pokemonDetailTabViewController = pokemonDetailTabViewController;
  [pokemonDetailTabViewController release];
  
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

- (void)initWithPokemonsWithUID:(NSArray *)pokemonsUID {
  self.pokemons = [WildPokemon queryPokemonsWithID:pokemonsUID fetchLimit:3];
  
  NSInteger pokemonsCount = [self.pokemons count];
  CGFloat   buttonSize    = kCenterMainButtonSize;
  CGFloat   buttonDelta   = buttonSize + 10.f;
  CGRect    originFrame   =
    CGRectMake(0.f, kViewHeight - buttonSize / 2 - (pokemonsCount + 1) * buttonDelta, kViewWidth, buttonSize);
  
  //
  // TODO:
  //   Every time they'll be created, no need actually
  //
  for (int i = 0; i < pokemonsCount;) {
    originFrame.origin.y += buttonDelta;
    WildPokemon * pokemon = [self.pokemons objectAtIndex:i];
    GameMenuSixPokemonsUnitView * gameMenuSixPokemonsUnitView =
      [[GameMenuSixPokemonsUnitView alloc] initWithFrame:originFrame image:pokemon.pokemon.image tag:++i];
    gameMenuSixPokemonsUnitView.delegate = self;
    [gameMenuSixPokemonsUnitView setTag:i];
    [gameMenuSixPokemonsUnitView setAlpha:0.f];
    if (self.currSelectedPokemon == i)
      [gameMenuSixPokemonsUnitView setAsCurrentBattleOne:YES];
    [self.view addSubview:gameMenuSixPokemonsUnitView];
    [gameMenuSixPokemonsUnitView release];
    pokemon = nil;
  }
  
  // Basic Setting
  self.isSelectedPokemonInfoViewOpening = NO;
}

// Unload view
- (void)unloadPokemonSelectionViewAnimated:(BOOL)animated {
  // Post notification to |NewbieGuideViewController| to show |confirmButton_|
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNShowConfirmButtonInNebbieGuide object:self userInfo:nil];
  
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
  if (self.currOpeningUnitViewTag != 0) {
    GameMenuSixPokemonsUnitView * unitView
    = (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:self.currOpeningUnitViewTag];
    [unitView cancelUnitAnimated:animated];
    unitView = nil;
    self.currOpeningUnitViewTag = 0;
  }
  
  if (! animated) { animation(); }
  else [UIView animateWithDuration:.3f
                             delay:(self.currOpeningUnitViewTag != 0 ? .6f : 0.f)
                           options:UIViewAnimationCurveEaseInOut
                        animations:animation
                        completion:nil];
}

// Unload selected Pokemon's info view
- (void)unloadSelcetedPokemonInfoView {
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
- (void)loadPokemonSelectionViewAnimated:(BOOL)animated {
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
      [animations release];
    }
    
    for (int i = [self.pokemons count]; i > 0; --i) {
      GameMenuSixPokemonsUnitView * unitView = (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:i];
      if (self.currSelectedPokemon == i) [unitView setAsCurrentBattleOne:YES];
      else                               [unitView setAsCurrentBattleOne:NO];
      [unitView setAlpha:1.f];
      [unitView.layer addAnimation:self.animationGroupForNotReplacing forKey:@"animationToShow"];
      unitView = nil;
    }
  };
  
  [self.pokemonSelectionButton setAlpha:0.f];
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationCurveEaseInOut
                   animations:^{ [self.backgroundView setAlpha:.85f]; }
                   completion:^(BOOL finished) { if (finished) animationsToShowPokemons(); }];
}

// Show Pokemon Selection view
- (void)showPokemonSelectionView:(id)sender {
  NSLog(@"|%@| - |showPokemonSelectionView:|", [self class]);
  // Post notification to |NewbieGuideViewController| to hide |confirmButton_|
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNHideConfirmButtonInNebbieGuide object:self userInfo:nil];
  [self loadPokemonSelectionViewAnimated:YES];
}

@end
