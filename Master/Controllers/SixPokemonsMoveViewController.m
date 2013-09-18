//
//  PokemonMoveViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SixPokemonsMoveViewController.h"

#import "Move.h"
#import "PokemonMoveView.h"
#import "PokemonMoveDetailView.h"


@interface SixPokemonsMoveViewController () {
 @private
  NSArray               * fourMovesPP_;
  UIView                * fourMovesView_;
  PokemonMoveView       * moveOneView_;
  PokemonMoveView       * moveTwoView_;
  PokemonMoveView       * moveThreeView_;
  PokemonMoveView       * moveFourView_;
  PokemonMoveDetailView * moveDetailView_;
}

@property (nonatomic, strong) NSArray               * fourMovesPP;
@property (nonatomic, strong) UIView                * fourMovesView;
@property (nonatomic, strong) PokemonMoveView       * moveOneView;
@property (nonatomic, strong) PokemonMoveView       * moveTwoView;
@property (nonatomic, strong) PokemonMoveView       * moveThreeView;
@property (nonatomic, strong) PokemonMoveView       * moveFourView;
@property (nonatomic, strong) PokemonMoveDetailView * moveDetailView;

- (void)_cancelMoveDetailView;

@end


@implementation SixPokemonsMoveViewController

@synthesize fourMovesPP    = fourMovesPP_;
@synthesize fourMovesView  = fourMovesView_;
@synthesize moveOneView    = moveOneView_;
@synthesize moveTwoView    = moveTwoView_;
@synthesize moveThreeView  = moveThreeView_;
@synthesize moveFourView   = moveFourView_;
@synthesize moveDetailView = moveDetailView_;

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
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Constants
  CGFloat const moveViewHeight = (self.view.frame.size.height - 80.f) / 4.f;
  CGRect  const ppLabelFrame = CGRectMake(200.f, 0.f, 90.f, 20.f);
  CGRect  const fourMovesViewFrame = CGRectMake(0.f, 20.f, self.view.frame.size.width, self.view.frame.size.height);
  CGRect  moveViewFrame = CGRectMake(0.f, 10.f, kViewWidth, moveViewHeight);
  
  // PP
  UILabel * ppLabel = [[UILabel alloc] initWithFrame:ppLabelFrame];
  [ppLabel setBackgroundColor:[UIColor clearColor]];
  [ppLabel setTextAlignment:NSTextAlignmentRight];
  [ppLabel setTextColor:[GlobalRender textColorTitleWhite]];
  [ppLabel setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  [ppLabel setText:NSLocalizedString(@"PMSLabelPP", nil)];
  [self.view addSubview:ppLabel];
  
  // Set Four Moves' layout
  fourMovesView_ = [[UIView alloc] initWithFrame:fourMovesViewFrame];
  
  moveOneView_   = [[PokemonMoveView alloc] initWithFrame:moveViewFrame];
  moveViewFrame.origin.y += moveViewHeight;
  moveTwoView_   = [[PokemonMoveView alloc] initWithFrame:moveViewFrame];
  moveViewFrame.origin.y += moveViewHeight;
  moveThreeView_ = [[PokemonMoveView alloc] initWithFrame:moveViewFrame];
  moveViewFrame.origin.y += moveViewHeight;
  moveFourView_  = [[PokemonMoveView alloc] initWithFrame:moveViewFrame];
  
  [fourMovesView_ addSubview:moveOneView_];
  [fourMovesView_ addSubview:moveTwoView_];
  [fourMovesView_ addSubview:moveThreeView_];
  [fourMovesView_ addSubview:moveFourView_];
  [self.view addSubview:fourMovesView_];
  
  
  // PP for four moves
  self.fourMovesPP = [self.pokemon fourMovesPPInArray];
  
  // Four moves
  Move * move1 = [self.pokemon move1];
  if (move1 != nil) {
    [self.moveOneView configureMoveUnitWithName:[NSString stringWithFormat:@"PMSMove%.3d", [move1.sid intValue]]
                                           type:[NSString stringWithFormat:@"PMSType%.2d", [move1.type intValue]]
                                             pp:[NSString stringWithFormat:@"%d / %d",
                                                 [[fourMovesPP_ objectAtIndex:0] intValue],
                                                 [[fourMovesPP_ objectAtIndex:1] intValue]]
                                       delegate:self
                                            tag:1
                                            odd:YES];
    move1 = nil;
  }
  else [self.moveOneView setButtonEnabled:NO];
  
  Move * move2 = [self.pokemon move2];
  if (move2 != nil) {
    [self.moveTwoView configureMoveUnitWithName:[NSString stringWithFormat:@"PMSMove%.3d", [move2.sid intValue]]
                                           type:[NSString stringWithFormat:@"PMSType%.2d", [move2.type intValue]]
                                             pp:[NSString stringWithFormat:@"%d / %d",
                                                 [[fourMovesPP_ objectAtIndex:2] intValue],
                                                 [[fourMovesPP_ objectAtIndex:3] intValue]]
                                       delegate:self
                                            tag:2
                                            odd:NO];
    move2 = nil;
  }
  else [self.moveTwoView setButtonEnabled:NO];
  
  Move * move3 = [self.pokemon move3];
  if (move3 != nil) {
    [self.moveThreeView configureMoveUnitWithName:[NSString stringWithFormat:@"PMSMove%.3d", [move3.sid intValue]]
                                             type:[NSString stringWithFormat:@"PMSType%.2d", [move3.type intValue]]
                                               pp:[NSString stringWithFormat:@"%d / %d",
                                                   [[fourMovesPP_ objectAtIndex:4] intValue],
                                                   [[fourMovesPP_ objectAtIndex:5] intValue]]
                                         delegate:self
                                              tag:3
                                              odd:YES];
    move3 = nil;
  }
  else [self.moveThreeView setButtonEnabled:NO];
  
  Move * move4 = [self.pokemon move4];
  if (move4 != nil) {
    [self.moveFourView configureMoveUnitWithName:[NSString stringWithFormat:@"PMSMove%.3d", [move4.sid intValue]]
                                            type:[NSString stringWithFormat:@"PMSType%.2d", [move4.type intValue]]
                                              pp:[NSString stringWithFormat:@"%d / %d",
                                                  [[fourMovesPP_ objectAtIndex:6] intValue],
                                                  [[fourMovesPP_ objectAtIndex:7] intValue]]
                                        delegate:self
                                             tag:4
                                             odd:NO];
    move4 = nil;
  }
  else [self.moveFourView setButtonEnabled:NO];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.fourMovesView  = nil;
  self.moveOneView    = nil;
  self.moveTwoView    = nil;
  self.moveThreeView  = nil;
  self.moveFourView   = nil;
  self.moveDetailView = nil;
}

