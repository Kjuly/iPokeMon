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
#import "GameMenuSixPokemonsUnitView.h"
#import "TrainerCoreDataController.h"
#import "SixPokemonsDetailTabViewController.h"

@interface GameMenuSixPokemonsViewController () {
 @private
  NSInteger currOpeningUnitViewTag_;
  UIView  * backgroundView_;
  NSArray * sixPokemons_;
  SixPokemonsDetailTabViewController * sixPokemonsDetailTabViewController_;
  UIButton * cancelButton_;
}

@property (nonatomic, assign) NSInteger currOpeningUnitViewTag;
@property (nonatomic, retain) UIView  * backgroundView;
@property (nonatomic, copy) NSArray   * sixPokemons;
@property (nonatomic, retain) SixPokemonsDetailTabViewController * sixPokemonsDetailTabViewController;
@property (nonatomic, retain) UIButton * cancelButton;

- (void)unloadSelcetedPokemonInfoView;
- (void)resetUnit;

@end


@implementation GameMenuSixPokemonsViewController

@synthesize isSelectedPokemonInfoViewOpening = isSelectedPokemonInfoViewOpening_;

@synthesize currOpeningUnitViewTag = currOpeningUnitViewTag_;
@synthesize backgroundView         = backgroundView_;
@synthesize sixPokemons            = sixPokemons_;
@synthesize sixPokemonsDetailTabViewController = sixPokemonsDetailTabViewController_;
@synthesize currBattlePokemon = currBattlePokemon_;
@synthesize cancelButton = cancelButton_;

- (void)dealloc
{
  [backgroundView_ release];
  [sixPokemons_    release];
  [sixPokemonsDetailTabViewController_ release];
  [cancelButton_ release];
  
  self.sixPokemonsDetailTabViewController = nil;
  
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
  [self.view addSubview:backgroundView_];
  
  // Create a fake |mapButton_| as the cancel button
  UIButton * cancelButton = [[UIButton alloc] initWithFrame:CGRectMake((kViewWidth - kMapButtonSize) / 2,
                                                                       - kMapButtonSize,
                                                                       kMapButtonSize,
                                                                       kMapButtonSize)];
  self.cancelButton = cancelButton;
  [cancelButton release];
  [self.cancelButton setContentMode:UIViewContentModeScaleAspectFit];
  [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"MainViewMapButtonBackground.png"]
                               forState:UIControlStateNormal];
  [self.cancelButton setImage:[UIImage imageNamed:@"MainViewMapButtonImageHalfCancel.png"] forState:UIControlStateNormal];
  [self.cancelButton setOpaque:NO];
  [self.cancelButton addTarget:self
                        action:@selector(unloadSelcetedPokemonInfoView)
              forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.cancelButton];
  
  // Basic Setting
  currBattlePokemon_ = 1;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Basic Setting
  currOpeningUnitViewTag_ = 0;
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.backgroundView = nil;
  self.sixPokemons    = nil;
  self.sixPokemonsDetailTabViewController = nil;
  self.cancelButton = nil;
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
    [unitView cancelUnit];
    unitView = nil;
  }
  self.currOpeningUnitViewTag = ((UIButton *)sender).tag;
}

- (void)resetUnit {
  self.currOpeningUnitViewTag = 0;
}

- (void)confirm:(id)sender
{
  NSInteger tag = ((UIButton *)sender).tag;
  
  // Replace the current pokemon
  GameMenuSixPokemonsUnitView * previousBattlePokemonUnitView
  = (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:self.currBattlePokemon];
  [previousBattlePokemonUnitView setAsCurrentBattleOne:NO];
  previousBattlePokemonUnitView = nil;
  
  self.currBattlePokemon = tag;
  
  GameMenuSixPokemonsUnitView * currentBattlePokemonUnitView
  = (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:self.currBattlePokemon];
  [currentBattlePokemonUnitView setAsCurrentBattleOne:YES];
  currentBattlePokemonUnitView = nil;
  
  // Cancel Six Pokemons view
  [self unloadSixPokemons];
  
  // Post notification to |GameMenuViewController| to replace the pokemon
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNReplacePokemon object:self userInfo:nil];
}

- (void)openInfoView:(id)sender
{
  SixPokemonsDetailTabViewController * sixPokemonsDetailTabViewController
  = [[SixPokemonsDetailTabViewController alloc] initWithPokemon:
     [self.sixPokemons objectAtIndex:((UIButton *)sender).tag - 1]];
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
                     [self.cancelButton setFrame:CGRectMake((kViewWidth - kMapButtonSize) / 2,
                                                            - (kMapButtonSize / 2),
                                                            kMapButtonSize,
                                                            kMapButtonSize)];
                   }
                   completion:nil];
  self.isSelectedPokemonInfoViewOpening = YES;
}

