//
//  UtilityBallMenuViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "UtilityBallMenuViewController.h"

#import "../GlobalConstants.h"
#import "PokedexTableViewController.h"

@implementation UtilityBallMenuViewController

@synthesize buttonOpen = buttonOpen_;

@synthesize ballMenu              = ballMenu_;
@synthesize buttonShowPokedex     = buttonShowPokedex_;
@synthesize buttonShowPokemon     = buttonShowPokemon_;
@synthesize buttonShowBag         = buttonShowBag_;
@synthesize buttonShowTrainerCard = buttonShowTrainerCard_;
@synthesize buttonHotkey          = buttonHotkey_;
@synthesize buttonSetGame         = buttonSetGame_;
@synthesize buttonClose           = buttonClose_;

@synthesize pokedexTableViewController = pokedexTableViewController_;

-(void)dealloc
{
  [buttonOpen_ release];
  
  [ballMenu_ release];
  [buttonShowPokedex_ release];
  [buttonShowPokemon_ release];
  [buttonShowBag_ release];
  [buttonShowTrainerCard_ release];
  [buttonHotkey_ release];
  [buttonSetGame_ release];
  [buttonClose_ release];
  
  [pokedexTableViewController_ release];
  
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
  [self.view setBackgroundColor:[UIColor clearColor]];
  
  // Ball Menu View
  UIView * ballMenu = [[UIView alloc] initWithFrame:CGRectMake((320.0f - kUtilityBallMenuWidth) / 2.0f,
                                                              kMapViewHeight + kUtilityBarHeight / 2 - kUtilityBallMenuHeight / 2,
                                                              kUtilityBallMenuWidth,
                                                              kUtilityBallMenuHeight)];
  self.ballMenu = ballMenu;
  [ballMenu release];
  
  [self.ballMenu setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"UtilityBallMenuIconBig.png"]]];
  [self.view addSubview:self.ballMenu];
  
  // Buttons in Ball Menu View
  //
  //  Triangle Values for Buttons' Position
  // 
  //      /|      a: triangleA = c * COSx 
  //   c / | b    b: triangleB = c * SINx
  //    /)x|      c: triangleHypotenuse
  //   -----      x: degree
  //     a
  //
  float degree = 60.0f * M_PI / 180.0f;
  float triangleHypotenuse = kDistanceFromUtilityBallCenter;
  float triangleA = triangleHypotenuse * cosf(degree);
  float triangleB = triangleHypotenuse * sinf(degree);
  float buttonRadius = kUtilityBallMenuButtonDiameter / 2.0f;
  
  {
    // Button: Show Pokedex
    //
    //   o
    //    \|/
    //   --|--
    //    /|\
    //
    buttonShowPokedex_ = [[UIButton alloc] initWithFrame:CGRectMake(kUtilityBallMenuWidth / 2 - triangleB - buttonRadius,
                                                                    kUtilityBallMenuHeight / 2 - triangleA - buttonRadius,
                                                                    kUtilityBallMenuButtonDiameter,
                                                                    kUtilityBallMenuButtonDiameter)];
    [buttonShowPokedex_ setBackgroundColor:[UIColor redColor]];
    [buttonShowPokedex_ setTag:kTagUtilityBallButtonShowPokedex];
    [buttonShowPokedex_ addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.ballMenu addSubview:buttonShowPokedex_];
  }{
    // Button: Show Pokemon
    //
    //     o
    //    \|/
    //   --|--
    //    /|\
    //
    buttonShowPokemon_ = [[UIButton alloc] initWithFrame:CGRectMake(kUtilityBallMenuWidth / 2 - buttonRadius,
                                                                    kUtilityBallMenuHeight / 2 - triangleHypotenuse - buttonRadius,
                                                                    kUtilityBallMenuButtonDiameter,
                                                                    kUtilityBallMenuButtonDiameter)];
    [buttonShowPokemon_ setBackgroundColor:[UIColor redColor]];
    [buttonShowPokemon_ setTag:kTagUtilityBallButtonShowPokemon];
    [buttonShowPokemon_ addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.ballMenu addSubview:buttonShowPokemon_];
  }{
    // Button: Show Bag
    //
    //       o
    //    \|/
    //   --|--
    //    /|\
    //
    buttonShowBag_ = [[UIButton alloc] initWithFrame:CGRectMake(kUtilityBallMenuWidth / 2 + triangleB - buttonRadius,
                                                                kUtilityBallMenuHeight / 2 - triangleA - buttonRadius,
                                                                kUtilityBallMenuButtonDiameter,
                                                                kUtilityBallMenuButtonDiameter)];
    [buttonShowBag_ setBackgroundColor:[UIColor redColor]];
    [buttonShowBag_ setTag:kTagUtilityBallButtonShowBag];
    [buttonShowBag_ addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.ballMenu addSubview:buttonShowBag_];
  }{
    // Button: Show Trainer Card
    //
    //    \|/
    //   --|--
    //    /|\
    //   o
    //
    buttonShowTrainerCard_ = [[UIButton alloc] initWithFrame:CGRectMake(kUtilityBallMenuWidth / 2 - triangleB - buttonRadius,
                                                                        kUtilityBallMenuHeight / 2 + triangleA - buttonRadius,
                                                                        kUtilityBallMenuButtonDiameter,
                                                                        kUtilityBallMenuButtonDiameter)];
    [buttonShowTrainerCard_ setBackgroundColor:[UIColor redColor]];
    [buttonShowTrainerCard_ setTag:kTagUtilityBallButtonShowTrainerCard];
    [buttonShowTrainerCard_ addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.ballMenu addSubview:buttonShowTrainerCard_];
  }{
    // Button: Hot Key
    //
    //    \|/
    //   --|--
    //    /|\
    //     o
    //
    buttonHotkey_ = [[UIButton alloc] initWithFrame:CGRectMake(kUtilityBallMenuWidth / 2 - buttonRadius,
                                                               kUtilityBallMenuHeight / 2 + triangleHypotenuse - buttonRadius,
                                                               kUtilityBallMenuButtonDiameter,
                                                               kUtilityBallMenuButtonDiameter)];
    [buttonHotkey_ setBackgroundColor:[UIColor redColor]];
    [buttonHotkey_ setTag:kTagUtilityBallButtonHotkey];
    [buttonHotkey_ addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.ballMenu addSubview:buttonHotkey_];
  }{
    // Button: Set Game
    //
    //    \|/
    //   --|--
    //    /|\
    //       o
    //
    buttonSetGame_ = [[UIButton alloc] initWithFrame:CGRectMake(kUtilityBallMenuWidth / 2 + triangleB - buttonRadius,
                                                                kUtilityBallMenuHeight / 2 + triangleA - buttonRadius,
                                                                kUtilityBallMenuButtonDiameter,
                                                                kUtilityBallMenuButtonDiameter)];
    [buttonSetGame_ setBackgroundColor:[UIColor redColor]];
    [buttonSetGame_ setTag:kTagUtilityBallButtonSetGame];
    [buttonSetGame_ addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.ballMenu addSubview:buttonSetGame_];
  }{
    // Button: Close
    //
    //    \|/
    //   - o -
    //    /|\
    //
    buttonClose_ = [[UIButton alloc] initWithFrame:CGRectMake(kUtilityBallMenuWidth / 2 - buttonRadius,
                                                              kUtilityBallMenuHeight / 2 - buttonRadius,
                                                              kUtilityBallMenuButtonDiameter,
                                                              kUtilityBallMenuButtonDiameter)];
    [buttonClose_ setBackgroundColor:[UIColor redColor]];
    [buttonClose_ setTag:kTagUtilityBallButtonClose];
    [buttonClose_ addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.ballMenu addSubview:buttonClose_];
  }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];

  self.buttonOpen = nil;
  
  self.ballMenu               = nil;
  self.buttonShowPokedex      = nil;
  self.buttonShowPokemon      = nil;
  self.buttonShowBag          = nil;
  self.buttonShowTrainerCard  = nil;
  self.buttonHotkey           = nil;
  self.buttonSetGame          = nil;
  self.buttonClose            = nil;
  
  self.pokedexTableViewController = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