#pragma mark - PokemonMoveView Delegate

// Load Move detail view
- (void)loadMoveDetailView:(id)sender
{
  CGRect const fourMovesViewFrame =
    CGRectMake(0.f, 5.f, self.view.frame.size.width, self.view.frame.size.height - 5.f);
  PokemonMoveDetailView * moveDetailView =
    [[PokemonMoveDetailView alloc] initWithFrame:fourMovesViewFrame];
  self.moveDetailView = moveDetailView;
  [self.moveDetailView.backButton addTarget:self
                                     action:@selector(_cancelMoveDetailView)
                           forControlEvents:UIControlEventTouchUpInside];
  
  // Move tag: one of 1, 2, 3, 4
  NSInteger moveTag = ((UIButton *)sender).tag;
  Move * move = [self.pokemon moveWithIndex:moveTag];
  if (move == nil)
    return;
  NSString * moveName = [NSString stringWithFormat:@"PMSMove%.3d",[move.sid intValue]];
  NSString * moveType = [NSString stringWithFormat:@"PMSType%.2d", [move.type intValue]];
  NSString * movePP   = [NSString stringWithFormat:@"%d / %d",
                         [[fourMovesPP_ objectAtIndex:((moveTag - 1) * 2)] intValue],
                         [[fourMovesPP_ objectAtIndex:((moveTag - 1) * 2 + 1)] intValue]];
  [self.moveDetailView.moveBaseView configureMoveUnitWithName:moveName
                                                         type:moveType
                                                           pp:movePP
                                                     delegate:nil
                                                          tag:-1
                                                          odd:YES];
  
  [self.moveDetailView.categoryLabelView.value setText:
    KYResourceLocalizedString(([NSString stringWithFormat:@"PMSMoveCategory%d", [move.category intValue]]), nil)];
  [self.moveDetailView.powerLabelView.value setText:
    [[move.baseDamage stringValue] isEqualToString:@"0"] ? @"-" : [move.baseDamage stringValue]];
  [self.moveDetailView.accuracyLabelView.value setText:
    [[move.hitChance stringValue] isEqualToString:@"0"] ? @"-" : [move.hitChance stringValue]];
  [self.moveDetailView.infoTextView setText:
    KYResourceLocalizedString(([NSString stringWithFormat:@"PMSMoveInfo%.3d", [move.sid intValue]]), nil)];
  move = nil;
  
  [UIView transitionFromView:self.fourMovesView
                      toView:self.moveDetailView
                    duration:.6f
                     options:UIViewAnimationOptionTransitionFlipFromLeft
                  completion:nil];
}

- (void)_cancelMoveDetailView
{
  [UIView transitionFromView:self.moveDetailView
                      toView:self.fourMovesView
                    duration:.6f
                     options:UIViewAnimationOptionTransitionFlipFromLeft
                  completion:^(BOOL finished) {
                    self.moveDetailView = nil;
                  }];
}

@end
