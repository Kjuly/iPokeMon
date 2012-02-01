//
//  UtilityBallMenuViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "UtilityBallMenuViewController.h"

#import "../GlobalConstants.h"

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
  
  // Button: Open Big Menu
  UIView * ballMenu = [[UIView alloc] initWithFrame:CGRectMake((320.0f - kUtilityBallMenuWidth) / 2.0f,
                                                              kMapViewHeight + kUtilityBarHeight / 2 - kUtilityBallMenuHeight / 2,
                                                              kUtilityBallMenuWidth,
                                                              kUtilityBallMenuHeight)];
  self.ballMenu = ballMenu;
  [ballMenu release];
  
  [self.ballMenu setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"UtilityBallMenuIconBig.png"]]];
  [self.view addSubview:self.ballMenu];
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
