//
//  UtilityBallMenuViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "AbstractCenterMenuViewController.h"

#import "GlobalConstants.h"
#import "GlobalNotificationConstants.h"
#import "GlobalRender.h"
#import "PokedexTableViewController.h"
#import "SixPokemonsTableViewController.h"
#import "BagTableViewController.h"
#import "TrainerCardViewController.h"
#import "GameSettingTableViewController.h"


@interface AbstractCenterMenuViewController () {
 @private
  NSInteger buttonCount_;
}

@property (nonatomic, assign) NSInteger buttonCount;

- (void)computeAndSetButtonLayout;
- (void)setButtonWithTag:(NSInteger)buttonTag origin:(CGPoint)origin;

@end


@implementation AbstractCenterMenuViewController

@synthesize ballMenu    = ballMenu_;
@synthesize buttonClose = buttonClose_;

@synthesize buttonCount = buttonCount_;

-(void)dealloc
{
  [ballMenu_    release];
  [buttonClose_ release];
  
  [super dealloc];
}

- (id)initWithButtonCount:(NSInteger)buttonCount
{
  if (self = [self init]) {
    buttonCount_ = buttonCount; // Min: 1, Max: 6
  }
  return self;
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
  
  // Ball Menu View
  UIView * ballMenu = [[UIView alloc] initWithFrame:CGRectMake((320.0f - kCenterMenuSize) / 2,
                                                              (480.0f - kCenterMenuSize) / 2,
                                                              kCenterMenuSize,
                                                              kCenterMenuSize)];
  self.ballMenu = ballMenu;
  [ballMenu release];
  [self.ballMenu setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainViewCenterCircle.png"]]];
  [self.ballMenu setOpaque:NO];
  [self.view addSubview:self.ballMenu];
  
  // Add buttons to |ballMenu_|
  for (int i = 0; i < self.buttonCount;) {
    UIButton * button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"]
                      forState:UIControlStateNormal];
    [button setOpaque:NO];
    [button setTag:++i];
    [button addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.ballMenu addSubview:button];
    [button release];
  }
  
  // Compute buttons' frame and set for them, based on |buttonCount|
  [self computeAndSetButtonLayout];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];

  self.ballMenu    = nil;
  self.buttonClose = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Button Action

- (void)runButtonActions:(id)sender
{
  switch ([(UIButton *)sender tag]) {
    case kTagUtilityBallButtonClose:
      [self closeView:sender];
      break;
      
    default:
      break;
  }
}

- (void)closeView:(id)sender {
  [self.navigationController.view removeFromSuperview];
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNResetMainView object:self userInfo:nil];
}

#pragma mark - Private Methods

