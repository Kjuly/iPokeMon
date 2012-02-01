//
//  UtilityViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "UtilityViewController.h"

#import "../GlobalConstants.h"


@implementation UtilityViewController

@synthesize utilityBar        = utilityBar_;
@synthesize buttonLocateMe    = buttonLocateMe_;
@synthesize buttonShowWorld   = buttonShowWorld_;
@synthesize buttonDiscover    = buttonDiscover_;
@synthesize buttonSetAccount  = buttonSetAccount_;

- (void)dealloc
{
  [utilityBar_ release];
  [buttonLocateMe_ release];
  [buttonShowWorld_ release];
  [buttonDiscover_ release];
  [buttonSetAccount_ release];
  
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
  
  // Utility Bar
  UIView * utilityBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, kMapViewHeight, 320.0f, kUtilityViewHeight)];
  self.utilityBar = utilityBar;
  [utilityBar release];
  
  [self.utilityBar setBackgroundColor:[UIColor colorWithWhite:0.9f alpha:1.0f]];
  [self.view addSubview:self.utilityBar];
  
  // Four buttons
  {
    {
      UIButton * buttonLocateMe = [[UIButton alloc] initWithFrame:CGRectMake(kUtilityButtonWidth * 1, 0.0f, kUtilityButtonWidth, kUtilityViewHeight)];
      self.buttonLocateMe = buttonLocateMe;
      [buttonLocateMe release];
      
      [self.buttonLocateMe setImage:[UIImage imageNamed:@"UtilityView_LocateMe.png"] forState:UIControlStateNormal];
      
      [self.utilityBar addSubview:self.buttonLocateMe];
    }
    {
      UIButton * buttonShowWorld = [[UIButton alloc] initWithFrame:CGRectMake(kUtilityButtonWidth * 2, 0.0f, kUtilityButtonWidth, kUtilityViewHeight)];
      self.buttonShowWorld = buttonShowWorld;
      [buttonShowWorld release];
      
      [self.buttonShowWorld setImage:[UIImage imageNamed:@"UtilityView_ShowWorld.png"] forState:UIControlStateNormal];
      
      [self.utilityBar addSubview:self.buttonShowWorld];
    }
    {
      UIButton * buttonDiscover = [[UIButton alloc] initWithFrame:CGRectMake(320.0f - kUtilityButtonWidth * 3, 0.0f, kUtilityButtonWidth, kUtilityViewHeight)];
      self.buttonDiscover = buttonDiscover;
      [buttonDiscover release];
      
      [self.buttonDiscover setImage:[UIImage imageNamed:@"UtilityView_Discover.png"] forState:UIControlStateNormal];
      
      [self.utilityBar addSubview:self.buttonDiscover];
    }
    {
      UIButton * buttonSetAccount = [[UIButton alloc] initWithFrame:CGRectMake(320.0f - kUtilityButtonWidth * 2, 0.0f, kUtilityButtonWidth, kUtilityViewHeight)];
      self.buttonSetAccount = buttonSetAccount;
      [buttonSetAccount release];
      
      [self.buttonSetAccount setImage:[UIImage imageNamed:@"UtilityView_SetAccount.png"] forState:UIControlStateNormal];
      
      [self.utilityBar addSubview:self.buttonSetAccount];
    }
  }
  
  // Ball menu which locate at center
  UIButton * buttonOpenBallMenu = [[UIButton alloc] initWithFrame:CGRectMake(kUtilityButtonWidth * 3, kMapViewHeight, 104.0f, kUtilityViewHeight)];
  
  [buttonOpenBallMenu setImage:[UIImage imageNamed:@"UtilityBallMenuIconSmall.png"] forState:UIControlStateNormal];
  
  [self.view addSubview:buttonOpenBallMenu];
  [buttonOpenBallMenu release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];

  self.utilityBar       = nil;
  self.buttonLocateMe   = nil;
  self.buttonShowWorld  = nil;
  self.buttonDiscover   = nil;
  self.buttonSetAccount = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
