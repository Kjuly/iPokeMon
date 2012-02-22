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

@implementation SixPokemonsMoveViewController

@synthesize fourMoves     = fourMoves_;
@synthesize moveOneView   = moveOneView_;
@synthesize moveTwoView   = moveTwoView_;
@synthesize moveThreeView = moveThreeView_;
@synthesize moveFourView  = moveFourView_;

- (void)dealloc
{
  [fourMoves_     release];
  [moveOneView_   release];
  [moveTwoView_   release];
  [moveThreeView_ release];
  [moveFourView_  release];
  
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
  CGRect  const moveOneViewFrame   = CGRectMake(0.0f, 10.0f, 300.0f, moveViewHeight);
  CGRect  const moveTwoViewFrame   = CGRectMake(0.0f, 10.0f + moveViewHeight, 300.0f, moveViewHeight);
  CGRect  const moveThreeViewFrame = CGRectMake(0.0f, 10.0f + moveViewHeight * 2, 300.0f, moveViewHeight);
  CGRect  const moveFourViewFrame  = CGRectMake(0.0f, 10.0f + moveViewHeight * 3, 300.0f, moveViewHeight);
  
  // Set Four Moves' layout
  moveOneView_   = [[PokemonMoveView alloc] initWithFrame:moveOneViewFrame];
  moveTwoView_   = [[PokemonMoveView alloc] initWithFrame:moveTwoViewFrame];
  moveThreeView_ = [[PokemonMoveView alloc] initWithFrame:moveThreeViewFrame];
  moveFourView_  = [[PokemonMoveView alloc] initWithFrame:moveFourViewFrame];
  
  [self.view addSubview:moveOneView_];
  [self.view addSubview:moveTwoView_];
  [self.view addSubview:moveThreeView_];
  [self.view addSubview:moveFourView_];
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
  
  self.fourMoves     = nil;
  self.moveOneView   = nil;
  self.moveTwoView   = nil;
  self.moveThreeView = nil;
  self.moveFourView  = nil;
}

@end