#pragma mark - Public Methods

- (void)initWithSixPokemons
{
  self.sixPokemons = [[TrainerCoreDataController sharedInstance] sixPokemons];
  
  CGFloat buttonSize = 60.f;
  CGRect originFrame = CGRectMake(0.f, kViewHeight - buttonSize / 2, kViewWidth, buttonSize);
  
  //
  // TODO:
  //   Every time they'll be created, no need actually
  //
  for (int i = 0; i < [self.sixPokemons count];) {
    TrainerTamedPokemon * pokemon = [self.sixPokemons objectAtIndex:i];
    GameMenuSixPokemonsUnitView * gameMenuSixPokemonsUnitView
    = [[GameMenuSixPokemonsUnitView alloc] initWithFrame:originFrame image:pokemon.pokemon.image tag:++i];
    gameMenuSixPokemonsUnitView.delegate = self;
    [gameMenuSixPokemonsUnitView setTag:i];
    [gameMenuSixPokemonsUnitView setAlpha:0.f];
    if (self.currBattlePokemon == i) {
      [gameMenuSixPokemonsUnitView setAsCurrentBattleOne:YES];
    }
    [self.view insertSubview:gameMenuSixPokemonsUnitView belowSubview:self.cancelButton];
    [gameMenuSixPokemonsUnitView release];
    pokemon = nil;
  }
  
  // Basic Setting
  self.isSelectedPokemonInfoViewOpening = NO;
}

- (void)loadSixPokemons {
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationCurveEaseInOut
                   animations:^{
                     [self.backgroundView setAlpha:.75f];
                     CGFloat buttonSize = 60.f;
                     CGRect originFrame = CGRectMake(0.f,
                                                     kViewHeight - buttonSize / 2,
                                                     kViewWidth,
                                                     buttonSize);
                     for (int i = [self.sixPokemons count]; i > 0; --i) {
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

- (void)unloadSixPokemons {
  [UIView animateWithDuration:.3f
                        delay:(self.currOpeningUnitViewTag != 0 ? .6f : 0.f)
                      options:UIViewAnimationCurveEaseInOut
                   animations:^{
                     CGFloat buttonSize = 60.f;
                     CGRect originFrame = CGRectMake(0.f,
                                                     kViewHeight - buttonSize / 2,
                                                     kViewWidth,
                                                     buttonSize);
                     for (int i = [self.sixPokemons count]; i > 0; --i) {
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
  
  // If there's a unit view opening, close it first
  if (self.currOpeningUnitViewTag != 0) {
    GameMenuSixPokemonsUnitView * unitView
    = (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:self.currOpeningUnitViewTag];
    [unitView cancelUnit];
    unitView = nil;
    self.currOpeningUnitViewTag = 0;
  }
}

- (void)unloadSelcetedPokemonInfoView {
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     CGRect viewFrame = self.sixPokemonsDetailTabViewController.view.frame;
                     viewFrame.origin.y = kViewHeight;
                     [self.sixPokemonsDetailTabViewController.view setFrame:viewFrame];
                     CGRect buttonFrame = self.cancelButton.frame;
                     buttonFrame.origin.y = - kMapButtonSize;
                     [self.cancelButton setFrame:buttonFrame];
                   }
                   completion:^(BOOL finished) {
                     [self.sixPokemonsDetailTabViewController.view removeFromSuperview];
                     self.sixPokemonsDetailTabViewController = nil;
                     self.isSelectedPokemonInfoViewOpening = NO;
                   }];
}

- (void)prepareForNewScene {
  //
  // TODO:
  //   Redundancy!!
  //
  GameMenuSixPokemonsUnitView * previousBattlePokemonUnitView
  = (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:self.currBattlePokemon];
  [previousBattlePokemonUnitView setAsCurrentBattleOne:NO];
  previousBattlePokemonUnitView = nil;
  
  self.currBattlePokemon = 1;
  
  GameMenuSixPokemonsUnitView * firstPokemonUnitView
  = (GameMenuSixPokemonsUnitView *)[self.view viewWithTag:self.currBattlePokemon];
  [firstPokemonUnitView setAsCurrentBattleOne:YES];
  firstPokemonUnitView = nil;
}

@end
