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
#import "MoveDetailRoundView.h"
#import "TrainerTamedPokemon+DataController.h"


@interface GameMenuMoveViewController () {
 @private
  GameMenuMoveUnitView * move1View_;
  GameMenuMoveUnitView * move2View_;
  GameMenuMoveUnitView * move3View_;
  GameMenuMoveUnitView * move4View_;
  MoveDetailRoundView  * moveDetailRoundView_;
  
  TrainerTamedPokemon      * playerPokemon_;
  NSArray                  * fourMovesPP_;
  UISwipeGestureRecognizer * swipeLeftGestureRecognizer_;
}

@property (nonatomic, retain) GameMenuMoveUnitView * move1View;
@property (nonatomic, retain) GameMenuMoveUnitView * move2View;
@property (nonatomic, retain) GameMenuMoveUnitView * move3View;
@property (nonatomic, retain) GameMenuMoveUnitView * move4View;
@property (nonatomic, retain) MoveDetailRoundView  * moveDetailRoundView;

@property (nonatomic, retain) TrainerTamedPokemon      * playerPokemon;
@property (nonatomic, copy)   NSArray                  * fourMovesPP;
@property (nonatomic, retain) UISwipeGestureRecognizer * swipeLeftGestureRecognizer;

- (void)_releaseSubviews;
- (void)_useSelectedMove:(id)sender;
- (void)_updateMoveUnitViewWithMoveIndex:(NSInteger)moveIndex;

@end


@implementation GameMenuMoveViewController

@synthesize move1View           = move1View_;
@synthesize move2View           = move2View_;
@synthesize move3View           = move3View_;
@synthesize move4View           = move4View_;
@synthesize moveDetailRoundView = moveDetailRoundView_;

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
  self.move1View           = nil;
  self.move2View           = nil;
  self.move3View           = nil;
  self.move4View           = nil;
  self.moveDetailRoundView = nil;
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
  CGFloat moveViewHeight = 88.f;
  CGFloat moveViewWidth  = 88.f;
  CGFloat marginTop      = (kViewHeight - 20.f - 88.f * 4);
  CGRect moveOneViewFrame   = CGRectMake(0.f, marginTop,                moveViewWidth, moveViewHeight);
  CGRect moveTwoViewFrame   = CGRectMake(0.f, marginTop + moveViewHeight,     moveViewWidth, moveViewHeight);
  CGRect moveThreeViewFrame = CGRectMake(0.f, marginTop + moveViewHeight * 2, moveViewWidth, moveViewHeight);
  CGRect moveFourViewFrame  = CGRectMake(0.f, marginTop + moveViewHeight * 3, moveViewWidth, moveViewHeight);
  
  // Set Four Moves' layout
  move1View_ = [[GameMenuMoveUnitView alloc] initWithFrame:moveOneViewFrame];
  move2View_ = [[GameMenuMoveUnitView alloc] initWithFrame:moveTwoViewFrame];
  move3View_ = [[GameMenuMoveUnitView alloc] initWithFrame:moveThreeViewFrame];
  move4View_ = [[GameMenuMoveUnitView alloc] initWithFrame:moveFourViewFrame];
  [move1View_ setTag:101];
  [move2View_ setTag:102];
  [move3View_ setTag:103];
  [move4View_ setTag:104];
  
//  [move1View_.viewButton setTag:1];
//  [move2View_.viewButton setTag:2];
//  [move3View_.viewButton setTag:3];
//  [move4View_.viewButton setTag:4];
//  
//  [move1View_.viewButton addTarget:self action:@selector(_useSelectedMove:)
//                  forControlEvents:UIControlEventTouchUpInside];
//  [move2View_.viewButton addTarget:self action:@selector(_useSelectedMove:)
//                  forControlEvents:UIControlEventTouchUpInside];
//  [move3View_.viewButton addTarget:self action:@selector(_useSelectedMove:)
//                  forControlEvents:UIControlEventTouchUpInside];
//  [move4View_.viewButton addTarget:self action:@selector(_useSelectedMove:)
//                  forControlEvents:UIControlEventTouchUpInside];
  
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
    [moveUnitView configureMoveUnitWithName:nil
                                       icon:nil
                                       type:nil
                                         pp:nil
                                   delegate:nil
                                        tag:-1
                                        odd:NO];
    [moveUnitView setButtonEnabled:NO];