//  if (! self.navigationController.isNavigationBarHidden)
//    [self.navigationController setNavigationBarHidden:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - CustomNavigationControllerDelegate

- (BOOL)hasNavigationBar {
  return NO;
}

- (UIImage *)navigationBarBackgroundImage {
  return [UIImage imageNamed:@"UtilityNavigationBarBackground.png"];
}

#pragma mark - Button Action

- (void)runButtonActions:(id)sender
{
  switch ([(UIButton *)sender tag]) {
    case kTagUtilityBallButtonShowPokedex:
      [self showPokedex:sender];
      break;
      
    case kTagUtilityBallButtonClose:
      [self closeView:sender];
      break;
      
    default:
      break;
  }
}

- (void)showPokedex:(id)sender
{  
  if (! self.pokedexTableViewController) {
    PokedexTableViewController * pokedexTableViewController = [[PokedexTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.pokedexTableViewController = pokedexTableViewController;
    [pokedexTableViewController release];
  }
  [self.navigationController pushViewController:self.pokedexTableViewController animated:YES];
}

- (void)showPokemon:(id)sender {
  NSLog(@"--- Button Clicked: showPokemon");
}

- (void)showBag:(id)sender {
  NSLog(@"--- Button Clicked: showBag");
}

- (void)showTrainerCard:(id)sender {
  NSLog(@"--- Button Clicked: showTrainerCard");
}

- (void)runHotkey:(id)sender {
  NSLog(@"--- Button Clicked: runHotKey");
}

- (void)setGame:(id)sender {
  NSLog(@"--- Button Clicked: setGame");
}

- (void)closeView:(id)sender {
  [self.navigationController.view removeFromSuperview];
}

@end