// Compute buttons' layout based on |buttonCount|
- (void)computeAndSetButtonLayout
{
  //
  //  Triangle Values for Buttons' Position
  // 
  //      /|      a: triangleA = c * COSx 
  //   c / | b    b: triangleB = c * SINx
  //    /)x|      c: triangleHypotenuse
  //   -----      x: degree
  //     a
  //
  CGFloat centerBallMenuHalfSize = kCenterMenuSize / 2.0f;
  CGFloat buttonRadius           = kCenterMenuButtonSize / 2.0f;
  CGFloat triangleHypotenuse     = 112.0f;                       // Distance to Ball Center
  
  //
  //      o       o   o      o   o     o   o     o o o     o o o
  //     \|/       \|/        \|/       \|/       \|/       \|/
  //  1 --|--   2 --|--    3 --|--   4 --|--   5 --|--   6 --|--
  //     /|\       /|\        /|\       /|\       /|\       /|\
  //                           o       o   o     o   o     o o o
  //
  switch (self.buttonCount) {
    case 1: 
    {
      [self setButtonWithTag:1 origin:CGPointMake(centerBallMenuHalfSize - buttonRadius,
                                                  centerBallMenuHalfSize - triangleHypotenuse - buttonRadius)];
    }
      break;
      
    case 2:
    {
      CGFloat degree    = M_PI / 4.0f; // = 45 * M_PI / 180
      CGFloat triangleB = triangleHypotenuse * sinf(degree);
      CGFloat negativeValue = centerBallMenuHalfSize - triangleB - buttonRadius;
      CGFloat positiveValue = centerBallMenuHalfSize + triangleB - buttonRadius;
      [self setButtonWithTag:1 origin:CGPointMake(negativeValue, negativeValue)];
      [self setButtonWithTag:2 origin:CGPointMake(positiveValue, negativeValue)];
    }
      break;
      
    case 3:
    {
      // = 360.0f / self.buttonCount * M_PI / 180.0f;
      // E.g: if |buttonCount_ = 6|, then |degree = 60.0f * M_PI / 180.0f|;
      // CGFloat degree = 2 * M_PI / self.buttonCount;
      //
      CGFloat degree    = M_PI / 3.0f; // = 60 * M_PI / 180
      CGFloat triangleA = triangleHypotenuse * cosf(degree);
      CGFloat triangleB = triangleHypotenuse * sinf(degree);
      [self setButtonWithTag:1 origin:CGPointMake(centerBallMenuHalfSize - triangleB - buttonRadius,
                                                  centerBallMenuHalfSize - triangleA - buttonRadius)];
      [self setButtonWithTag:2 origin:CGPointMake(centerBallMenuHalfSize + triangleB - buttonRadius,
                                                  centerBallMenuHalfSize - triangleA - buttonRadius)];
      [self setButtonWithTag:3 origin:CGPointMake(centerBallMenuHalfSize - buttonRadius,
                                                  centerBallMenuHalfSize + triangleHypotenuse - buttonRadius)];
    }
      break;
      
    case 4:
    {
      CGFloat degree    = M_PI / 4.0f; // = 45 * M_PI / 180
      CGFloat triangleB = triangleHypotenuse * sinf(degree);
      CGFloat negativeValue = centerBallMenuHalfSize - triangleB - buttonRadius;
      CGFloat positiveValue = centerBallMenuHalfSize + triangleB - buttonRadius;
      [self setButtonWithTag:1 origin:CGPointMake(negativeValue, negativeValue)];
      [self setButtonWithTag:2 origin:CGPointMake(positiveValue, negativeValue)];
      [self setButtonWithTag:3 origin:CGPointMake(negativeValue, positiveValue)];
      [self setButtonWithTag:4 origin:CGPointMake(positiveValue, positiveValue)];
    }
      break;
      
    case 5:
    {
      CGFloat degree    = M_PI / 2.5f; // = 72 * M_PI / 180
      CGFloat triangleA = triangleHypotenuse * cosf(degree);
      CGFloat triangleB = triangleHypotenuse * sinf(degree);
      [self setButtonWithTag:1 origin:CGPointMake(centerBallMenuHalfSize - triangleB - buttonRadius,
                                                  centerBallMenuHalfSize - triangleA - buttonRadius)];
      [self setButtonWithTag:2 origin:CGPointMake(centerBallMenuHalfSize - buttonRadius,
                                                  centerBallMenuHalfSize - triangleHypotenuse - buttonRadius)];
      [self setButtonWithTag:3 origin:CGPointMake(centerBallMenuHalfSize + triangleB - buttonRadius,
                                                  centerBallMenuHalfSize - triangleA - buttonRadius)];
      
      degree    = M_PI / 5.0f;  // = 36 * M_PI / 180
      triangleA = triangleHypotenuse * cosf(degree);
      triangleB = triangleHypotenuse * sinf(degree);
      [self setButtonWithTag:4 origin:CGPointMake(centerBallMenuHalfSize - triangleB - buttonRadius,
                                                  centerBallMenuHalfSize + triangleA - buttonRadius)];
      [self setButtonWithTag:5 origin:CGPointMake(centerBallMenuHalfSize + triangleB - buttonRadius,
                                                  centerBallMenuHalfSize + triangleA - buttonRadius)];
    }
      break;
      
    case 6:
    {
      CGFloat degree    = M_PI / 3.0f; // = 60 * M_PI / 180
      CGFloat triangleA = triangleHypotenuse * cosf(degree);
      CGFloat triangleB = triangleHypotenuse * sinf(degree);
      [self setButtonWithTag:1 origin:CGPointMake(centerBallMenuHalfSize - triangleB - buttonRadius,
                                                  centerBallMenuHalfSize - triangleA - buttonRadius)];
      [self setButtonWithTag:2 origin:CGPointMake(centerBallMenuHalfSize - buttonRadius,
                                                  centerBallMenuHalfSize - triangleHypotenuse - buttonRadius)];
      [self setButtonWithTag:3 origin:CGPointMake(centerBallMenuHalfSize + triangleB - buttonRadius,
                                                  centerBallMenuHalfSize - triangleA - buttonRadius)];
      [self setButtonWithTag:4 origin:CGPointMake(centerBallMenuHalfSize - triangleB - buttonRadius,
                                                  centerBallMenuHalfSize + triangleA - buttonRadius)];
      [self setButtonWithTag:5 origin:CGPointMake(centerBallMenuHalfSize - buttonRadius,
                                                  centerBallMenuHalfSize + triangleHypotenuse - buttonRadius)];
      [self setButtonWithTag:6 origin:CGPointMake(centerBallMenuHalfSize + triangleB - buttonRadius,
                                                  centerBallMenuHalfSize + triangleA - buttonRadius)];
    }
      break;
      
    default:
      break;
  }
}

// Set Frame for button with special tag
- (void)setButtonWithTag:(NSInteger)buttonTag origin:(CGPoint)origin
{
  if (buttonTag <= 0 || buttonTag > 6)
    return;
  
  UIButton * button = (UIButton *)[self.ballMenu viewWithTag:buttonTag];
  [button setFrame:CGRectMake(origin.x, origin.y, kCenterMenuButtonSize, kCenterMenuButtonSize)];
  button = nil;
}
@end
