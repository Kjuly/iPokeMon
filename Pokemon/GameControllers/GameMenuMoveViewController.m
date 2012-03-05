//
//  GameMenuMoveViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuMoveViewController.h"

#import "GlobalNotificationConstants.h"
#import "GameStatus.h"
#import "TrainerCoreDataController.h"
#import "Move.h"
#import "GameMenuMoveUnitView.h"

#import <QuartzCore/QuartzCore.h>


@interface GameMenuMoveViewController () {
 @private
  TrainerTamedPokemon * trainerPokemon_;
  NSArray             * fourMoves_;
  NSArray             * fourMovesPP_;
  
  UIView               * moveAreaView_;
  GameMenuMoveUnitView * moveOneView_;
  GameMenuMoveUnitView * moveTwoView_;
  GameMenuMoveUnitView * moveThreeView_;
  GameMenuMoveUnitView * moveFourView_;
  
  CAAnimationGroup * animationGroupToShow_;
  CAAnimationGroup * animationGroupToHide_;
}

@property (nonatomic, retain) TrainerTamedPokemon * trainerPokemon;
@property (nonatomic, copy) NSArray               * fourMoves;
@property (nonatomic, copy) NSArray               * fourMovesPP;

@property (nonatomic, retain) UIView               * moveAreaView;
@property (nonatomic, retain) GameMenuMoveUnitView * moveOneView;
@property (nonatomic, retain) GameMenuMoveUnitView * moveTwoView;
@property (nonatomic, retain) GameMenuMoveUnitView * moveThreeView;
@property (nonatomic, retain) GameMenuMoveUnitView * moveFourView;

@property (nonatomic, retain) CAAnimationGroup * animationGroupToShow;
@property (nonatomic, retain) CAAnimationGroup * animationGroupToHide;

- (void)useSelectedMove:(id)sender;

@end


@implementation GameMenuMoveViewController

@synthesize trainerPokemon = trainerPokemon_;
@synthesize fourMoves      = fourMoves_;
@synthesize fourMovesPP    = fourMovesPP_;

@synthesize moveAreaView  = moveAreaView_;
@synthesize moveOneView   = moveOneView_;
@synthesize moveTwoView   = moveTwoView_;
@synthesize moveThreeView = moveThreeView_;
@synthesize moveFourView  = moveFourView_;

@synthesize animationGroupToShow = animationGroupToShow_;
@synthesize animationGroupToHide = animationGroupToHide_;

