//
//  GameMenuSixPokemonViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuSixPokemonsViewController.h"

#import "GlobalConstants.h"
#import "GlobalNotificationConstants.h"
#import "TrainerController.h"
#import "SixPokemonsDetailTabViewController.h"

#import <QuartzCore/QuartzCore.h>


@interface GameMenuSixPokemonsViewController () {
 @private
  TrainerController * trainer_;
  BOOL        isForReplacing_;         // If it is YES, when |confirm|, replace pokemon, otherwise, use item
  NSInteger   currOpeningUnitViewTag_;
  UIView    * backgroundView_;
  NSArray   * sixPokemons_;
  NSString  * sixPokemonsUID_;        // Mark for six PMs UID, if changed, reload PMs
  SixPokemonsDetailTabViewController * sixPokemonsDetailTabViewController_;
  CAAnimationGroup                   * animationGroupForNotReplacing_;
  UIButton                           * cancelButton_;
}

@property (nonatomic, retain) TrainerController * trainer;
@property (nonatomic, assign) BOOL        isForReplacing;
@property (nonatomic, assign) NSInteger   currOpeningUnitViewTag;
@property (nonatomic, retain) UIView    * backgroundView;
@property (nonatomic, copy)   NSArray   * sixPokemons;
@property (nonatomic, copy)   NSString  * sixPokemonsUID;
@property (nonatomic, retain) SixPokemonsDetailTabViewController * sixPokemonsDetailTabViewController;
@property (nonatomic, retain) CAAnimationGroup                   * animationGroupForNotReplacing;
@property (nonatomic, retain) UIButton                           * cancelButton;

- (void)cancel:(id)sender;

@end


@implementation GameMenuSixPokemonsViewController

@synthesize isSelectedPokemonInfoViewOpening = isSelectedPokemonInfoViewOpening_;
@synthesize currBattlePokemon                = currBattlePokemon_;

@synthesize trainer                = trainer_;
@synthesize isForReplacing         = isForReplacing_;
@synthesize currOpeningUnitViewTag = currOpeningUnitViewTag_;
@synthesize backgroundView         = backgroundView_;
@synthesize sixPokemons            = sixPokemons_;
@synthesize sixPokemonsUID         = sixPokemonsUID_;
@synthesize sixPokemonsDetailTabViewController = sixPokemonsDetailTabViewController_;
@synthesize animationGroupForNotReplacing      = animationGroupForNotReplacing_;
@synthesize cancelButton                       = cancelButton_;

- (void)dealloc
{
  [trainer_         release];
  [backgroundView_  release];
  [sixPokemons_     release];
  self.sixPokemonsUID = nil;
  [sixPokemonsDetailTabViewController_ release];
  [cancelButton_                       release];
  
  self.sixPokemonsDetailTabViewController = nil;
  self.animationGroupForNotReplacing      = nil;
  
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
  
  backgroundView_ = [[UIView alloc] initWithFrame:self.view.frame];
  [backgroundView_ setBackgroundColor:[UIColor blackColor]];
  [backgroundView_ setAlpha:0.f];
  [backgroundView_ setTag:0];
  [self.view addSubview:backgroundView_];
  
  // Create a fake |mapButton_| as the cancel button
  CGRect cancelButtonFrame =
    CGRectMake((kViewWidth - kCenterMainButtonSize) / 2, kViewHeight, kCenterMainButtonSize, kCenterMainButtonSize);
  UIButton * cancelButton = [[UIButton alloc] initWithFrame:cancelButtonFrame];
  self.cancelButton = cancelButton;
  [cancelButton release];
  [self.cancelButton setContentMode:UIViewContentModeScaleAspectFit];
  [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"MainViewMapButtonBackground.png"]
                               forState:UIControlStateNormal];
  [self.cancelButton setImage:[UIImage imageNamed:@"MainViewCenterButtonImageHalfCancel.png"] forState:UIControlStateNormal];
  [self.cancelButton setOpaque:NO];
  [self.cancelButton setTag:0];
  [self.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.cancelButton];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.trainer = [TrainerController sharedInstance];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.backgroundView = nil;
  self.sixPokemons    = nil;
  self.sixPokemonsDetailTabViewController = nil;
  self.cancelButton                       = nil;
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
    GameMenuSixPokemonsUnitView * unitView
    = (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:self.currOpeningUnitViewTag];
    [unitView cancelUnitAnimated:YES];
    unitView = nil;
  }
  self.currOpeningUnitViewTag = ((UIButton *)sender).tag;
}

- (void)resetUnit {
  self.currOpeningUnitViewTag = 0;
}

