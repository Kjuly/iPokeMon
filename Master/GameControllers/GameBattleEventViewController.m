//
//  GameBattleEventViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 4/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameBattleEventViewController.h"

#import "PMAudioPlayer.h"
#import "GameSystemProcess.h"
#import "TrainerController.h"
#import "PokemonLevelUpUnitView.h"
#import "PokemonInfoViewController.h"


@interface GameBattleEventViewController () {
 @private
  UIView                 * backgroundView_;
  UILabel                * message_;
  UIView                 * levelUpView_;
  
  PMAudioPlayer          * audioPlayer_;
  GameSystemProcess      * systemProcess_;
  TrainerController      * trainer_;
  UITapGestureRecognizer * tapGestureRecognizer_;
  
  GameBattleEventType      eventType_;
}

@property (nonatomic, strong) UIView                 * backgroundView;
@property (nonatomic, strong) UILabel                * message;
@property (nonatomic, strong) UIView                 * levelUpView;

@property (nonatomic, strong) PMAudioPlayer          * audioPlayer;
@property (nonatomic, strong) GameSystemProcess      * systemProcess;
@property (nonatomic, strong) TrainerController      * trainer;
@property (nonatomic, strong) UITapGestureRecognizer * tapGestureRecognizer;

- (void)_unloadViewAnimated:(BOOL)animated;
- (void)_tapGestureAction:(UITapGestureRecognizer *)recognizer;
- (void)_setLevelUpViewWithBaseStats:(NSArray *)baseStats deltaStats:(NSArray *)deltaStats;

@end


@implementation GameBattleEventViewController

@synthesize audioPlayer          = audioPlayer_;
@synthesize systemProcess        = systemProcess_;
@synthesize trainer              = trainer_;
@synthesize backgroundView       = backgroundView_;
@synthesize message              = message_;
@synthesize levelUpView          = levelUpView_;
@synthesize tapGestureRecognizer = tapGestureRecognizer_;

