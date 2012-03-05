//
//  GameMenuViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuViewController.h"

#import "GlobalNotificationConstants.h"
#import "GameStatus.h"
#import "GameMenuMoveViewController.h"
#import "GameMenuBagViewController.h"


typedef enum {
  kGameMenuKeyViewNone            = 0,
  kGameMenuKeyViewSixPokemonsView = 1,
  kGameMenuKeyViewMoveView        = 2,
  kGameMenuKeyViewBagView         = 3
}GameMenuKeyView;

@interface GameMenuViewController () {
 @private
  GameMenuKeyView              gameMenuKeyView_;
  GameMenuMoveViewController * gameMenuMoveViewController_;
  GameMenuBagViewController  * gameMenuBagViewController_;
  UIView * menuArea_;
  UIView * buttonBagAndRunBackground_;
}

@property (nonatomic, assign) GameMenuKeyView              gameMenuKeyView;
@property (nonatomic, retain) GameMenuMoveViewController * gameMenuMoveViewController;
@property (nonatomic, retain) GameMenuBagViewController  * gameMenuBagViewController;
@property (nonatomic, retain) UIView * menuArea;
@property (nonatomic, retain) UIView * buttonBagAndRunBackground;

// Button Actions
- (void)openMoveView;
- (void)openBagView;
- (void)openRunConfirmView;
- (void)toggleSixPokemonsView:(NSNotification *)notification;

@end

@implementation GameMenuViewController

@synthesize delegate    = delegate_;
@synthesize buttonFight = buttonFight_;
@synthesize buttonBag   = buttonBag_;
@synthesize buttonRun   = buttonRun_;

@synthesize gameMenuKeyView            = gameMenuKeyView_;
@synthesize gameMenuMoveViewController = gameMenuMoveViewController_;
@synthesize gameMenuBagViewController  = gameMenuBagViewController_;
@synthesize menuArea = menuArea_;
@synthesize buttonBagAndRunBackground = buttonBagAndRunBackground_;

- (void)dealloc
{
  self.delegate = nil;
  
  [buttonFight_ release];
  [buttonBag_   release];
  [buttonRun_   release];
  
  [gameMenuMoveViewController_ release];
  [gameMenuBagViewController_  release];
  [menuArea_ release];
  [buttonBagAndRunBackground_ release];
  
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
  [super loadView];
  
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
  self.view = view;
  [view release];
  [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"GameBattleViewMainMenuBackground.png"]]];
  [self.view setOpaque:NO];
  
  // Base Settings
  gameMenuKeyView_ = kGameMenuKeyViewNone;
  
  // Add Observer for notfication
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(toggleSixPokemonsView:)
                                               name:kPMNToggleSixPokemons
                                             object:nil];
  
  // Constants
  CGRect menuAreaFrame    = CGRectMake(0.0f, 270.0f, 320.0f, 210.0f);
  CGRect buttonBagAndRunBackgroundFrame = CGRectMake(10.0f, 20.0f, 300.0f, 130.0f);
  CGRect buttonBagFrame   = CGRectMake(10.0f, 25.0f, 80.0f, 80.0f);
  CGRect buttonRunFrame   = CGRectMake(210.0f, 25.0f, 80.0f, 80.0f);
  CGRect buttonFightFrame = CGRectMake(85.0f, 0.0f, 130.0f, 130.0f);
  
  // Menu Area
  UIView * menuArea = [[UIView alloc] initWithFrame:menuAreaFrame];
  self.menuArea = menuArea;
  [menuArea release];
  [self.view addSubview:self.menuArea];
  
  UIView * buttonBagAndRunBackground = [[UIView alloc] initWithFrame:buttonBagAndRunBackgroundFrame];
  self.buttonBagAndRunBackground = buttonBagAndRunBackground;
  [buttonBagAndRunBackground release];
  [self.buttonBagAndRunBackground setBackgroundColor:
   [UIColor colorWithPatternImage:[UIImage imageNamed:@"GameBattleViewMainMenuButtonBagRunBackground.png"]]];
  [self.buttonBagAndRunBackground setOpaque:NO];
  [self.menuArea addSubview:self.buttonBagAndRunBackground];
  
  // Create Menu Buttons
  buttonBag_ = [[UIButton alloc] initWithFrame:buttonBagFrame];
  [buttonBag_ setImage:[UIImage imageNamed:@"GameBattleViewMainMenuButtonBagIcon.png"]
              forState:UIControlStateNormal];
  [buttonBag_ addTarget:self action:@selector(openBagView) forControlEvents:UIControlEventTouchUpInside];
  [self.buttonBagAndRunBackground addSubview:buttonBag_];
  
  buttonRun_ = [[UIButton alloc] initWithFrame:buttonRunFrame];
  [buttonRun_ setImage:[UIImage imageNamed:@"GameBattleViewMainMenuButtonRunIcon.png"]
              forState:UIControlStateNormal];
  [buttonRun_ addTarget:self action:@selector(openRunConfirmView) forControlEvents:UIControlEventTouchUpInside];
  [self.buttonBagAndRunBackground addSubview:buttonRun_];
  
  buttonFight_ = [[UIButton alloc] initWithFrame:buttonFightFrame];
  [buttonFight_ setBackgroundColor:
   [UIColor colorWithPatternImage:[UIImage imageNamed:@"GameBattleViewMainMenuButtonFightBackground.png"]]];
  [buttonFight_ setImage:[UIImage imageNamed:@"GameBattleViewMainMenuButtonFightIcon.png"]
                forState:UIControlStateNormal];
  [buttonFight_ addTarget:self action:@selector(openMoveView) forControlEvents:UIControlEventTouchUpInside];
  [self.buttonBagAndRunBackground addSubview:buttonFight_];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.buttonFight = nil;
  self.buttonBag   = nil;
  self.buttonRun   = nil;
  
  self.gameMenuMoveViewController = nil;
  self.gameMenuBagViewController  = nil;
  self.menuArea = nil;
  self.buttonBagAndRunBackground = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