// Confirm selected Pokemon
- (void)confirm:(id)sender {
  NSInteger tag = ((UIButton *)sender).tag;
  if (self.isForReplacing) {
    // Replace the current pokemon
    GameMenuSixPokemonsUnitView * previousBattlePokemonUnitView =
      (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:self.currBattlePokemon];
    TrainerTamedPokemon * pokemon = [[TrainerController sharedInstance] pokemonOfSixAtIndex:self.currBattlePokemon];
    if ([pokemon.hp intValue] == 0)
      [previousBattlePokemonUnitView setAsFainted:YES];
    else [previousBattlePokemonUnitView setAsCurrentBattleOne:NO];
    pokemon = nil;
    previousBattlePokemonUnitView = nil;
    
    self.currBattlePokemon = tag;
    
    GameMenuSixPokemonsUnitView * currentBattlePokemonUnitView =
      (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:self.currBattlePokemon];
    [currentBattlePokemonUnitView setAsCurrentBattleOne:YES];
    currentBattlePokemonUnitView = nil;
    
    // Post notification to |GameMenuViewController| to replace the pokemon
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNReplacePokemon object:self userInfo:nil];
    
    // Cancel Six Pokemons view
    [self unloadSixPokemonsAnimated:YES];
  }
  // Post noficaiton with selected pokemon index number to |BagItemTableViewController|
  else {
    NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [NSNumber numberWithInt:tag], @"selectedPokemonIndex", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUseItemForSelectedPokemon object:self userInfo:userInfo];
    [userInfo release];
    [UIView animateWithDuration:.3f
                          delay:0.f
                        options:UIViewAnimationCurveLinear
                     animations:^{ [self.view setAlpha:0.f]; }
                     completion:^(BOOL finished) {
                       [self unloadSixPokemonsAnimated:NO];
                       [self.view setAlpha:1.f];
                     }];
  }
}

- (void)openInfoView:(id)sender
{
  SixPokemonsDetailTabViewController * sixPokemonsDetailTabViewController =
    [[SixPokemonsDetailTabViewController alloc] initWithPokemon:[self.sixPokemons objectAtIndex:((UIButton *)sender).tag - 1]
                                                     withTopbar:NO];
  self.sixPokemonsDetailTabViewController = sixPokemonsDetailTabViewController;
  [sixPokemonsDetailTabViewController release];
  [self.view insertSubview:self.sixPokemonsDetailTabViewController.view belowSubview:self.cancelButton];
  __block CGRect viewFrame = CGRectMake(0.f, kViewHeight, kViewWidth, kViewHeight);
  [self.sixPokemonsDetailTabViewController.view setFrame:viewFrame];
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     viewFrame.origin.y = 0.f;
                     [self.sixPokemonsDetailTabViewController.view setFrame:viewFrame];
                   }
                   completion:nil];
  self.isSelectedPokemonInfoViewOpening = YES;
}

#pragma mark - Public Methods

- (void)initWithSixPokemonsForReplacing:(BOOL)forReplacing {
  // Basic Setting
  self.isSelectedPokemonInfoViewOpening = NO;
  self.isForReplacing                   = forReplacing;
  self.currBattlePokemon                = forReplacing ? currBattlePokemon_ : 0;
  NSLog(@"|%@| - |initWithSixPokemonsForReplacing:| - |currBattlePokemon_|:%d", [self class], self.currBattlePokemon);
  
  // Create Pokemon unit views
  self.sixPokemons       = [self.trainer sixPokemons];
  self.sixPokemonsUID    = [self.trainer sixPokemonsUID];
  CGFloat buttonSize     = 60.f;
  CGRect originFrame     = CGRectMake(0.f, kViewHeight - buttonSize / 2, kViewWidth, buttonSize);
  
  for (int i = 0; i < [self.sixPokemons count];) {
    TrainerTamedPokemon         * pokemon  = [self.sixPokemons objectAtIndex:i];
    GameMenuSixPokemonsUnitView * unitView = (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:++i];
    if (unitView == nil) {
      NSLog(@"unitView == nil, create new one...");
      unitView = [[GameMenuSixPokemonsUnitView alloc] initWithFrame:originFrame image:pokemon.pokemon.image tag:i];
      unitView.delegate = self;
      [unitView setTag:i];
      [unitView setAlpha:0.f];
      [self.view insertSubview:unitView belowSubview:self.cancelButton];
    }
    
    // Set as normal for |unitView|
    [unitView setAsNormal];
    
    // Set as current battle one
    if (self.currBattlePokemon == i)
      [unitView setAsCurrentBattleOne:YES];
    // Set FAINTED when HP == 0
    if (forReplacing && ([pokemon.hp intValue] == 0))
      [unitView setAsFainted:YES];
    
    unitView = nil;
    pokemon  = nil;
  }
}

