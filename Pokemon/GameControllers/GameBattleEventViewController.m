//
//  GameBattleEventViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 4/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameBattleEventViewController.h"

#import "GlobalConstants.h"
#import "GlobalNotificationConstants.h"
#import "GameSystemProcess.h"
#import "TrainerController.h"
#import "PokemonLevelUpUnitView.h"
#import "PokemonInfoViewController.h"


@interface GameBattleEventViewController () {
 @private
  GameBattleEventType      eventType_;
  GameSystemProcess      * systemProcess_;
  TrainerController      * trainer_;
  UIView                 * backgroundView_;
  UILabel                * message_;
  UIView                 * levelUpView_;
  UITapGestureRecognizer * tapGestureRecognizer_;
}

@property (nonatomic, assign) GameBattleEventType      eventType;
@property (nonatomic, retain) GameSystemProcess      * systemProcess;
@property (nonatomic, retain) TrainerController      * trainer;
@property (nonatomic, retain) UIView                 * backgroundView;
@property (nonatomic, retain) UILabel                * message;
@property (nonatomic, retain) UIView                 * levelUpView;
@property (nonatomic, retain) UITapGestureRecognizer * tapGestureRecognizer;

- (void)unloadViewAnimated:(BOOL)animated;
- (void)tapGestureAction:(UITapGestureRecognizer *)recognizer;
- (void)setLevelUpViewWithBaseStats:(NSArray *)baseStats deltaStats:(NSArray *)deltaStats;

@end

@implementation GameBattleEventViewController

@synthesize eventType            = eventType_;
@synthesize systemProcess        = systemProcess_;
@synthesize trainer              = trainer_;
@synthesize backgroundView       = backgroundView_;
@synthesize message              = message_;
@synthesize levelUpView          = levelUpView_;
@synthesize tapGestureRecognizer = tapGestureRecognizer_;

- (void)dealloc
{
  [systemProcess_        release];
  [trainer_              release];
  [backgroundView_       release];
  [message_              release];
  [levelUpView_          release];
  [tapGestureRecognizer_ release];
  
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.systemProcess = [GameSystemProcess sharedInstance];
    self.trainer       = [TrainerController sharedInstance];
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
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 20.f, kViewWidth, kViewHeight)];
  self.view = view;
  [view release];
  
  backgroundView_ = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
  [backgroundView_ setBackgroundColor:[UIColor blackColor]];
  [backgroundView_ setAlpha:0.f];
  [self.view addSubview:backgroundView_];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Tap gesture recognizer
  UITapGestureRecognizer * tapGestureRecognizer =
  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
  self.tapGestureRecognizer = tapGestureRecognizer;
  [tapGestureRecognizer release];
  [self.tapGestureRecognizer setNumberOfTapsRequired:1];
  [self.tapGestureRecognizer setNumberOfTouchesRequired:1];
  [self.view addGestureRecognizer:self.tapGestureRecognizer];
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

#pragma mark - Public Methods

