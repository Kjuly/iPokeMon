//
//  GameMenuViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuViewController.h"

@implementation GameMenuViewController

@synthesize buttonFight = buttonFight_;
@synthesize buttonBag   = buttonBag_;
@synthesize buttonRun   = buttonRun_;

- (void)dealloc
{
  [buttonFight_ release];
  [buttonBag_   release];
  [buttonRun_   release];
  
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
  [self.view addSubview:buttonFight_];
  
  buttonBag_ = [[UIButton alloc] initWithFrame:buttonBagFrame];
  [buttonBag_ setBackgroundColor:[UIColor blackColor]];
  [buttonBag_ setTitle:@"Bag" forState:UIControlStateNormal];
  [self.view addSubview:buttonBag_];
  
  buttonRun_ = [[UIButton alloc] initWithFrame:buttonRunFrame];
  [buttonRun_ setBackgroundColor:[UIColor blackColor]];
  [buttonRun_ setTitle:@"Run" forState:UIControlStateNormal];
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
