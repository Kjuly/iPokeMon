//
//  GameMenuMoveViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuAbstractChildViewController.h"

#import <QuartzCore/QuartzCore.h>


@interface GameMenuAbstractChildViewController () {
 @private
  CAAnimationGroup * animationGroupToShow_;
  CAAnimationGroup * animationGroupToHide_;
}

@property (nonatomic, retain) CAAnimationGroup * animationGroupToShow;
@property (nonatomic, retain) CAAnimationGroup * animationGroupToHide;

@end


@implementation GameMenuAbstractChildViewController

@synthesize tableAreaView        = tableAreaView_;
@synthesize animationGroupToShow = animationGroupToShow_;
@synthesize animationGroupToHide = animationGroupToHide_;

- (void)dealloc
{
  [tableAreaView_ release];
  self.animationGroupToShow = nil;
  self.animationGroupToHide = nil;
  
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
  
  // Create Move Area View
  CGRect tableAreaViewFrame  = CGRectMake(10.0f, 220.0f, 300.0f, 220.0f);
  UIView * tableAreaView = [[UIView alloc] initWithFrame:tableAreaViewFrame];
  self.tableAreaView = tableAreaView;
  [tableAreaView release];
  [self.tableAreaView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"GameViewPokemonMoveView.png"]]];
  [self.tableAreaView setOpaque:NO];
  [self.tableAreaView.layer setCornerRadius:20.0f];
  [self.view addSubview:tableAreaView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Set up animations
  // Animation group to show view
  CGFloat duration = .3f;
  CAKeyframeAnimation * animationScaleToShow = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
  animationScaleToShow.duration = duration;
  animationScaleToShow.values = [NSArray arrayWithObjects:
                                 [NSNumber numberWithFloat:.8f],
                                 [NSNumber numberWithFloat:1.2f],
                                 [NSNumber numberWithFloat:1.f], nil];
  
  CABasicAnimation * animationFadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
  animationFadeIn.duration = duration * .4f;
  animationFadeIn.fromValue = [NSNumber numberWithFloat:0.f];
  animationFadeIn.toValue = [NSNumber numberWithFloat:1.f];
  animationFadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  animationFadeIn.fillMode = kCAFillModeForwards;
  
  self.animationGroupToShow = [CAAnimationGroup animation];
  self.animationGroupToShow.delegate = self;
  [self.animationGroupToShow setValue:@"show" forKey:@"animationType"];
  [self.animationGroupToShow setDuration:duration];
  NSArray * animationsToShow = [[NSArray alloc] initWithObjects:animationScaleToShow, animationFadeIn, nil];
  [self.animationGroupToShow setAnimations:animationsToShow];
  [animationsToShow release];
  [self.animationGroupToShow setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
  
  // Animation group to hide view
  CAKeyframeAnimation * animationScaleToHide = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
  animationScaleToHide.duration = duration;
  animationScaleToHide.values = [NSArray arrayWithObjects:
                                 [NSNumber numberWithFloat:1.f],
                                 [NSNumber numberWithFloat:1.5f], nil];
  
  CABasicAnimation * animationFadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
  animationFadeOut.duration = duration;
  animationFadeOut.fromValue = [NSNumber numberWithFloat:1.f];
  animationFadeOut.toValue = [NSNumber numberWithFloat:0.f];
  animationFadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  animationFadeOut.fillMode = kCAFillModeForwards;
  
  self.animationGroupToHide = [CAAnimationGroup animation];
  self.animationGroupToHide.delegate = self;
  [self.animationGroupToHide setValue:@"hide" forKey:@"animationType"];
  [self.animationGroupToHide setDuration:duration];
  NSArray * animationsToHide = [[NSArray alloc] initWithObjects:animationScaleToHide, animationFadeOut, nil];
  [self.animationGroupToHide setAnimations:animationsToHide];
  [animationsToHide release];
  [self.animationGroupToHide setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.tableAreaView   = nil;
  self.animationGroupToShow = nil;
  self.animationGroupToHide = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

- (void)loadViewWithAnimation {
  [self.tableAreaView.layer addAnimation:self.animationGroupToShow forKey:@"ScaleToShow"];
}

- (void)unloadViewWithAnimation {
  [self.tableAreaView.layer addAnimation:self.animationGroupToHide forKey:@"ScaleToHide"];
}

// Animation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  if ([[anim valueForKey:@"animationType"] isEqualToString:@"hide"])
    [self.view removeFromSuperview];
}

@end