//    [moveUnitView.type1 setText:nil];
//    [moveUnitView.name  setText:nil];
//    [moveUnitView.pp    setText:nil];
//    [moveUnitView.viewButton setEnabled:NO];
    moveUnitView = nil;
    return;
  }
  
//  [moveUnitView.type1 setText:
//   NSLocalizedString(([NSString stringWithFormat:@"PMSType%.2d", [move.type intValue]]), nil)];
//  [moveUnitView.name setText:
//   NSLocalizedString(([NSString stringWithFormat:@"PMSMove%.3d", [move.sid intValue]]), nil)];
  NSInteger currPPIndex = (moveIndex - 1) * 2;
//  [moveUnitView.pp setText:[NSString stringWithFormat:@"%d / %d",
//                              [[fourMovesPP_ objectAtIndex:currPPIndex] intValue],
//                              [[fourMovesPP_ objectAtIndex:(currPPIndex + 1)] intValue]]];
  [moveUnitView configureMoveUnitWithName:[NSString stringWithFormat:@"PMSMove%.3d", [move.sid intValue]]
                                     icon:nil//[UIImage imageNamed:[NSString stringWithFormat:@"IconMove%d.png", moveIndex]]
                                     type:[NSString stringWithFormat:@"PMSType%.2d", [move.type intValue]]
                                       pp:[NSString stringWithFormat:@"%d / %d",
                                           [[fourMovesPP_ objectAtIndex:currPPIndex] intValue],
                                           [[fourMovesPP_ objectAtIndex:(currPPIndex + 1)] intValue]]
                                 delegate:self
                                      tag:moveIndex
                                      odd:NO];
  move = nil;
  
  // Change Text color if needed
  if ([[fourMovesPP_ objectAtIndex:currPPIndex] intValue] <= 0) {
//    [moveUnitView.name setTextColor:[GlobalRender textColorDisabled]];
//    [moveUnitView.pp setTextColor:[GlobalRender textColorDisabled]];
//    [moveUnitView.viewButton setEnabled:NO];
    [moveUnitView setButtonEnabled:NO];
  } else {
//    [moveUnitView.name setTextColor:[GlobalRender textColorTitleWhite]];
//    [moveUnitView.pp setTextColor:[GlobalRender textColorOrange]];
//    [moveUnitView.viewButton setEnabled:YES];
    [moveUnitView setButtonEnabled:YES];
  }
  moveUnitView = nil;
}

#pragma mark - GameMenuMoveUnitView Delegate

- (void)showDetail:(id)sender {
  NSLog(@"showDetail");
  if (self.moveDetailRoundView == nil) {
    MoveDetailRoundView * moveDetailRoundView = [MoveDetailRoundView alloc];
    [moveDetailRoundView initWithFrame:CGRectMake(40.f, 100.f, 320.f, 320.f)];
    self.moveDetailRoundView = moveDetailRoundView;
    [moveDetailRoundView release];
    [self.view insertSubview:self.moveDetailRoundView atIndex:0];
  }
  
  NSInteger moveIndex = ((UIButton *)sender).tag;
  Move * move = [self.playerPokemon moveWithIndex:moveIndex];
  NSInteger currPPIndex = (moveIndex - 1) * 2;
  [self.moveDetailRoundView configureMoveDetailWithName:[NSString stringWithFormat:@"PMSMove%.3d", [move.sid intValue]]
                                                   type:[NSString stringWithFormat:@"PMSType%.2d", [move.type intValue]]
                                                     pp:[NSString stringWithFormat:@"%d / %d",
                                                         [[fourMovesPP_ objectAtIndex:currPPIndex] intValue],
                                                         [[fourMovesPP_ objectAtIndex:(currPPIndex + 1)] intValue]]
                                            description:[NSString stringWithFormat:@"PMSMoveInfo%.3d", [move.sid intValue]]];
  move = nil;
}

@end
