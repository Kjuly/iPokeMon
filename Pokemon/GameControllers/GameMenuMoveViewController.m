//
//  GameMenuMoveViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuMoveViewController.h"

#import "GameStatusMachine.h"
#import "GameSystemProcess.h"
#import "TrainerTamedPokemon+DataController.h"
#import "Move.h"
#import "GameMenuMoveUnitView.h"


@interface GameMenuMoveViewController () {
 @private
  TrainerTamedPokemon * playerPokemon_;
  NSArray             * fourMovesPP_;
  
  GameMenuMoveUnitView * move1View_;
  GameMenuMoveUnitView * move2View_;
  GameMenuMoveUnitView * move3View_;
  GameMenuMoveUnitView * move4View_;
  
  UISwipeGestureRecognizer * swipeLeftGestureRecognizer_;
}

@property (nonatomic, retain) TrainerTamedPokemon * playerPokemon;
@property (nonatomic, copy) NSArray               * fourMovesPP;

@property (nonatomic, retain) GameMenuMoveUnitView * move1View;
@property (nonatomic, retain) GameMenuMoveUnitView * move2View;
@property (nonatomic, retain) GameMenuMoveUnitView * move3View;
@property (nonatomic, retain) GameMenuMoveUnitView * move4View;

@property (nonatomic, retain) UISwipeGestureRecognizer * swipeLeftGestureRecognizer;

- (void)useSelectedMove:(id)sender;

@end


@implementation GameMenuMoveViewController

@synthesize playerPokemon  = playerPokemon;
@synthesize fourMovesPP    = fourMovesPP_;

@synthesize move1View = move1View_;
@synthesize move2View = move2View_;
@synthesize move3View = move3View_;
@synthesize move4View = move4View_;

@synthesize swipeLeftGestureRecognizer = swipeLeftGestureRecognizer_;

- (void)dealloc
{
  [playerPokemon release];
  [fourMovesPP_  release];
  
  [move1View_ release];
  [move2View_ release];
  [move3View_ release];
  [move4View_ release];
  
  [swipeLeftGestureRecognizer_ release];
  
  [super dealloc];
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
  
  // Constants
  CGFloat moveViewHeight = (kViewHeight - 20.f) / 4.f;
  CGFloat moveViewWidth  = kViewWidth - 10.f;
  CGRect moveOneViewFrame   = CGRectMake(0.f, 0.f,                moveViewWidth, moveViewHeight);
  CGRect moveTwoViewFrame   = CGRectMake(0.f, moveViewHeight,     moveViewWidth, moveViewHeight);
  CGRect moveThreeViewFrame = CGRectMake(0.f, moveViewHeight * 2, moveViewWidth, moveViewHeight);
  CGRect moveFourViewFrame  = CGRectMake(0.f, moveViewHeight * 3, moveViewWidth, moveViewHeight);
  
  // Set Four Moves' layout
  move1View_ = [[GameMenuMoveUnitView alloc] initWithFrame:moveOneViewFrame];
  move2View_ = [[GameMenuMoveUnitView alloc] initWithFrame:moveTwoViewFrame];
  move3View_ = [[GameMenuMoveUnitView alloc] initWithFrame:moveThreeViewFrame];
  move4View_ = [[GameMenuMoveUnitView alloc] initWithFrame:moveFourViewFrame];
  
  [move1View_.viewButton setTag:1];
  [move2View_.viewButton setTag:2];
  [move3View_.viewButton setTag:3];
  [move4View_.viewButton setTag:4];
  
  [move1View_.viewButton addTarget:self action:@selector(useSelectedMove:)
                  forControlEvents:UIControlEventTouchUpInside];
  [move2View_.viewButton addTarget:self action:@selector(useSelectedMove:)
                  forControlEvents:UIControlEventTouchUpInside];
  [move3View_.viewButton addTarget:self action:@selector(useSelectedMove:)
                  forControlEvents:UIControlEventTouchUpInside];
  [move4View_.viewButton addTarget:self action:@selector(useSelectedMove:)
                  forControlEvents:UIControlEventTouchUpInside];
  
  [self.tableAreaView addSubview:move1View_];
  [self.tableAreaView addSubview:move2View_];
  [self.tableAreaView addSubview:move3View_];
  [self.tableAreaView addSubview:move4View_];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self updateFourMoves];
  
  // Swipte to LEFT, close move view
  UISwipeGestureRecognizer * swipeLeftGestureRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
  self.swipeLeftGestureRecognizer = swipeLeftGestureRecognizer;
  [swipeLeftGestureRecognizer release];
  [self.swipeLeftGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
  [self.view addGestureRecognizer:self.swipeLeftGestureRecognizer];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.playerPokemon = nil;
  self.fourMovesPP   = nil;
  
  self.move1View = nil;
  self.move2View = nil;
  self.move3View = nil;
  self.move4View = nil;
  
  self.swipeLeftGestureRecognizer = nil;
}