// Load view with Battle End Event Type
-(void)loadViewWithEventType:(GameBattleEventType)eventType
                        info:(NSDictionary *)info
                    animated:(BOOL)animated
                  afterDelay:(NSTimeInterval)delay {
  self.eventType = eventType;
  
  void (^animations)();
  void (^completion)(BOOL);
  
  // NO Pokemon Available to battle
  if (eventType & kGameBattleEventTypeNoPMAvailable) {
    // Message Label
    if (self.message == nil) {
      UILabel * message = [[UILabel alloc] init];
      self.message = message;
      [message release];
      [self.message setBackgroundColor:[UIColor clearColor]];
      [self.message setTextColor:[GlobalRender textColorTitleWhite]];
      [self.message setFont:[GlobalRender textFontNormalInSizeOf:26.f]];
      [self.message setLineBreakMode:UILineBreakModeWordWrap];
      [self.message setNumberOfLines:0];
      [self.message setAlpha:0.f];
    }
    [self.message setFrame:CGRectMake(30.f, 300.f, 260.f, 140.f)];
    [self.message setTextAlignment:UITextAlignmentLeft];
    [self.message setText:NSLocalizedString(@"PMSMessageEventNOPMAvailable", nil)];
    [self.message sizeToFit];
    [self.backgroundView addSubview:self.message];
    
    // Animation blocks
    __block CGRect messageFrame = self.message.frame;
    animations = ^(){
      [self.backgroundView setAlpha:1.f];
      
      messageFrame.origin.y -= 20.f;
      [self.message setFrame:messageFrame];
      [self.message setAlpha:1.f];
    };
    completion = nil;
  }
  // LEVEL UP
  else if (eventType & kGameBattleEventTypeLevelUp) {
    // Message Label
    if (self.message == nil) {
      UILabel * message = [[UILabel alloc] init];
      self.message = message;
      [message release];
      [self.message setBackgroundColor:[UIColor clearColor]];
      [self.message setTextColor:[GlobalRender textColorTitleWhite]];
      [self.message setFont:[GlobalRender textFontNormalInSizeOf:26.f]];
      [self.message setLineBreakMode:UILineBreakModeWordWrap];
      [self.message setNumberOfLines:0];
      [self.message setAlpha:0.f];
    }
    [self.message setFrame:CGRectMake(30.f, 380.f, 260.f, 60.f)];
    [self.message setTextAlignment:UITextAlignmentCenter];
    [self.message setText:NSLocalizedString(@"PMSMessageLevelUp", nil)];
    [self.message sizeToFit];
    [self.backgroundView addSubview:self.message];
    
    // Show info for Level Up
    TrainerTamedPokemon * playerPokemon = self.systemProcess.playerPokemon;
    NSInteger levelsUp = [[info valueForKey:@"levelsUp"] intValue];
    // Set up view for Level Up info
    [self setLevelUpViewWithBaseStats:[playerPokemon maxStatsInArray]
                           deltaStats:[playerPokemon addStatsWithLevelsUp:levelsUp]];
    playerPokemon = nil;
    
    // Animation blocks
    __block CGRect messageFrame = self.message.frame;
    animations = ^(){
      [self.backgroundView setAlpha:1.f];
      
      messageFrame.origin.y -= 20.f;
      [self.message setFrame:messageFrame];
      [self.message setAlpha:1.f];
    };
    completion = ^(BOOL finished) {
      [UIView animateWithDuration:.3f
                            delay:0.f
                          options:UIViewAnimationCurveEaseOut
                       animations:^{
                         CGRect levelUpViewFrame = self.levelUpView.frame;
                         levelUpViewFrame.origin.y -= 20.f;
                         [self.levelUpView setFrame:levelUpViewFrame];
                         [self.levelUpView setAlpha:1.f];
                       }
                       completion:nil];
    };
  }
  // Evolution
  //
  // !!!TODO
  //   Evolution for Pokemon
  //
  else if (eventType & kGameBattleEventTypeEvolution) {
    
  }
  // Caught a Wild Pokemon
  else if (eventType & kGameBattleEventTypeCaughtWPM) {
    WildPokemon * wildPokemon = self.systemProcess.enemyPokemon;
    
    // Save WildPokemon to TraienrTamedPokemon groupd
    [self.trainer caughtNewWildPokemon:wildPokemon memo:@"PMSMemoTest"];
    
    // Load Pokemon info view
    Pokemon * pokemonData = [Pokemon queryPokemonDataWithID:[wildPokemon.sid intValue]];
    PokemonInfoViewController * pokemonInfoViewController =
      [[PokemonInfoViewController alloc] initWithPokemonDataDict:pokemonData];
    [pokemonInfoViewController.view setFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
    [self.backgroundView addSubview:pokemonInfoViewController.view];
    [pokemonInfoViewController release];
    pokemonData = nil;
    wildPokemon = nil;
    
    // Animation blocks
    animations = ^(){
      [self.backgroundView setAlpha:1.f];
    };
    completion = ^(BOOL finished) {
      // Notification to |GameBattleLayer| to deal with ending battle
      [[NSNotificationCenter defaultCenter] postNotificationName:kPMNGameBattleEnd
                                                          object:self
                                                        userInfo:nil];
    };
  }
  else return;
  
  if (animated) [UIView animateWithDuration:.3f
                                      delay:delay
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:animations
                                 completion:completion];
  else { animations(); completion(YES); }
}

#pragma mark - Private Methods

// Unload view
- (void)unloadViewAnimated:(BOOL)animated {
  void (^animations)() = ^(){
    [self.backgroundView setAlpha:0.f];
    
    // If |message_| is showing, unload it
    if (self.message != nil && self.message.alpha == 1.f) {
      [self.message setAlpha:0.f];
      CGRect messageFrame = self.message.frame;
      messageFrame.origin.y = 380.f;
      [self.message setFrame:messageFrame];
    }
    
    // If |levelUpView_| is showing, unload it
    if (self.levelUpView != nil && self.levelUpView.alpha == 1.f) {
      [self.levelUpView setAlpha:0.f];
    }
  };
  
  void (^completion)(BOOL) = ^(BOOL finished) {
    // Remove subviews
    for (UIView *view in [self.backgroundView subviews])
      [view removeFromSuperview];
    for (UIView *view in [self.levelUpView subviews])
      [view removeFromSuperview];
    [self.view removeFromSuperview];
    
    // If battle is not started (Trainer has NO Pokemon available)
    if (self.eventType & kGameBattleEventTypeNoPMAvailable)
      [[NSNotificationCenter defaultCenter] postNotificationName:kPMNGameBattleEndWithEvent object:self userInfo:nil];
    else // ENS EVENT
      [self.systemProcess endEvent];
  };
  if (animated) [UIView animateWithDuration:.3f
                                      delay:0.f
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:animations
                                 completion:completion];
  else {
    animations();
    completion(YES);
  }
}

// Tap gesture action
- (void)tapGestureAction:(UITapGestureRecognizer *)recognizer {
  [self unloadViewAnimated:YES];
}

// Set layout for Level Up view
- (void)setLevelUpViewWithBaseStats:(NSArray *)baseStats
                         deltaStats:(NSArray *)deltaStats {
  // Constants
  CGFloat const labelHeight             = 32.f;
  CGFloat const dataViewHeight          = labelHeight * 6;
  CGRect  const levelUpViewFrame        = CGRectMake(10.f, 120.f, 300.f, dataViewHeight);
  CGRect  const hpLabelViewFrame        = CGRectMake(0.f, 0.f,             300.f, labelHeight);
  CGRect  const attackLabelViewFrame    = CGRectMake(0.f, labelHeight,     300.f, labelHeight);
  CGRect  const defenseLabelViewFrame   = CGRectMake(0.f, labelHeight * 2, 300.f, labelHeight);
  CGRect  const spAttackLabelViewFrame  = CGRectMake(0.f, labelHeight * 3, 300.f, labelHeight);
  CGRect  const spDefenseLabelViewFrame = CGRectMake(0.f, labelHeight * 4, 300.f, labelHeight);
  CGRect  const speedLabelViewFrame     = CGRectMake(0.f, labelHeight * 5, 300.f, labelHeight);
  
  ///Data View in Center
  if (self.levelUpView == nil) {
    UIView * levelUpView = [[UIView alloc] init];
    self.levelUpView = levelUpView;
    [levelUpView release];
    [self.levelUpView setAlpha:0.f];
    [self.view addSubview:self.levelUpView];
  }
  [self.levelUpView setFrame:levelUpViewFrame];
  
  // HP
  PokemonLevelUpUnitView * hpUnit = [[PokemonLevelUpUnitView alloc] initWithFrame:hpLabelViewFrame];
  [hpUnit.name setText:NSLocalizedString(@"PMSLabelHP", nil)];
  [hpUnit.value setText:[NSString stringWithFormat:@"%@", [baseStats objectAtIndex:0]]];
  [hpUnit.deltaValue setText:[NSString stringWithFormat:@"%@", [deltaStats objectAtIndex:0]]];
  [self.levelUpView addSubview:hpUnit];
  [hpUnit release];
  
  // Attack
  PokemonLevelUpUnitView * attackUnit = [[PokemonLevelUpUnitView alloc] initWithFrame:attackLabelViewFrame];
  [attackUnit.name setText:NSLocalizedString(@"PMSLabelAttack", nil)];
  [attackUnit.value setText:[NSString stringWithFormat:@"%@", [baseStats objectAtIndex:1]]];
  [attackUnit.deltaValue setText:[NSString stringWithFormat:@"%@", [deltaStats objectAtIndex:1]]];
  [self.levelUpView addSubview:attackUnit];
  [attackUnit release];
  
  // Defense
  PokemonLevelUpUnitView * defenseUnit = [[PokemonLevelUpUnitView alloc] initWithFrame:defenseLabelViewFrame];
  [defenseUnit.name setText:NSLocalizedString(@"PMSLabelDefense", nil)];
  [defenseUnit.value setText:[NSString stringWithFormat:@"%@", [baseStats objectAtIndex:2]]];
  [defenseUnit.deltaValue setText:[NSString stringWithFormat:@"%@", [deltaStats objectAtIndex:2]]];
  [self.levelUpView addSubview:defenseUnit];
  [defenseUnit release];
  
  // Sp. Attack
  PokemonLevelUpUnitView * spAttackUnit = [[PokemonLevelUpUnitView alloc] initWithFrame:spAttackLabelViewFrame];
  [spAttackUnit.name setText:NSLocalizedString(@"PMSLabelSpAttack", nil)];
  [spAttackUnit.value setText:[NSString stringWithFormat:@"%@", [baseStats objectAtIndex:3]]];
  [spAttackUnit.deltaValue setText:[NSString stringWithFormat:@"%@", [deltaStats objectAtIndex:3]]];
  [self.levelUpView addSubview:spAttackUnit];
  [spAttackUnit release];
  
  // Sp. Defense
  PokemonLevelUpUnitView * spDefenseUnit = [[PokemonLevelUpUnitView alloc] initWithFrame:spDefenseLabelViewFrame];
  [spDefenseUnit.name setText:NSLocalizedString(@"PMSLabelSpDefense", nil)];
  [spDefenseUnit.value setText:[NSString stringWithFormat:@"%@", [baseStats objectAtIndex:4]]];
  [spDefenseUnit.deltaValue setText:[NSString stringWithFormat:@"%@", [deltaStats objectAtIndex:4]]];
  [self.levelUpView addSubview:spDefenseUnit];
  [spDefenseUnit release];
  
  // Speed
  PokemonLevelUpUnitView * speedUnit = [[PokemonLevelUpUnitView alloc] initWithFrame:speedLabelViewFrame];
  [speedUnit.name setText:NSLocalizedString(@"PMSLabelSpeed", nil)];
  [speedUnit.value setText:[NSString stringWithFormat:@"%@", [baseStats objectAtIndex:5]]];
  [speedUnit.deltaValue setText:[NSString stringWithFormat:@"%@", [deltaStats objectAtIndex:5]]];
  [self.levelUpView addSubview:speedUnit];
  [speedUnit release];
}

@end
