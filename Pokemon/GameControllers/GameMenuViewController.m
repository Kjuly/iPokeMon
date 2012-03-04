//
//  GameMenuViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuViewController.h"

#import "GameMenuMoveViewController.h"
#import "GameMenuBagViewController.h"


@interface GameMenuViewController () {
 @private
  GameMenuMoveViewController * gameMenuMoveViewController_;
  GameMenuBagViewController  * gameMenuBagViewController_;
}

@property (nonatomic, retain) GameMenuMoveViewController * gameMenuMoveViewController;
@property (nonatomic, retain) GameMenuBagViewController  * gameMenuBagViewController;

// Button Actions
- (void)openMoveView;
- (void)openBagView;
- (void)openRunConfirmView;

@end

@implementation GameMenuViewController

@synthesize delegate    = delegate_;
@synthesize buttonFight = buttonFight_;
@synthesize buttonBag   = buttonBag_;
@synthesize buttonRun   = buttonRun_;

@synthesize gameMenuMoveViewController = gameMenuMoveViewController_;
@synthesize gameMenuBagViewController  = gameMenuBagViewController_;

- (void)dealloc
{
  self.delegate = nil;
  
  [buttonFight_ release];
  [buttonBag_   release];
  [buttonRun_   release];
  
  [gameMenuMoveViewController_ release];
  [gameMenuBagViewController_  release];
  
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
  
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 280.0f, 320.0f, 200.0f)];
  self.view = view;
  [view release];
  [self.view setBackgroundColor:[UIColor grayColor]];
  
  // Constants
  CGRect buttonFightFrame = CGRectMake(10.0f, 5.0f, 300.0f, 70.0f);
  CGRect buttonBagFrame   = CGRectMake(10.0f, 85.0f, 145.0f, 70.0f);
  CGRect buttonRunFrame   = CGRectMake(165.0f, 85.0f, 145.0f, 70.0f);
  
  // Create Menu Buttons
  buttonFight_ = [[UIButton alloc] initWithFrame:buttonFightFrame];
  [buttonFight_ setBackgroundColor:[UIColor blackColor]];
  [buttonFight_ setTitle:@"Fight" forState:UIControlStateNormal];
  [buttonFight_ addTarget:self action:@selector(openMoveView) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:buttonFight_];
  
  buttonBag_ = [[UIButton alloc] initWithFrame:buttonBagFrame];
  [buttonBag_ setBackgroundColor:[UIColor blackColor]];
  [buttonBag_ setTitle:@"Bag" forState:UIControlStateNormal];
  [buttonBag_ addTarget:self action:@selector(openBagView) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:buttonBag_];
  
  buttonRun_ = [[UIButton alloc] initWithFrame:buttonRunFrame];
  [buttonRun_ setBackgroundColor:[UIColor blackColor]];
  [buttonRun_ setTitle:@"Run" forState:UIControlStateNormal];
  [buttonRun_ addTarget:self action:@selector(openRunConfirmView) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:buttonRun_];
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

// Button actions
// Action for |buttonFight_|
- (void)openMoveView
{
  if (! self.gameMenuMoveViewController) {
    GameMenuMoveViewController * gameMenuMoveViewController = [[GameMenuMoveViewController alloc] init];
    self.gameMenuMoveViewController = gameMenuMoveViewController;
    [gameMenuMoveViewController release];
  }
  [self.view addSubview:self.gameMenuMoveViewController.view];
}

// Action for |buttonBag_|
- (void)openBagView
{
  if (! self.gameMenuBagViewController) {
    GameMenuBagViewController * gameMenuBagViewController = [[GameMenuBagViewController alloc] init];
    self.gameMenuBagViewController = gameMenuBagViewController;
    [gameMenuBagViewController release];
  }
  [self.view addSubview:self.gameMenuBagViewController.view];
}

// Action for |buttonRun_|
- (void)openRunConfirmView
{
  NSLog(@"Open Run Confirm View..");
  [delegate_ unloadBattleScene];
}

@end
