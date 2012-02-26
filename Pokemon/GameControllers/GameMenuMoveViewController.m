//
//  GameMenuMoveViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuMoveViewController.h"

#import "TrainerTamedPokemon+DataController.h"
#import "Move.h"
#import "GameMenuMoveUnitView.h"


@interface GameMenuMoveViewController () {
 @private
  TrainerTamedPokemon * myPokemon_;
  NSArray             * fourMoves_;
  NSArray             * fourMovesPP_;
  
  GameMenuMoveUnitView * moveOneView_;
  GameMenuMoveUnitView * moveTwoView_;
  GameMenuMoveUnitView * moveThreeView_;
  GameMenuMoveUnitView * moveFourView_;
}

@property (nonatomic, retain) TrainerTamedPokemon * myPokemon;
@property (nonatomic, copy) NSArray               * fourMoves;
@property (nonatomic, copy) NSArray               * fourMovesPP;

@property (nonatomic, retain) GameMenuMoveUnitView * moveOneView;
@property (nonatomic, retain) GameMenuMoveUnitView * moveTwoView;
@property (nonatomic, retain) GameMenuMoveUnitView * moveThreeView;
@property (nonatomic, retain) GameMenuMoveUnitView * moveFourView;

@end


@implementation GameMenuMoveViewController

@synthesize myPokemon   = myPokemon_;
@synthesize fourMoves   = fourMoves_;
@synthesize fourMovesPP = fourMovesPP_;

@synthesize moveOneView   = moveOneView_;
@synthesize moveTwoView   = moveTwoView_;
@synthesize moveThreeView = moveThreeView_;
@synthesize moveFourView  = moveFourView_;

- (void)dealloc
{
  [myPokemon_   release];
  [fourMoves_   release];
  [fourMovesPP_ release];
  
  [moveOneView_    release];
  [moveTwoView_    release];
  [moveThreeView_  release];
  [moveFourView_   release];
  
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
  
  // Constants
  CGRect moveOneViewFrame   = CGRectMake(10.0f, 5.0f, 145.0f, 70.0f);
  CGRect moveTwoViewFrame   = CGRectMake(165.0f, 5.0f, 145.0f, 70.0f);
  CGRect moveThreeViewFrame = CGRectMake(10.0f, 85.0f, 145.0f, 70.0f);
  CGRect moveFourViewFrame  = CGRectMake(165.0f, 85.0f, 145.0f, 70.0f);
  
  
  // Set Four Moves' layout
  moveOneView_   = [[GameMenuMoveUnitView alloc] initWithFrame:moveOneViewFrame];
  moveTwoView_   = [[GameMenuMoveUnitView alloc] initWithFrame:moveTwoViewFrame];
  moveThreeView_ = [[GameMenuMoveUnitView alloc] initWithFrame:moveThreeViewFrame];
  moveFourView_  = [[GameMenuMoveUnitView alloc] initWithFrame:moveFourViewFrame];
  
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
  
  [self.view addSubview:moveOneView_];
  [self.view addSubview:moveTwoView_];
  [self.view addSubview:moveThreeView_];
  [self.view addSubview:moveFourView_];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.myPokemon = [TrainerTamedPokemon queryPokemonDataWithID:8];
  self.fourMoves = [self.myPokemon.fourMoves allObjects];
  
  if ([self.myPokemon.fourMovesPP isKindOfClass:[NSString class]]) {
    NSMutableArray * movesPP = [NSMutableArray arrayWithCapacity:8];
    for (id movePP in [self.myPokemon.fourMovesPP componentsSeparatedByString:@","])
      [movesPP addObject:[NSNumber numberWithInt:[movePP intValue]]];
    fourMovesPP_ = [[NSArray alloc] initWithArray:movesPP];
  }
  else fourMovesPP_ = [[NSArray alloc] initWithArray:self.myPokemon.fourMovesPP];
  
  
  Move * moveOne   = [self.fourMoves objectAtIndex:0];
  [self.moveOneView.type1 setText:[moveOne.type stringValue]];
  [self.moveOneView.name setText:NSLocalizedString(moveOne.name, nil)];
  [self.moveOneView.pp setText:[NSString stringWithFormat:@"%d/%d",
                                [[fourMovesPP_ objectAtIndex:1] intValue], [[fourMovesPP_ objectAtIndex:0] intValue]]];
  
  Move * moveTwo   = [self.fourMoves objectAtIndex:1];
  [self.moveTwoView.type1 setText:[moveTwo.type stringValue]];
  [self.moveTwoView.name setText:NSLocalizedString(moveTwo.name, nil)];
  [self.moveTwoView.pp setText:[NSString stringWithFormat:@"%d/%d",
                                [[fourMovesPP_ objectAtIndex:3] intValue], [[fourMovesPP_ objectAtIndex:2] intValue]]];
  
  Move * moveThree = [self.fourMoves objectAtIndex:2];
  [self.moveThreeView.type1 setText:[moveThree.type stringValue]];
  [self.moveThreeView.name setText:NSLocalizedString(moveThree.name, nil)];
  [self.moveThreeView.pp setText:[NSString stringWithFormat:@"%d/%d",
                                  [[fourMovesPP_ objectAtIndex:5] intValue], [[fourMovesPP_ objectAtIndex:4] intValue]]];
  
  Move * moveFour  = [self.fourMoves objectAtIndex:3];
  [self.moveFourView.type1 setText:[moveFour.type stringValue]];
  [self.moveFourView.name setText:NSLocalizedString(moveFour.name, nil)];
  [self.moveFourView.pp setText:[NSString stringWithFormat:@"%d/%d",
                                 [[fourMovesPP_ objectAtIndex:7] intValue], [[fourMovesPP_ objectAtIndex:6] intValue]]];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.myPokemon   = nil;
  self.fourMoves   = nil;
  self.fourMovesPP = nil;
  
  self.moveOneView    = nil;
  self.moveTwoView    = nil;
  self.moveThreeView  = nil;
  self.moveFourView   = nil;
}

@end
