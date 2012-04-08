//
//  GameBattleEndViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 4/8/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameBattleEndViewController.h"

#import "GlobalConstants.h"
#import "GlobalRender.h"
#import "GameSystemProcess.h"
#import "PokemonInfoViewController.h"
#import "TrainerController.h"


@interface GameBattleEndViewController () {
 @private
  GameBattleEndEventType   eventType_;
  TrainerController      * trainer_;
  UIView                 * backgroundView_;
  UITapGestureRecognizer * tapGestureRecognizer_;
  UILabel                * message_;
}

@property (nonatomic, assign) GameBattleEndEventType   eventType;
@property (nonatomic, retain) TrainerController      * trainer;
@property (nonatomic, retain) UIView                 * backgroundView;
@property (nonatomic, retain) UITapGestureRecognizer * tapGestureRecognizer;
@property (nonatomic, retain) UILabel                * message;

- (void)unloadViewAnimated:(BOOL)animated;
- (void)tapGestureAction:(UITapGestureRecognizer *)recognizer;

@end


@implementation GameBattleEndViewController

@synthesize eventType            = eventType_;
@synthesize trainer              = trainer_;
@synthesize backgroundView       = backgroundView_;
@synthesize tapGestureRecognizer = tapGestureRecognizer_;
@synthesize message              = message_;

- (void)dealloc
{
  [trainer_              release];
  [backgroundView_       release];
  [tapGestureRecognizer_ release];
  
  self.message = nil;
  
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
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
  
  self.backgroundView       = nil;
  self.tapGestureRecognizer = nil;
  self.message              = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

// Load view with Battle End Event Type
-(void)loadViewWithEventType:(GameBattleEndEventType)eventType
                    animated:(BOOL)animated
                  afterDelay:(NSTimeInterval)delay{
  self.eventType = eventType;
  
  void (^animations)();
 
  // Player WIN
  if (eventType == kGameBattleEndEventTypePlayerWin) {
    if (self.message == nil) {
      UILabel * message = [[UILabel alloc] initWithFrame:CGRectMake(30.f, 150.f, 260.f, 280.f)];
      self.message = message;
      [message release];
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
  else if (eventType == kGameBattleEndEventTypePlayerLose) {
    if (self.message == nil) {
      UILabel * message = [[UILabel alloc] initWithFrame:CGRectMake(30.f, 150.f, 260.f, 280.f)];
      self.message = message;
      [message release];
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
    Pokemon * pokemonData = [Pokemon queryPokemonDataWithID:[wildPokemon.sid intValue]];
    PokemonInfoViewController * pokemonInfoViewController =
      [[PokemonInfoViewController alloc] initWithPokemonDataDict:pokemonData];
    [pokemonInfoViewController.view setFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
    [self.backgroundView addSubview:pokemonInfoViewController.view];
    [pokemonInfoViewController release];
    pokemonData = nil;
    wildPokemon = nil;
    
    animations = ^(){
      [self.backgroundView setAlpha:1.f];
    };
  }
  else return;
  
  if (animated) [UIView animateWithDuration:.3f
                                      delay:delay
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:animations
                                 completion:nil];
  else animations();
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
      messageFrame.origin.y = 100.f;
      [self.message setFrame:messageFrame];
    }
  };
  void (^completion)(BOOL) = ^(BOOL finished) {
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
- (void)tapGestureAction:(UITapGestureRecognizer *)recognizer {
  if (self.eventType == kGameBattleEndEventTypePlayerWin) {
    [self unloadViewAnimated:YES];
  }
  else if (self.eventType == kGameBattleEndEventTypePlayerLose) {
    [self unloadViewAnimated:YES];
  }
  else if (self.eventType == kGameBattleEndEventTypeCaughtWildPokemon) {
    [self unloadViewAnimated:YES];
  }
  else return;
}

@end
