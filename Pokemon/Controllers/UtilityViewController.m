//
//  UtilityViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "UtilityViewController.h"

#import "../GlobalConstants.h"
#import "GlobalColor.h"
#import "AccountSettingTableViewController.h"

@interface UtilityViewController (PrivateMethods)

- (void)locateMe:(id)sender;
- (void)showWorld:(id)sender;
- (void)discover:(id)sender;
- (void)setAccount:(id)sender;

@end


@implementation UtilityViewController

@synthesize buttonLocateMe    = buttonLocateMe_;
@synthesize buttonShowWorld   = buttonShowWorld_;
@synthesize buttonDiscover    = buttonDiscover_;
@synthesize buttonSetAccount  = buttonSetAccount_;

- (void)dealloc
{
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
  
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, kMapViewHeight - 2.0f, 320.0f, kUtilityBarHeight + 5.0f)];
  self.view = view;
  [view release];
  [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"UtilityBarBackground.png"]]];
  
  // Four buttons
  {
    UIImage * buttonBackgroundImage = [UIImage imageNamed:@"UtilityBarButtonBackground.png"];
    CGFloat buttonWidth = buttonBackgroundImage.size.width;
    CGFloat buttonHeight= buttonBackgroundImage.size.height;
    CGFloat buttonMarginTop = (kUtilityBarHeight + 4.0f - buttonHeight) / 2.0f;
    
    {
      UIButton * buttonLocateMe = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth * 1.6,
                                                                             buttonMarginTop,
                                                                             buttonWidth,
                                                                             buttonHeight)];
      self.buttonLocateMe = buttonLocateMe;
      [buttonLocateMe release];
      
      [self.buttonLocateMe setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
      [self.buttonLocateMe setImage:[UIImage imageNamed:@"UtilityView_LocateMe.png"] forState:UIControlStateNormal];
      [self.buttonLocateMe addTarget:self action:@selector(locateMe:) forControlEvents:UIControlEventTouchUpInside];
      
      [self.view addSubview:self.buttonLocateMe];
    }
    {
      UIButton * buttonShowWorld = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth * 3.2f,
                                                                              buttonMarginTop,
                                                                              buttonWidth,
                                                                              buttonHeight)];
      self.buttonShowWorld = buttonShowWorld;
      [buttonShowWorld release];
      
      [self.buttonShowWorld setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
      [self.buttonShowWorld setImage:[UIImage imageNamed:@"UtilityView_ShowWorld.png"] forState:UIControlStateNormal];
      [self.buttonShowWorld addTarget:self action:@selector(showWorld:) forControlEvents:UIControlEventTouchUpInside];
      
      [self.view addSubview:self.buttonShowWorld];
    }
    {
      UIButton * buttonDiscover = [[UIButton alloc] initWithFrame:CGRectMake(320.0f - buttonWidth * 3.2 - buttonWidth,
                                                                             buttonMarginTop,
                                                                             buttonWidth,
                                                                             buttonHeight)];
      self.buttonDiscover = buttonDiscover;
      [buttonDiscover release];
      
      [self.buttonDiscover setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
      [self.buttonDiscover setImage:[UIImage imageNamed:@"UtilityView_Discover.png"] forState:UIControlStateNormal];
      [self.buttonDiscover addTarget:self action:@selector(discover:) forControlEvents:UIControlEventTouchUpInside];
      
      [self.view addSubview:self.buttonDiscover];
    }
    {
      UIButton * buttonSetAccount = [[UIButton alloc] initWithFrame:CGRectMake(320.0f - buttonWidth * 1.6 - buttonWidth,
                                                                               buttonMarginTop,
                                                                               buttonWidth,
                                                                               buttonHeight)];
      self.buttonSetAccount = buttonSetAccount;
      [buttonSetAccount release];
      
      [self.buttonSetAccount setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
      [self.buttonSetAccount setImage:[UIImage imageNamed:@"UtilityView_SetAccount.png"] forState:UIControlStateNormal];
      [self.buttonSetAccount addTarget:self action:@selector(setAccount:) forControlEvents:UIControlEventTouchUpInside];
      
      [self.view addSubview:self.buttonSetAccount];
    }
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

#pragma mark - Button Actions (Private)

- (void)locateMe:(id)sender
{
}

- (void)showWorld:(id)sender
{
}

- (void)discover:(id)sender
{
}

- (void)setAccount:(id)sender
{
  AccountSettingTableViewController * accountSettingTableViewController = [[AccountSettingTableViewController alloc] initWithStyle:UITableViewStylePlain];
  [accountSettingTableViewController.view setAlpha:0.0f];
  [accountSettingTableViewController.view setFrame:CGRectMake(30.0f, 45.0f, 260.0f, 390.0f)];
  [[UIApplication sharedApplication].delegate.window addSubview:accountSettingTableViewController.view];
  
  [UIView animateWithDuration:0.3f
                        delay:0.0f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     [accountSettingTableViewController.view setAlpha:1.0f];
                     [accountSettingTableViewController.view setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
                   }
                   completion:nil];
  
  [accountSettingTableViewController release];
}

@end
