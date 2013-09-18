//
//  GameMenuMoveViewController.m
//  iPokeMon
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
  CAAnimationGroup     * loadAnimationGroup_;
  CAAnimationGroup     * unloadAnimationGroup_;
  CAAnimationGroup     * switchAnimationGroup_;
  
  TrainerTamedPokemon      * playerPokemon_;
  NSArray                  * fourMovesPP_;
  UISwipeGestureRecognizer * swipeLeftGestureRecognizer_;
  UITapGestureRecognizer   * tapGestureRecognizer_;
  
  NSInteger currSelectedMoveIndex_;
}

@property (nonatomic, strong) GameMenuMoveUnitView * move1View;
@property (nonatomic, strong) GameMenuMoveUnitView * move2View;
@property (nonatomic, strong) GameMenuMoveUnitView * move3View;
@property (nonatomic, strong) GameMenuMoveUnitView * move4View;
@property (nonatomic, strong) MoveDetailRoundView  * moveDetailRoundView;
@property (nonatomic, strong) CAAnimationGroup     * loadAnimationGroup;
@property (nonatomic, strong) CAAnimationGroup     * unloadAnimationGroup;
@property (nonatomic, strong) CAAnimationGroup     * switchAnimationGroup;

@property (nonatomic, strong) TrainerTamedPokemon      * playerPokemon;
@property (nonatomic, copy)   NSArray                  * fourMovesPP;
@property (nonatomic, strong) UISwipeGestureRecognizer * swipeLeftGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer   * tapGestureRecognizer;

- (void)_useSelectedMove:(id)sender;
- (void)_updateMoveUnitViewWithMoveIndex:(NSInteger)moveIndex;
- (void)_loadMoveDetailRoundViewAnimated:(BOOL)animated;
- (void)_unloadMoveDetailRoundViewAnimated:(BOOL)animated;
- (void)_switchContentForMoveDetailRoundViewAnimated:(BOOL)animated;

@end


@implementation GameMenuMoveViewController

@synthesize move1View            = move1View_;
@synthesize move2View            = move2View_;
@synthesize move3View            = move3View_;
@synthesize move4View            = move4View_;
@synthesize moveDetailRoundView  = moveDetailRoundView_;
@synthesize loadAnimationGroup   = loadAnimationGroup_;
@synthesize unloadAnimationGroup = unloadAnimationGroup_;
@synthesize switchAnimationGroup = switchAnimationGroup_;

@synthesize playerPokemon              = playerPokemon;
@synthesize fourMovesPP                = fourMovesPP_;
@synthesize swipeLeftGestureRecognizer = swipeLeftGestureRecognizer_;
@synthesize tapGestureRecognizer       = tapGestureRecognizer_;

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
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  currSelectedMoveIndex_ = 0;
  
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
  
  [self.tableAreaView addSubview:move1View_];
  [self.tableAreaView addSubview:move2View_];
  [self.tableAreaView addSubview:move3View_];
  [self.tableAreaView addSubview:move4View_];
  
//  [self updateFourMoves];
  
  // move detail view
  moveDetailRoundView_ = [[MoveDetailRoundView alloc] initWithFrame:CGRectMake(40.f, 150.f, 330.f, 330.f)];
  
  // Swipte to LEFT, close move view
  UISwipeGestureRecognizer * swipeLeftGestureRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
  self.swipeLeftGestureRecognizer = swipeLeftGestureRecognizer;
  [self.swipeLeftGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
  [self.view addGestureRecognizer:self.swipeLeftGestureRecognizer];
  
  // tap on the move detail view to hide it
  tapGestureRecognizer_ =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(_unloadMoveDetailRoundViewAnimated:)];
  [self.moveDetailRoundView addGestureRecognizer:tapGestureRecognizer_];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.move1View           = nil;
  self.move2View           = nil;
  self.move3View           = nil;
  self.move4View           = nil;
  self.moveDetailRoundView = nil;
}

#pragma mark - Public Methods

// update four Moves
- (void)updateFourMoves
{
  // refetch data
  self.playerPokemon = [GameSystemProcess sharedInstance].playerPokemon;
  self.fourMovesPP = [self.playerPokemon fourMovesPPInArray];
  
  // update Move Unit View
  [self _updateMoveUnitViewWithMoveIndex:1];
  [self _updateMoveUnitViewWithMoveIndex:2];
  [self _updateMoveUnitViewWithMoveIndex:3];
  [self _updateMoveUnitViewWithMoveIndex:4];
}

// make sure |moveDetailView_| is unloaded when unload Move view
- (void)unloadViewWithAnimationToLeft:(BOOL)toLeft
                             animated:(BOOL)animated
{
  [super unloadViewWithAnimationToLeft:toLeft animated:animated];
  if (currSelectedMoveIndex_)
    [self _unloadMoveDetailRoundViewAnimated:YES];
}