- (void)loadSixPokemonsAnimated:(BOOL)animated {
  if (! self.isForReplacing) [self.view setFrame:CGRectMake(0.f, 20.f, kViewWidth, kViewHeight)];
  
  // Set new position for six pokemons' unit
  void (^setPositionForSixPokemonsUnit)() = ^(){
    CGFloat buttonSize = 60.f;
    CGRect originFrame = CGRectMake(0.f, kViewHeight - buttonSize / 2, kViewWidth, buttonSize);
    for (int i = [self.sixPokemons count]; i > 0; --i) {
      GameMenuSixPokemonsUnitView * unitView = (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:i];
      originFrame.origin.y -= 70.f;
      [unitView setAlpha:1.f];
      [unitView setFrame:originFrame];
      unitView = nil;
    }
  };
  
  void (^animationForNotReplacing)() = ^(){
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
    
    for (int i = [self.sixPokemons count]; i > 0; --i) {
      GameMenuSixPokemonsUnitView * unitView = (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:i];
      [unitView.layer addAnimation:self.animationGroupForNotReplacing forKey:@"animationToShowForNotReplacing"];
      unitView = nil;
    }
  };
  
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationCurveEaseInOut
                   animations:^{
                     [self.backgroundView setAlpha:.75f];
                     [self.cancelButton setFrame:CGRectMake((kViewWidth - kMapButtonSize) / 2,
                                                            kViewHeight - (kMapButtonSize / 2),
                                                            kMapButtonSize,
                                                            kMapButtonSize)];
                     if (self.isForReplacing) setPositionForSixPokemonsUnit();
                   }
                   completion:^(BOOL finished) {
                     // If the view is not for replacing pokemon
                     if (! self.isForReplacing) {
                       setPositionForSixPokemonsUnit();
                       animationForNotReplacing();
                     }
                   }];
}

- (void)unloadSixPokemonsAnimated:(BOOL)animated {
  void (^animation)() = ^(){
    CGFloat buttonSize = 60.f;
    CGRect originFrame = CGRectMake(0.f, kViewHeight - buttonSize / 2, kViewWidth, buttonSize);
    for (int i = [self.sixPokemons count]; i > 0; --i) {
      GameMenuSixPokemonsUnitView * unitView = (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:i];
      [unitView setFrame:originFrame];
      [unitView setAlpha:0.f];
      unitView = nil;
    }
    [self.backgroundView setAlpha:0.f];
    CGRect buttonFrame = self.cancelButton.frame;
    buttonFrame.origin.y = kViewHeight;
    [self.cancelButton setFrame:buttonFrame];
  };
  
  void (^completion)(BOOL finished) = ^(BOOL finished) { [self.view removeFromSuperview]; };
  
  // If there's a unit view opening, close it first
  if (self.currOpeningUnitViewTag != 0) {
    GameMenuSixPokemonsUnitView * unitView
    = (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:self.currOpeningUnitViewTag];
    [unitView cancelUnitAnimated:animated];
    unitView = nil;
    self.currOpeningUnitViewTag = 0;
  }
  
  if (! animated) { animation(); completion(YES); }
  else [UIView animateWithDuration:.3f
                             delay:(self.currOpeningUnitViewTag != 0 ? .6f : 0.f)
                           options:UIViewAnimationCurveEaseInOut
                        animations:animation
                        completion:completion];
}

- (void)unloadSelcetedPokemonInfoView {
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     CGRect viewFrame = self.sixPokemonsDetailTabViewController.view.frame;
                     viewFrame.origin.y = kViewHeight;
                     [self.sixPokemonsDetailTabViewController.view setFrame:viewFrame];
                   }
                   completion:^(BOOL finished) {
                     [self.sixPokemonsDetailTabViewController.view removeFromSuperview];
                     self.sixPokemonsDetailTabViewController = nil;
                     self.isSelectedPokemonInfoViewOpening = NO;
                   }];
}

- (void)prepareForNewScene {
  // Basic Setting
  currOpeningUnitViewTag_ = 0;
  isForReplacing_         = NO;
  
  NSInteger currBattlePokemon = [[TrainerController sharedInstance] battleAvailablePokemonIndex];
  
  // If six Pokemons' UID changed, reload data for Six Pokemons
  if (! [self.sixPokemonsUID isEqualToString:[self.trainer sixPokemonsUID]]) {
    NSLog(@"|%@| - Six PokemonsUID changed...Reload Six Pokemons......", [self class]);
    for (UIView *view in [self.view subviews]) {
      if (view.tag == 0)
        continue;
      [view removeFromSuperview];
    }
    [self initWithSixPokemonsForReplacing:NO];
  }
  
  //
  // TODO:
  //   Redundancy!!
  //
  if (self.currBattlePokemon != currBattlePokemon) {
    if (self.currBattlePokemon != 0) {
      GameMenuSixPokemonsUnitView * previousBattlePokemonUnitView =
        (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:self.currBattlePokemon];
      [previousBattlePokemonUnitView setAsCurrentBattleOne:NO];
      previousBattlePokemonUnitView = nil;
    }
    
    self.currBattlePokemon = currBattlePokemon;
    GameMenuSixPokemonsUnitView * firstPokemonUnitView =
      (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:self.currBattlePokemon];
    [firstPokemonUnitView setAsCurrentBattleOne:YES];
    firstPokemonUnitView = nil;
  }
}

#pragma mark - Private Methods

- (void)cancel:(id)sender {
  if (self.isSelectedPokemonInfoViewOpening)
    [self unloadSelcetedPokemonInfoView];
  else
    [self unloadSixPokemonsAnimated:YES];
}

@end
