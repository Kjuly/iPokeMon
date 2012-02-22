//
//  PokemonMoveViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SixPokemonsMoveViewController.h"

#import "Move.h"
#import "PokemonMoveView.h"
#import "PokemonMoveDetailView.h"

@interface SixPokemonsMoveViewController ()

- (void)loadMoveDetailView:(id)sender;
- (void)cancelMoveDetailView;

@end

@implementation SixPokemonsMoveViewController

@synthesize fourMoves      = fourMoves_;
@synthesize fourMovesView  = fourMovesView_;
@synthesize moveOneView    = moveOneView_;
@synthesize moveTwoView    = moveTwoView_;
@synthesize moveThreeView  = moveThreeView_;
@synthesize moveFourView   = moveFourView_;
@synthesize moveDetailView = moveDetailView_;

- (void)dealloc
{
  [fourMoves_      release];
  [fourMovesView_  release];
  [moveOneView_    release];
  [moveTwoView_    release];
  [moveThreeView_  release];
  [moveFourView_   release];
  [moveDetailView_ release];
  
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
  CGFloat const moveViewHeight = (self.view.frame.size.height - 80.0f) / 4.0f;
  CGRect  const fourMovesViewFrame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
  CGRect  const moveOneViewFrame   = CGRectMake(0.0f, 10.0f, 300.0f, moveViewHeight);
  CGRect  const moveTwoViewFrame   = CGRectMake(0.0f, 10.0f + moveViewHeight, 300.0f, moveViewHeight);
  CGRect  const moveThreeViewFrame = CGRectMake(0.0f, 10.0f + moveViewHeight * 2, 300.0f, moveViewHeight);
  CGRect  const moveFourViewFrame  = CGRectMake(0.0f, 10.0f + moveViewHeight * 3, 300.0f, moveViewHeight);
  
  // Set Four Moves' layout
  fourMovesView_ = [[UIView alloc] initWithFrame:fourMovesViewFrame];
  
  moveOneView_   = [[PokemonMoveView alloc] initWithFrame:moveOneViewFrame];
  moveTwoView_   = [[PokemonMoveView alloc] initWithFrame:moveTwoViewFrame];
  moveThreeView_ = [[PokemonMoveView alloc] initWithFrame:moveThreeViewFrame];
  moveFourView_  = [[PokemonMoveView alloc] initWithFrame:moveFourViewFrame];
  
  [moveOneView_.viewButton   setTag:0];
  [moveTwoView_.viewButton   setTag:1];
  [moveThreeView_.viewButton setTag:2];
  [moveFourView_.viewButton  setTag:3];
  
  [moveOneView_.viewButton   addTarget:self action:@selector(loadMoveDetailView:)
                      forControlEvents:UIControlEventTouchUpInside];
  [moveTwoView_.viewButton   addTarget:self action:@selector(loadMoveDetailView:)
                      forControlEvents:UIControlEventTouchUpInside];
  [moveThreeView_.viewButton addTarget:self action:@selector(loadMoveDetailView:)
                      forControlEvents:UIControlEventTouchUpInside];
  [moveFourView_.viewButton  addTarget:self action:@selector(loadMoveDetailView:)
                      forControlEvents:UIControlEventTouchUpInside];
  
  [fourMovesView_ addSubview:moveOneView_];
  [fourMovesView_ addSubview:moveTwoView_];
  [fourMovesView_ addSubview:moveThreeView_];
  [fourMovesView_ addSubview:moveFourView_];
  [self.view addSubview:fourMovesView_];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.fourMoves = [self.pokemon.fourMoves allObjects];
  
  Move * moveOne   = [self.fourMoves objectAtIndex:0];
  [self.moveOneView.type1 setText:[moveOne.type stringValue]];
  [self.moveOneView.name setText:NSLocalizedString(moveOne.name, nil)];
  [self.moveOneView.pp setText:[NSString stringWithFormat:@"%d/%d", [moveOne.basePP intValue], [moveOne.basePP intValue]]];
  
  Move * moveTwo   = [self.fourMoves objectAtIndex:1];
  [self.moveTwoView.type1 setText:[moveTwo.type stringValue]];
  [self.moveTwoView.name setText:NSLocalizedString(moveTwo.name, nil)];
  [self.moveTwoView.pp setText:[NSString stringWithFormat:@"%d/%d", [moveTwo.basePP intValue], [moveTwo.basePP intValue]]];
  
  Move * moveThree = [self.fourMoves objectAtIndex:2];
  [self.moveThreeView.type1 setText:[moveThree.type stringValue]];
  [self.moveThreeView.name setText:NSLocalizedString(moveThree.name, nil)];
  [self.moveThreeView.pp setText:[NSString stringWithFormat:@"%d/%d", [moveThree.basePP intValue], [moveThree.basePP intValue]]];
  
  Move * moveFour  = [self.fourMoves objectAtIndex:3];
  [self.moveFourView.type1 setText:[moveFour.type stringValue]];
  [self.moveFourView.name setText:NSLocalizedString(moveFour.name, nil)];
  [self.moveFourView.pp setText:[NSString stringWithFormat:@"%d/%d", [moveFour.basePP intValue], [moveFour.basePP intValue]]];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.fourMoves      = nil;
  self.fourMovesView  = nil;
  self.moveOneView    = nil;
  self.moveTwoView    = nil;
  self.moveThreeView  = nil;
  self.moveFourView   = nil;
  self.moveDetailView = nil;
}

#pragma mark - Private Methods

- (void)loadMoveDetailView:(id)sender
{
  if (! moveDetailView_) {
    CGRect const fourMovesViewFrame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    moveDetailView_ = [[PokemonMoveDetailView alloc] initWithFrame:fourMovesViewFrame];
    [moveDetailView_.backButton addTarget:self
                                   action:@selector(cancelMoveDetailView)
                         forControlEvents:UIControlEventTouchUpInside];
  }
  
  Move * move = [self.fourMoves objectAtIndex:((UIButton *)sender).tag];
  [self.moveDetailView.moveBaseView.type1 setText:[move.type stringValue]];
  [self.moveDetailView.moveBaseView.name  setText:NSLocalizedString(move.name, nil)];
  [self.moveDetailView.moveBaseView.pp    setText:[NSString stringWithFormat:@"%d/%d",
                                                   [move.basePP intValue], [move.basePP intValue]]];
  [self.moveDetailView.categoryLabelView.value setText:[move.category stringValue]];
  [self.moveDetailView.powerLabelView.value    setText:[move.baseDamage stringValue]];
  [self.moveDetailView.accuracyLabelView.value setText:[move.hitChance stringValue]];
  [self.moveDetailView.infoTextView setText:move.info];
  move = nil;
  
  [UIView transitionFromView:self.fourMovesView
                      toView:self.moveDetailView
                    duration:0.6f
                     options:UIViewAnimationOptionTransitionFlipFromLeft
                  completion:nil];
}

- (void)cancelMoveDetailView {
  [UIView transitionFromView:self.moveDetailView
                      toView:self.fourMovesView
                    duration:0.6f
                     options:UIViewAnimationOptionTransitionFlipFromLeft
                  completion:nil];
}

@end