// Button actions
// Action for |buttonFight_|
- (void)openMoveView {
  if ([[GameStatus sharedInstance] isTrainerTurn]) {
    if (! self.gameMenuMoveViewController) {
      GameMenuMoveViewController * gameMenuMoveViewController = [[GameMenuMoveViewController alloc] init];
      self.gameMenuMoveViewController = gameMenuMoveViewController;
      [gameMenuMoveViewController release];
    }
    [self.view addSubview:self.gameMenuMoveViewController.view];
    [self.gameMenuMoveViewController loadViewWithAnimation];
    self.gameMenuKeyView = kGameMenuKeyViewMoveView;
  }
}

// Action for |buttonBag_|
- (void)openBagView {
  if ([[GameStatus sharedInstance] isTrainerTurn]) {
    if (! self.gameMenuBagViewController) {
      GameMenuBagViewController * gameMenuBagViewController = [[GameMenuBagViewController alloc] init];
      self.gameMenuBagViewController = gameMenuBagViewController;
      [gameMenuBagViewController release];
    }
    [self.view addSubview:self.gameMenuBagViewController.view];
    [self.gameMenuBagViewController loadViewWithAnimation];
    self.gameMenuKeyView = kGameMenuKeyViewBagView;
  }
}

// Action for |buttonRun_|
- (void)openRunConfirmView {
  if ([[GameStatus sharedInstance] isTrainerTurn]) {
    NSLog(@"Open Run Confirm View..");
    [delegate_ unloadBattleScene];
  }
}

// Notification for |centerMainButton_| at view bottom
- (void)toggleSixPokemonsView:(NSNotification *)notification
{
  switch (self.gameMenuKeyView) {
    case kGameMenuKeyViewSixPokemonsView:
      //
      // TODO:
      //   Six Pokemons' List View
      //   Throw PokeBall!!!
      //
      break;
      
    case kGameMenuKeyViewMoveView:
      [self.gameMenuMoveViewController unloadViewWithAnimation];
      break;
      
    case kGameMenuKeyViewBagView:
      if (self.gameMenuBagViewController.isSelectedItemViewOpening)
        [self.gameMenuBagViewController unloadSelcetedItemTalbeView:nil];
      [self.gameMenuBagViewController unloadViewWithAnimation];
      break;
      
    case kGameMenuKeyViewNone:
    default:
      break;
  }
}

@end