- (void)dealloc
{
  [trainerPokemon_ release];
  [fourMoves_      release];
  [fourMovesPP_    release];
  
  [moveAreaView_   release];
  [moveOneView_    release];
  [moveTwoView_    release];
  [moveThreeView_  release];
  [moveFourView_   release];
  
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
  
  // Constants
  CGRect moveAreaViewFrame  = CGRectMake(10.0f, 220.0f, 300.0f, 220.0f);
  CGRect moveOneViewFrame   = CGRectMake(10.0f, 20.0f, 280, 45.0f);
  CGRect moveTwoViewFrame   = CGRectMake(10.0f, 65.0f, 280.0f, 45.0f);
  CGRect moveThreeViewFrame = CGRectMake(10.0f, 110.0f, 280.0f, 45.0f);
  CGRect moveFourViewFrame  = CGRectMake(10.0f, 155.0f, 280.0f, 45.0f);
  
  // Create Move Area View
  UIView * moveAreaView = [[UIView alloc] initWithFrame:moveAreaViewFrame];
  self.moveAreaView = moveAreaView;
  [moveAreaView release];
  [self.moveAreaView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"GameViewPokemonMoveView.png"]]];
  [self.moveAreaView setOpaque:NO];
  [self.moveAreaView.layer setCornerRadius:20.0f];
  [self.view addSubview:moveAreaView];
  
  // Set Four Moves' layout
  moveOneView_   = [[GameMenuMoveUnitView alloc] initWithFrame:moveOneViewFrame];
  moveTwoView_   = [[GameMenuMoveUnitView alloc] initWithFrame:moveTwoViewFrame];
  moveThreeView_ = [[GameMenuMoveUnitView alloc] initWithFrame:moveThreeViewFrame];
  moveFourView_  = [[GameMenuMoveUnitView alloc] initWithFrame:moveFourViewFrame];
  
  [moveOneView_.viewButton   setTag:1];
  [moveTwoView_.viewButton   setTag:2];
  [moveThreeView_.viewButton setTag:3];
  [moveFourView_.viewButton  setTag:4];
  
  [moveOneView_.viewButton   addTarget:self action:@selector(useSelectedMove:)
                      forControlEvents:UIControlEventTouchUpInside];
  [moveTwoView_.viewButton   addTarget:self action:@selector(useSelectedMove:)
                      forControlEvents:UIControlEventTouchUpInside];
  [moveThreeView_.viewButton addTarget:self action:@selector(useSelectedMove:)
                      forControlEvents:UIControlEventTouchUpInside];
  [moveFourView_.viewButton  addTarget:self action:@selector(useSelectedMove:)
                      forControlEvents:UIControlEventTouchUpInside];
  
  [self.moveAreaView addSubview:moveOneView_];
  [self.moveAreaView addSubview:moveTwoView_];
  [self.moveAreaView addSubview:moveThreeView_];
  [self.moveAreaView addSubview:moveFourView_];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.trainerPokemon = [[TrainerCoreDataController sharedInstance] firstPokemonOfSix];
  self.fourMoves = [self.trainerPokemon.fourMoves allObjects];
  
  if ([self.trainerPokemon.fourMovesPP isKindOfClass:[NSString class]]) {
    NSMutableArray * movesPP = [NSMutableArray arrayWithCapacity:8];
    for (id movePP in [self.trainerPokemon.fourMovesPP componentsSeparatedByString:@","])
      [movesPP addObject:[NSNumber numberWithInt:[movePP intValue]]];
    fourMovesPP_ = [[NSArray alloc] initWithArray:movesPP];
  }
  else fourMovesPP_ = [[NSArray alloc] initWithArray:self.trainerPokemon.fourMovesPP];
  
  
  Move * moveOne   = [self.fourMoves objectAtIndex:0];
  [self.moveOneView.type1 setText:[moveOne.type stringValue]];
  [self.moveOneView.name setText:NSLocalizedString(moveOne.name, nil)];
  [self.moveOneView.pp setText:[NSString stringWithFormat:@"%d / %d",
                                [[fourMovesPP_ objectAtIndex:1] intValue], [[fourMovesPP_ objectAtIndex:0] intValue]]];
  
  Move * moveTwo   = [self.fourMoves objectAtIndex:1];
  [self.moveTwoView.type1 setText:[moveTwo.type stringValue]];
  [self.moveTwoView.name setText:NSLocalizedString(moveTwo.name, nil)];
  [self.moveTwoView.pp setText:[NSString stringWithFormat:@"%d / %d",
                                [[fourMovesPP_ objectAtIndex:3] intValue], [[fourMovesPP_ objectAtIndex:2] intValue]]];
  
  Move * moveThree = [self.fourMoves objectAtIndex:2];
  [self.moveThreeView.type1 setText:[moveThree.type stringValue]];
  [self.moveThreeView.name setText:NSLocalizedString(moveThree.name, nil)];
  [self.moveThreeView.pp setText:[NSString stringWithFormat:@"%d / %d",
                                  [[fourMovesPP_ objectAtIndex:5] intValue], [[fourMovesPP_ objectAtIndex:4] intValue]]];
  
  Move * moveFour  = [self.fourMoves objectAtIndex:3];
  [self.moveFourView.type1 setText:[moveFour.type stringValue]];
  [self.moveFourView.name setText:NSLocalizedString(moveFour.name, nil)];
  [self.moveFourView.pp setText:[NSString stringWithFormat:@"%d / %d",
                                 [[fourMovesPP_ objectAtIndex:7] intValue], [[fourMovesPP_ objectAtIndex:6] intValue]]];
  
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
  
  self.trainerPokemon = nil;
  self.fourMoves      = nil;
  self.fourMovesPP    = nil;
  
  self.moveAreaView   = nil;
  self.moveOneView    = nil;
  self.moveTwoView    = nil;
  self.moveThreeView  = nil;
  self.moveFourView   = nil;
  
  self.animationGroupToShow = nil;
  self.animationGroupToHide = nil;
}

#pragma mark - Public Methods

- (void)loadMoveView {
  [self.moveAreaView.layer addAnimation:self.animationGroupToShow forKey:@"ScaleToShow"];
}

- (void)unloadMoveView {
  [self.moveAreaView.layer addAnimation:self.animationGroupToHide forKey:@"ScaleToHide"];
}

// Animation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  if ([[anim valueForKey:@"animationType"] isEqualToString:@"hide"])
    [self.view removeFromSuperview];
}

#pragma mark - Private Methods

- (void)useSelectedMove:(id)sender
{
  NSInteger moveTag = ((UIButton *)sender).tag;
  NSLog(@"Use Move %d", moveTag);
  
  Move * move = [self.fourMoves objectAtIndex:moveTag];
  // Send parameter to Move Effect Controller
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"TrainerPokemon", @"MoveOwner",
                             move.baseDamage, @"damage",
                             nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNMoveEffect object:nil userInfo:userInfo];
  [userInfo release];
  
  [self unloadMoveView];
  [[GameStatus sharedInstance] trainerTurnEnd];
}

@end
