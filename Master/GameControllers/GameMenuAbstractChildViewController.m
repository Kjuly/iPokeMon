//
//  GameMenuMoveViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuAbstractChildViewController.h"

@implementation GameMenuAbstractChildViewController

@synthesize tableAreaView = tableAreaView_;

- (id)init
{
  return (self = [super init]);
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
  UIView * view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, {kViewWidth, kViewHeight}}];
  [view setBackgroundColor:[UIColor clearColor]];
  
  // Create Table Area View
  CGRect tableAreaViewFrame  = (CGRect){CGPointZero, {88.f, kViewHeight}};
  UIView * tableAreaView = [[UIView alloc] initWithFrame:tableAreaViewFrame];
  self.tableAreaView = tableAreaView;
  [view addSubview:self.tableAreaView];
  
  self.view = view;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.tableAreaView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

- (void)loadViewWithAnimationFromLeft:(BOOL)fromLeft
                             animated:(BOOL)animated
{
  CGRect viewFrame = self.view.frame;
  viewFrame.origin.x = fromLeft ? -kViewWidth : kViewWidth;
  [self.view setFrame:viewFrame];
  viewFrame.origin.x = 0.f;
  
  if (! animated) [self.view setFrame:viewFrame];
  else [UIView animateWithDuration:.3f
                             delay:0.f
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{ [self.view setFrame:viewFrame]; }
                        completion:nil];
}

- (void)unloadViewWithAnimationToLeft:(BOOL)toLeft
                             animated:(BOOL)animated
{
  CGRect viewFrame = self.view.frame;
  viewFrame.origin.x = toLeft ? -kViewWidth : kViewWidth;
  
  if (! animated) {
    [self.view setFrame:viewFrame];
    [self.view removeFromSuperview];
  }
  else [UIView animateWithDuration:.3f
                             delay:0.f
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{ [self.view setFrame:viewFrame]; }
                        completion:^(BOOL finished) { [self.view removeFromSuperview]; }];
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUpdateGameMenuKeyView
                                                      object:self
                                                    userInfo:nil];
}

// action for swipe gesture
- (void)swipeView:(UISwipeGestureRecognizer *)recognizer
{
  switch (recognizer.direction) {
    case UISwipeGestureRecognizerDirectionRight:
      [self unloadViewWithAnimationToLeft:NO animated:YES];
      break;
      
    case UISwipeGestureRecognizerDirectionLeft:
      [self unloadViewWithAnimationToLeft:YES animated:YES];
      break;
      
    default:
      return;
      break;
  }
}

@end