#pragma mark - Private Methods

// use the Move selected
- (void)_useSelectedMove:(id)sender
{
  // System process setting
  GameSystemProcess * gameSystemProcess = [GameSystemProcess sharedInstance];
  [gameSystemProcess setSystemProcessOfFightWithUser:kGameSystemProcessUserPlayer
                                           moveIndex:((UIButton *)sender).tag];
  
  [self unloadViewWithAnimationToLeft:YES animated:YES];
  [[GameStatusMachine sharedInstance] endStatus:kGameStatusPlayerTurn];
}

// update Move Unit View data
- (void)_updateMoveUnitViewWithMoveIndex:(NSInteger)moveIndex
{
  // get the Move Unit View at index
  GameMenuMoveUnitView * moveUnitView =
    (GameMenuMoveUnitView *)[self.tableAreaView viewWithTag:(100 + moveIndex)];
  Move * move = [self.playerPokemon moveWithIndex:moveIndex];
  if (move == nil) {
    [moveUnitView configureMoveUnitWithSID:0
                                        pp:nil
                                  delegate:nil
                                      tag:-1];
    [moveUnitView setButtonEnabled:NO];
    moveUnitView = nil;
    return;
  }
  
  NSInteger currPPIndex = (moveIndex - 1) * 2;
  [moveUnitView configureMoveUnitWithSID:[move.sid intValue]
                                      pp:[NSString stringWithFormat:@"%d / %d",
                                          [[fourMovesPP_ objectAtIndex:currPPIndex] intValue],
                                          [[fourMovesPP_ objectAtIndex:(currPPIndex + 1)] intValue]]
                                delegate:self
                                    tag:moveIndex];
  move = nil;
  
  // Change Text color if needed
  if ([[fourMovesPP_ objectAtIndex:currPPIndex] intValue] <= 0)
    [moveUnitView setButtonEnabled:NO];
  else [moveUnitView setButtonEnabled:YES];
  moveUnitView = nil;
}

// load |moveDetailRoundView_|
- (void)_loadMoveDetailRoundViewAnimated:(BOOL)animated
{
  // set up animations if it is not initialized
  if (self.loadAnimationGroup == nil) {
    CGFloat duration = .3f;
    // scale
    CAKeyframeAnimation * animationScale =
      [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animationScale.duration = duration;
    animationScale.values = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:.1f],
                             [NSNumber numberWithFloat:.8f],
                             [NSNumber numberWithFloat:1.f], nil];
    
    // fade
    CABasicAnimation * animationFade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animationFade.duration = duration * .4f;
    animationFade.fromValue = [NSNumber numberWithFloat:0.f];
    animationFade.toValue = [NSNumber numberWithFloat:1.f];
    animationFade.fillMode = kCAFillModeForwards;
    
    self.loadAnimationGroup = [CAAnimationGroup animation];
    self.loadAnimationGroup.delegate = self;
    [self.loadAnimationGroup setValue:@"load" forKey:@"animationType"];
    [self.loadAnimationGroup setDuration:duration];
    NSArray * animations = [[NSArray alloc] initWithObjects:animationScale, animationFade, nil];
    [self.loadAnimationGroup setAnimations:animations];
    [self.loadAnimationGroup setTimingFunction:
      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
  }
  [self.moveDetailRoundView.layer addAnimation:self.loadAnimationGroup
                                        forKey:@"loadAnimation"];
}

// unload |moveDetailRoundView_|
- (void)_unloadMoveDetailRoundViewAnimated:(BOOL)animated
{
  if (currSelectedMoveIndex_ == 0)
    return;
  
  // unselected Move
  GameMenuMoveUnitView * moveUnitView =
    (GameMenuMoveUnitView *)[self.tableAreaView viewWithTag:(100 + currSelectedMoveIndex_)];
  [moveUnitView setButtonSelected:NO];
  moveUnitView = nil;
  
  currSelectedMoveIndex_ = 0;
  // set up animations if it is not initialized
  if (self.unloadAnimationGroup == nil) {
    CGFloat duration = .3f;
    // scale
    CAKeyframeAnimation * animationScale =
      [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animationScale.duration = duration;
    animationScale.values = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:1.f],
                             [NSNumber numberWithFloat:1.2f], nil];
    
    // fade
    CABasicAnimation * animationFade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animationFade.duration = duration * .8f;
    animationFade.fromValue = [NSNumber numberWithFloat:1.f];
    animationFade.toValue = [NSNumber numberWithFloat:0.f];
    animationFade.fillMode = kCAFillModeForwards;
    
    self.unloadAnimationGroup = [CAAnimationGroup animation];
    self.unloadAnimationGroup.delegate = self;
    [self.unloadAnimationGroup setValue:@"unload" forKey:@"animationType"];
    [self.unloadAnimationGroup setDuration:duration];
    NSArray * animations = [[NSArray alloc] initWithObjects:animationScale, animationFade, nil];
    [self.unloadAnimationGroup setAnimations:animations];
    [self.unloadAnimationGroup setTimingFunction:
      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
  }
  [self.moveDetailRoundView.layer addAnimation:self.unloadAnimationGroup
                                        forKey:@"unloadAnimation"];
}