- (id)init
{
  if (self = [super init]) {
    self.audioPlayer   = [PMAudioPlayer     sharedInstance];
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
  UIView * view = [[UIView alloc] initWithFrame:
                   CGRectMake(0.f, kKYStatusBarHeight, kViewWidth, kViewHeight)];
  self.view = view;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // backgroun view
  backgroundView_ = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, {kViewWidth, kViewHeight}}];
  [backgroundView_ setBackgroundColor:[UIColor blackColor]];
  [backgroundView_ setAlpha:0.f];
  [self.view addSubview:backgroundView_];
  
  // Tap gesture recognizer
  UITapGestureRecognizer * tapGestureRecognizer = [UITapGestureRecognizer alloc];
  (void)[tapGestureRecognizer initWithTarget:self action:@selector(_tapGestureAction:)];
  [tapGestureRecognizer setNumberOfTapsRequired:1];
  [tapGestureRecognizer setNumberOfTouchesRequired:1];
  self.tapGestureRecognizer = tapGestureRecognizer;
  [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.backgroundView = nil;
  self.message        = nil;
  self.levelUpView    = nil;
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
                  afterDelay:(NSTimeInterval)delay
{
  eventType_ = eventType;
  
  void (^animations)() = ^{};
  void (^completion)(BOOL) = ^(BOOL finished) {};
  
  // NO Pokemon Available to battle
  if (eventType & kGameBattleEventTypeNoPMAvailable) {
    // Message Label
    if (self.message == nil) {
      UILabel * message = [[UILabel alloc] init];
      self.message = message;
      [self.message setBackgroundColor:[UIColor clearColor]];
      [self.message setTextColor:[GlobalRender textColorTitleWhite]];
      [self.message setFont:[GlobalRender textFontNormalInSizeOf:26.f]];
      [self.message setLineBreakMode:NSLineBreakByWordWrapping];
      [self.message setNumberOfLines:0];
      [self.message setAlpha:0.f];
    }
    [self.message setFrame:CGRectMake(30.f, 300.f, 260.f, 140.f)];
    [self.message setTextAlignment:NSTextAlignmentLeft];
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
  // WIN
  else if (eventType & kGameBattleEndEventTypeWin ||
           eventType & kGameBattleEventTypeLose)
  {
    // do nothing, just wait for user's tap gesture
    animations = nil;
    completion = nil;
  }
  // LEVEL UP
  else if (eventType & kGameBattleEventTypeLevelUp) {
    // Message Label
    if (self.message == nil) {
      UILabel * message = [[UILabel alloc] init];
      self.message = message;
      [self.message setBackgroundColor:[UIColor clearColor]];
      [self.message setTextColor:[GlobalRender textColorTitleWhite]];
      [self.message setFont:[GlobalRender textFontNormalInSizeOf:26.f]];
      [self.message setLineBreakMode:NSLineBreakByWordWrapping];
      [self.message setNumberOfLines:0];
      [self.message setAlpha:0.f];
    }
    [self.message setFrame:CGRectMake(30.f, 380.f, 260.f, 60.f)];
    [self.message setTextAlignment:NSTextAlignmentCenter];
    [self.message setText:NSLocalizedString(@"PMSMessageLevelUp", nil)];
    [self.message sizeToFit];
    [self.backgroundView addSubview:self.message];
    
    // Show info for Level Up
    TrainerTamedPokemon * playerPokemon = self.systemProcess.playerPokemon;
    NSInteger levelsUp = [[info valueForKey:@"levelsUp"] intValue];
    // Set up view for Level Up info
    [self _setLevelUpViewWithBaseStats:[playerPokemon maxStatsInArray]
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
                          options:(UIViewAnimationOptions)UIViewAnimationCurveEaseOut
                       animations:^{
                         CGRect levelUpViewFrame = self.levelUpView.frame;
                         levelUpViewFrame.origin.y -= 20.f;
                         [self.levelUpView setFrame:levelUpViewFrame];
                         [self.levelUpView setAlpha:1.f];
                       }
                       completion:nil];
    };
    
    // Play AUDIO
    [self.audioPlayer playForAudioType:kAudioBattlePMLevelUp afterDelay:2.f];
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
    Pokemon * pokemon = [Pokemon queryPokemonDataWithSID:[wildPokemon.sid intValue]];
    PokemonInfoViewController * pokemonInfoViewController =
      [[PokemonInfoViewController alloc] initWithPokemon:pokemon];
    [pokemonInfoViewController.view setFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
    [self.backgroundView addSubview:pokemonInfoViewController.view];
    pokemon     = nil;
    wildPokemon = nil;
    
    // Animation blocks
    animations = ^(){ [self.backgroundView setAlpha:1.f]; };
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
- (void)_unloadViewAnimated:(BOOL)animated
{
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
    if (eventType_ & kGameBattleEventTypeNoPMAvailable)
      [[NSNotificationCenter defaultCenter] postNotificationName:kPMNGameBattleEndWithEvent
                                                          object:self
                                                        userInfo:nil];
    // ENS EVENT
    else [self.systemProcess endEvent];
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
- (void)_tapGestureAction:(UITapGestureRecognizer *)recognizer
{
  [self _unloadViewAnimated:YES];
}

// Set layout for Level Up view
- (void)_setLevelUpViewWithBaseStats:(NSArray *)baseStats
                         deltaStats:(NSArray *)deltaStats
{
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
  
  // Attack
  PokemonLevelUpUnitView * attackUnit = [[PokemonLevelUpUnitView alloc] initWithFrame:attackLabelViewFrame];
  [attackUnit.name setText:NSLocalizedString(@"PMSLabelAttack", nil)];
  [attackUnit.value setText:[NSString stringWithFormat:@"%@", [baseStats objectAtIndex:1]]];
  [attackUnit.deltaValue setText:[NSString stringWithFormat:@"%@", [deltaStats objectAtIndex:1]]];
  [self.levelUpView addSubview:attackUnit];
  
  // Defense
  PokemonLevelUpUnitView * defenseUnit = [[PokemonLevelUpUnitView alloc] initWithFrame:defenseLabelViewFrame];
  [defenseUnit.name setText:NSLocalizedString(@"PMSLabelDefense", nil)];
  [defenseUnit.value setText:[NSString stringWithFormat:@"%@", [baseStats objectAtIndex:2]]];
  [defenseUnit.deltaValue setText:[NSString stringWithFormat:@"%@", [deltaStats objectAtIndex:2]]];
  [self.levelUpView addSubview:defenseUnit];
  
  // Sp. Attack
  PokemonLevelUpUnitView * spAttackUnit = [[PokemonLevelUpUnitView alloc] initWithFrame:spAttackLabelViewFrame];
  [spAttackUnit.name setText:NSLocalizedString(@"PMSLabelSpAttack", nil)];
  [spAttackUnit.value setText:[NSString stringWithFormat:@"%@", [baseStats objectAtIndex:3]]];
  [spAttackUnit.deltaValue setText:[NSString stringWithFormat:@"%@", [deltaStats objectAtIndex:3]]];
  [self.levelUpView addSubview:spAttackUnit];
  
  // Sp. Defense
  PokemonLevelUpUnitView * spDefenseUnit = [[PokemonLevelUpUnitView alloc] initWithFrame:spDefenseLabelViewFrame];
  [spDefenseUnit.name setText:NSLocalizedString(@"PMSLabelSpDefense", nil)];
  [spDefenseUnit.value setText:[NSString stringWithFormat:@"%@", [baseStats objectAtIndex:4]]];
  [spDefenseUnit.deltaValue setText:[NSString stringWithFormat:@"%@", [deltaStats objectAtIndex:4]]];
  [self.levelUpView addSubview:spDefenseUnit];
  
  // Speed
  PokemonLevelUpUnitView * speedUnit = [[PokemonLevelUpUnitView alloc] initWithFrame:speedLabelViewFrame];
  [speedUnit.name setText:NSLocalizedString(@"PMSLabelSpeed", nil)];
  [speedUnit.value setText:[NSString stringWithFormat:@"%@", [baseStats objectAtIndex:5]]];
  [speedUnit.deltaValue setText:[NSString stringWithFormat:@"%@", [deltaStats objectAtIndex:5]]];
  [self.levelUpView addSubview:speedUnit];
}

@end