#pragma mark - Private Methods

- (void)useSelectedMove:(id)sender {
  // System process setting
  GameSystemProcess * gameSystemProcess = [GameSystemProcess sharedInstance];
  [gameSystemProcess setSystemProcessOfFightWithUser:kGameSystemProcessUserPlayer
                                           moveIndex:((UIButton *)sender).tag];
  
  [self unloadViewWithAnimationToLeft:YES animated:YES];
  [[GameStatusMachine sharedInstance] endStatus:kGameStatusPlayerTurn];
}

#pragma mark - Public Methods

- (void)updateFourMoves
{
  self.playerPokemon = [GameSystemProcess sharedInstance].playerPokemon;
  self.fourMovesPP = [self.playerPokemon fourMovesPPInArray];
  
  // Four moves
  Move * move1 = self.playerPokemon.move1;
  if (move1 != nil) {
    [self.move1View.type1 setText:
     NSLocalizedString(([NSString stringWithFormat:@"PMSType%.2d", [move1.type intValue]]), nil)];
    [self.move1View.name setText:
     NSLocalizedString(([NSString stringWithFormat:@"PMSMove%.3d", [move1.sid intValue]]), nil)];
    [self.move1View.pp setText:[NSString stringWithFormat:@"%d / %d",
                                [[fourMovesPP_ objectAtIndex:0] intValue],
                                [[fourMovesPP_ objectAtIndex:1] intValue]]];
    move1 = nil;
  }
  
  Move * move2 = self.playerPokemon.move2;
  if (move2 != nil) {
    [self.move2View.type1 setText:
     NSLocalizedString(([NSString stringWithFormat:@"PMSType%.2d", [move2.type intValue]]), nil)];
    [self.move2View.name setText:
     NSLocalizedString(([NSString stringWithFormat:@"PMSMove%.3d", [move2.sid intValue]]), nil)];
    [self.move2View.pp setText:[NSString stringWithFormat:@"%d / %d",
                                [[fourMovesPP_ objectAtIndex:2] intValue],
                                [[fourMovesPP_ objectAtIndex:3] intValue]]];
    move2 = nil;
  }
  
  Move * move3 = self.playerPokemon.move3;
  if (move3 != nil) {
    [self.move3View.type1 setText:
     NSLocalizedString(([NSString stringWithFormat:@"PMSType%.2d", [move3.type intValue]]), nil)];
    [self.move3View.name setText:
     NSLocalizedString(([NSString stringWithFormat:@"PMSMove%.3d", [move3.sid intValue]]), nil)];
    [self.move3View.pp setText:[NSString stringWithFormat:@"%d / %d",
                                [[fourMovesPP_ objectAtIndex:4] intValue],
                                [[fourMovesPP_ objectAtIndex:5] intValue]]];
    move3 = nil;
  }
  
  Move * move4 = self.playerPokemon.move4;
  if (move4 != nil) {
    [self.move4View.type1 setText:
     NSLocalizedString(([NSString stringWithFormat:@"PMSType%.2d", [move4.type intValue]]), nil)];
    [self.move4View.name setText:
     NSLocalizedString(([NSString stringWithFormat:@"PMSMove%.3d", [move4.sid intValue]]), nil)];
    [self.move4View.pp setText:[NSString stringWithFormat:@"%d / %d",
                                [[fourMovesPP_ objectAtIndex:6] intValue],
                                [[fourMovesPP_ objectAtIndex:7] intValue]]];
    move4 = nil;
  }
}

@end
