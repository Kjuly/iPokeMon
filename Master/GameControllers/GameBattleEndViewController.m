//
//  GameBattleEndViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 4/8/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameBattleEndViewController.h"

#import "GlobalRender.h"
#import "GameSystemProcess.h"
#import "PokemonInfoViewController.h"
#import "TrainerController.h"


@interface GameBattleEndViewController () {
 @private
  UIView                 * backgroundView_;
  UILabel                * message_;
  
  TrainerController      * trainer_;
  UITapGestureRecognizer * tapGestureRecognizer_;
  
  GameBattleEndEventType   eventType_;
}

@property (nonatomic, strong) UIView                 * backgroundView;
@property (nonatomic, strong) UILabel                * message;

@property (nonatomic, strong) TrainerController      * trainer;
@property (nonatomic, strong) UITapGestureRecognizer * tapGestureRecognizer;

- (void)_unloadViewAnimated:(BOOL)animated;
- (void)_tapGestureAction:(UITapGestureRecognizer *)recognizer;

@end


@implementation GameBattleEndViewController

@synthesize backgroundView       = backgroundView_;
@synthesize message              = message_;

@synthesize trainer              = trainer_;
@synthesize tapGestureRecognizer = tapGestureRecognizer_;

- (id)init
{
  if (self = [super init]) {
    // Custom initialization
    self.trainer = [TrainerController sharedInstance];
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
  
  backgroundView_ = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
  [backgroundView_ setBackgroundColor:[UIColor blackColor]];
  [backgroundView_ setAlpha:0.f];
  [view addSubview:backgroundView_];
  
  self.view = view;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Tap gesture recognizer
  UITapGestureRecognizer * tapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapGestureAction:)];
  self.tapGestureRecognizer = tapGestureRecognizer;
  [self.tapGestureRecognizer setNumberOfTapsRequired:1];
  [self.tapGestureRecognizer setNumberOfTouchesRequired:1];
  [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.backgroundView = nil;
  self.message        = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

// Load view with Battle End Event Type
- (void)loadViewWithEventType:(GameBattleEndEventType)eventType
                     animated:(BOOL)animated
                   afterDelay:(NSTimeInterval)delay
{
  eventType_ = eventType;
  
  void (^animations)();
 
  // Player WIN
  if (eventType == kGameBattleEndEventTypeWin) {
    if (self.message == nil) {
      UILabel * message = [[UILabel alloc] initWithFrame:CGRectMake(30.f, 150.f, 260.f, 280.f)];
      self.message = message;
      [self.message setBackgroundColor:[UIColor clearColor]];
      [self.message setTextColor:[GlobalRender textColorTitleWhite]];
      [self.message setFont:[GlobalRender textFontNormalInSizeOf:14.f]];
      [self.message setAlpha:0.f];
    }
    [self.message setText:NSLocalizedString(@"PMSMessagePlayerWin", nil)];
    [self.backgroundView addSubview:self.message];
    
    animations = ^(){
      [self.backgroundView setAlpha:1.f];
      [self.message setAlpha:1.f];
      CGRect messageFrame = self.message.frame;
      messageFrame.origin.y = 100.f;
      [self.message setFrame:messageFrame];
    };
  }
  // Player LOSE
  else if (eventType == kGameBattleEndEventTypeLose) {
    if (self.message == nil) {
      UILabel * message = [[UILabel alloc] initWithFrame:CGRectMake(30.f, 150.f, 260.f, 280.f)];
      self.message = message;
      [self.message setBackgroundColor:[UIColor clearColor]];
      [self.message setTextColor:[GlobalRender textColorTitleWhite]];
      [self.message setFont:[GlobalRender textFontNormalInSizeOf:14.f]];
      [self.message setAlpha:0.f];
    }
    [self.message setText:NSLocalizedString(@"PMSMessagePlayerLose", nil)];
    [self.backgroundView addSubview:self.message];
    
    animations = ^(){
      [self.backgroundView setAlpha:1.f];
      [self.message setAlpha:1.f];
      CGRect messageFrame = self.message.frame;
      messageFrame.origin.y = 100.f;
      [self.message setFrame:messageFrame];
    };
  }
  // Caught a Wild Pokemon
  else if (eventType == kGameBattleEndEventTypeCaughtWildPokemon) {
    WildPokemon * wildPokemon = [GameSystemProcess sharedInstance].enemyPokemon;
    
    // Save WildPokemon to TraienrTamedPokemon groupd
    [self.trainer caughtNewWildPokemon:wildPokemon memo:@""];
    
    // Load Pokemon info view
    Pokemon * pokemonData = [Pokemon queryPokemonDataWithSID:[wildPokemon.sid intValue]];
    PokemonInfoViewController * pokemonInfoViewController;
    pokemonInfoViewController = [[PokemonInfoViewController alloc] initWithPokemon:pokemonData];
    [pokemonInfoViewController.view setFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
    [self.backgroundView addSubview:pokemonInfoViewController.view];
    pokemonData = nil;
    wildPokemon = nil;
    
    animations = ^(){
      [self.backgroundView setAlpha:1.f];
    };
  }
  else return;
  
  void (^completion)(BOOL) = ^(BOOL finished) {
    // Notification to |GameBattleLayer| to deal with ending battle
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNGameBattleEnd
                                                        object:self
                                                      userInfo:nil];
  };
  
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
      messageFrame.origin.y = 100.f;
      [self.message setFrame:messageFrame];
    }
  };
  void (^completion)(BOOL) = ^(BOOL finished) {
    for (UIView *view in [self.backgroundView subviews])
      [view removeFromSuperview];
    [self.view removeFromSuperview];
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
  if (eventType_ == kGameBattleEndEventTypeWin) {
    [self _unloadViewAnimated:YES];
  }
  else if (eventType_ == kGameBattleEndEventTypeLose) {
    [self _unloadViewAnimated:YES];
  }
  else if (eventType_ == kGameBattleEndEventTypeCaughtWildPokemon) {
    [self _unloadViewAnimated:YES];
  }
  else return;
}

@end
