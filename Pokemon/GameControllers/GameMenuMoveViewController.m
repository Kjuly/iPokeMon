//
//  GameMenuMoveViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuMoveViewController.h"

#import "GlobalRender.h"
#import "GameStatusMachine.h"
#import "GameSystemProcess.h"
#import "TrainerTamedPokemon+DataController.h"
#import "GameMenuMoveUnitView.h"


@interface GameMenuMoveViewController () {
 @private
  GameMenuMoveUnitView * move1View_;
  GameMenuMoveUnitView * move2View_;
  GameMenuMoveUnitView * move3View_;
  GameMenuMoveUnitView * move4View_;
  
  TrainerTamedPokemon      * playerPokemon_;
  NSArray                  * fourMovesPP_;
  UISwipeGestureRecognizer * swipeLeftGestureRecognizer_;
}

@property (nonatomic, retain) GameMenuMoveUnitView * move1View;
@property (nonatomic, retain) GameMenuMoveUnitView * move2View;
@property (nonatomic, retain) GameMenuMoveUnitView * move3View;
@property (nonatomic, retain) GameMenuMoveUnitView * move4View;

@property (nonatomic, retain) TrainerTamedPokemon      * playerPokemon;
@property (nonatomic, copy)   NSArray                  * fourMovesPP;
@property (nonatomic, retain) UISwipeGestureRecognizer * swipeLeftGestureRecognizer;

- (void)_releaseSubviews;
- (void)_useSelectedMove:(id)sender;
- (void)_updateMoveUnitViewWithMoveIndex:(NSInteger)moveIndex;

@end


@implementation GameMenuMoveViewController

@synthesize move1View = move1View_;
@synthesize move2View = move2View_;
@synthesize move3View = move3View_;
@synthesize move4View = move4View_;

@synthesize playerPokemon              = playerPokemon;
@synthesize fourMovesPP                = fourMovesPP_;
@synthesize swipeLeftGestureRecognizer = swipeLeftGestureRecognizer_;

- (void)dealloc {
  self.playerPokemon = nil;
  self.fourMovesPP   = nil;
  self.swipeLeftGestureRecognizer = nil;
  [self _releaseSubviews];
  [super dealloc];
}

- (void)_releaseSubviews {
  self.move1View = nil;
  self.move2View = nil;
  self.move3View = nil;
  self.move4View = nil;
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView {
//  [super loadView];
//}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
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
  [move1View_ setTag:101];
  [move2View_ setTag:102];
  [move3View_ setTag:103];
  [move4View_ setTag:104];
  
  [move1View_.viewButton setTag:1];
  [move2View_.viewButton setTag:2];
  [move3View_.viewButton setTag:3];
  [move4View_.viewButton setTag:4];
  
  [move1View_.viewButton addTarget:self action:@selector(_useSelectedMove:)
                  forControlEvents:UIControlEventTouchUpInside];
  [move2View_.viewButton addTarget:self action:@selector(_useSelectedMove:)
                  forControlEvents:UIControlEventTouchUpInside];
  [move3View_.viewButton addTarget:self action:@selector(_useSelectedMove:)
                  forControlEvents:UIControlEventTouchUpInside];
  [move4View_.viewButton addTarget:self action:@selector(_useSelectedMove:)
                  forControlEvents:UIControlEventTouchUpInside];
  
  [self.tableAreaView addSubview:move1View_];
  [self.tableAreaView addSubview:move2View_];
  [self.tableAreaView addSubview:move3View_];
  [self.tableAreaView addSubview:move4View_];
  
  
  [self updateFourMoves];
  
  // Swipte to LEFT, close move view
  UISwipeGestureRecognizer * swipeLeftGestureRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
  self.swipeLeftGestureRecognizer = swipeLeftGestureRecognizer;
  [swipeLeftGestureRecognizer release];
  [self.swipeLeftGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
  [self.view addGestureRecognizer:self.swipeLeftGestureRecognizer];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  [self _releaseSubviews];
}

#pragma mark - Public Methods

// update four Moves
- (void)updateFourMoves {
  // refetch data
  self.playerPokemon = [GameSystemProcess sharedInstance].playerPokemon;
  self.fourMovesPP = [self.playerPokemon fourMovesPPInArray];
  
  // update Move Unit View
  [self _updateMoveUnitViewWithMoveIndex:1];
  [self _updateMoveUnitViewWithMoveIndex:2];
  [self _updateMoveUnitViewWithMoveIndex:3];
  [self _updateMoveUnitViewWithMoveIndex:4];
}

#pragma mark - Private Methods

// use the Move selected
- (void)_useSelectedMove:(id)sender {
  // System process setting
  GameSystemProcess * gameSystemProcess = [GameSystemProcess sharedInstance];
  [gameSystemProcess setSystemProcessOfFightWithUser:kGameSystemProcessUserPlayer
                                           moveIndex:((UIButton *)sender).tag];
  
  [self unloadViewWithAnimationToLeft:YES animated:YES];
  [[GameStatusMachine sharedInstance] endStatus:kGameStatusPlayerTurn];
}

// update Move Unit View data
- (void)_updateMoveUnitViewWithMoveIndex:(NSInteger)moveIndex {
  // get the Move Unit View at index
  GameMenuMoveUnitView * moveUnitView = (GameMenuMoveUnitView *)[self.tableAreaView viewWithTag:(100 + moveIndex)];
  Move * move = [self.playerPokemon moveWithIndex:moveIndex];
  if (move == nil) {
    [moveUnitView.type1 setText:nil];
    [moveUnitView.name  setText:nil];
    [moveUnitView.pp    setText:nil];
    [moveUnitView.viewButton setEnabled:NO];
    moveUnitView = nil;
    return;
  }
  
  [moveUnitView.type1 setText:
   NSLocalizedString(([NSString stringWithFormat:@"PMSType%.2d", [move.type intValue]]), nil)];
  [moveUnitView.name setText:
   NSLocalizedString(([NSString stringWithFormat:@"PMSMove%.3d", [move.sid intValue]]), nil)];
  [moveUnitView.pp setText:[NSString stringWithFormat:@"%d / %d",
                              [[fourMovesPP_ objectAtIndex:0] intValue],
                              [[fourMovesPP_ objectAtIndex:1] intValue]]];
  move = nil;
  
  // Change Text color if needed
  if ([[fourMovesPP_ objectAtIndex:0] intValue] == 0) {
    [moveUnitView.name setTextColor:[GlobalRender textColorDisabled]];
    [moveUnitView.viewButton setEnabled:NO];
  } else {
    [moveUnitView.name setTextColor:[GlobalRender textColorTitleWhite]];
    [moveUnitView.viewButton setEnabled:YES];
  }
  moveUnitView = nil;
}

@end