// switch content for |moveDetailRoundView_|
- (void)_switchContentForMoveDetailRoundViewAnimated:(BOOL)animated
{
  // set up animations if it is not initialized
  if (self.switchAnimationGroup == nil) {
    CGFloat duration = .3f;
    CAKeyframeAnimation * animationScale =
      [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animationScale.duration = duration;
    animationScale.values = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:1.f],
                             [NSNumber numberWithFloat:.6f],
                             [NSNumber numberWithFloat:1.f], nil];
    animationScale.timingFunctions =
      [NSArray arrayWithObjects:
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn], nil];
        
    self.switchAnimationGroup = [CAAnimationGroup animation];
    self.switchAnimationGroup.delegate = self;
    [self.switchAnimationGroup setValue:@"switch" forKey:@"animationType"];
    [self.switchAnimationGroup setDuration:duration];
    NSArray * animations = [[NSArray alloc] initWithObjects:animationScale, nil];
    [self.switchAnimationGroup setAnimations:animations];
  }
  [self.moveDetailRoundView.layer addAnimation:self.switchAnimationGroup
                                        forKey:@"switchAnimation"];
}

#pragma mark - CoreAnimation Delegate

- (void)animationDidStop:(CAAnimation *)anim
                finished:(BOOL)flag
{
  if ([[anim valueForKey:@"animationType"] isEqualToString:@"unload"]) {
    [self.moveDetailRoundView setAlpha:0.f];
    [self.moveDetailRoundView removeFromSuperview];
  }
  else {
    [UIView animateWithDuration:.1f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{ [self.moveDetailRoundView setContentHidden:NO]; }
                     completion:nil];
  }
}

#pragma mark - GameMenuMoveUnitView Delegate

// show detail for selected Move
- (void)showDetail:(id)sender
{
  NSInteger moveIndex = ((UIButton *)sender).tag;
  if (currSelectedMoveIndex_ == moveIndex) {
    [self _useSelectedMove:sender];
    return;
  }
  
  GameMenuMoveUnitView * moveUnitView =
    (GameMenuMoveUnitView *)[self.tableAreaView viewWithTag:(100 + moveIndex)];
  [moveUnitView setButtonSelected:YES];
  
  // load |moveDetailView_| is no Move is selected
  // otherwise, switch content for different Moves
  if (currSelectedMoveIndex_ == 0) {
    [self.moveDetailRoundView setAlpha:1.f];
    [self.view insertSubview:self.moveDetailRoundView atIndex:0];
    [self _loadMoveDetailRoundViewAnimated:YES];
  }
  else {
    [self _switchContentForMoveDetailRoundViewAnimated:YES];
    moveUnitView = (GameMenuMoveUnitView *)[self.tableAreaView viewWithTag:(100 + currSelectedMoveIndex_)];
    [moveUnitView setButtonSelected:NO];
  }
  currSelectedMoveIndex_ = moveIndex;
  moveUnitView = nil;
  
  void (^completion)(BOOL) = ^(BOOL finished) {
    Move * move = [self.playerPokemon moveWithIndex:moveIndex];
    NSInteger currPPIndex = (moveIndex - 1) * 2;
    [self.moveDetailRoundView configureMoveDetailWithName:[NSString stringWithFormat:@"PMSMove%.3d", [move.sid intValue]]
                                                     type:[NSString stringWithFormat:@"PMSType%.2d", [move.type intValue]]
                                                       pp:[NSString stringWithFormat:@"%d / %d",
                                                           [[fourMovesPP_ objectAtIndex:currPPIndex] intValue],
                                                           [[fourMovesPP_ objectAtIndex:(currPPIndex + 1)] intValue]]
                                              description:[NSString stringWithFormat:@"PMSMoveInfo%.3d", [move.sid intValue]]];
    move = nil;
  };
  [UIView animateWithDuration:.1f
                        delay:0.f
                      options:UIViewAnimationOptionCurveLinear
                   animations:^{ [self.moveDetailRoundView setContentHidden:YES]; }
                   completion:completion];
}

@end
