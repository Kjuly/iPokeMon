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


@interface GameMenuMoveViewController () {
 @private
  TrainerTamedPokemon * trainerPokemon_;
  NSArray             * fourMoves_;
  NSArray             * fourMovesPP_;
  
  GameMenuMoveUnitView * moveOneView_;
  GameMenuMoveUnitView * moveTwoView_;
  GameMenuMoveUnitView * moveThreeView_;
  GameMenuMoveUnitView * moveFourView_;
}

@property (nonatomic, retain) TrainerTamedPokemon * trainerPokemon;
@property (nonatomic, copy) NSArray               * fourMoves;
@property (nonatomic, copy) NSArray               * fourMovesPP;

@property (nonatomic, retain) GameMenuMoveUnitView * moveOneView;
@property (nonatomic, retain) GameMenuMoveUnitView * moveTwoView;
@property (nonatomic, retain) GameMenuMoveUnitView * moveThreeView;
@property (nonatomic, retain) GameMenuMoveUnitView * moveFourView;

- (void)useSelectedMove:(id)sender;

@end


@implementation GameMenuMoveViewController

@synthesize trainerPokemon = trainerPokemon_;
@synthesize fourMoves      = fourMoves_;
@synthesize fourMovesPP    = fourMovesPP_;

@synthesize moveOneView   = moveOneView_;
@synthesize moveTwoView   = moveTwoView_;
@synthesize moveThreeView = moveThreeView_;
@synthesize moveFourView  = moveFourView_;

- (void)dealloc
{
  [trainerPokemon_ release];
  [fourMoves_      release];
  [fourMovesPP_    release];
  
  [moveOneView_    release];
  [moveTwoView_    release];
  [moveThreeView_  release];
  [moveFourView_   release];
  
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
  CGRect moveOneViewFrame   = CGRectMake(10.f, 20.f, 280.f, 45.f);
  CGRect moveTwoViewFrame   = CGRectMake(10.f, 65.f, 280.f, 45.f);
  CGRect moveThreeViewFrame = CGRectMake(10.f, 110.f, 280.f, 45.f);
  CGRect moveFourViewFrame  = CGRectMake(10.f, 155.f, 280.f, 45.f);
  
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
  
  [self.tableAreaView addSubview:moveOneView_];
  [self.tableAreaView addSubview:moveTwoView_];
  [self.tableAreaView addSubview:moveThreeView_];
  [self.tableAreaView addSubview:moveFourView_];
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
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.trainerPokemon = nil;
  self.fourMoves      = nil;
  self.fourMovesPP    = nil;
  
  self.moveOneView    = nil;
  self.moveTwoView    = nil;
  self.moveThreeView  = nil;
  self.moveFourView   = nil;
}

#pragma mark - Private Methods

- (void)useSelectedMove:(id)sender
{
  NSInteger moveTag = ((UIButton *)sender).tag;
  NSLog(@"Use Move %d", moveTag);
  
  Move * move = [self.fourMoves objectAtIndex:moveTag - 1];
  
  // Set data for message in |GameMenuViewController|
  NSInteger pokemonID = [self.trainerPokemon.sid intValue];
  NSInteger moveID    = [move.sid intValue];
  // Post message: (<PokemonName> used <MoveName>, etc) to |messageView_| in |GameMenuViewController|
  NSString * message = [NSString stringWithFormat:@"%@ %@ %@",
                        NSLocalizedString(([NSString stringWithFormat:@"PMSName%.3d", pokemonID]), nil),
                        NSLocalizedString(@"PMS_used", nil),
                        NSLocalizedString(([NSString stringWithFormat:@"PMSMoveName%.3d", moveID]), nil)];
  NSDictionary * messageInfo = [NSDictionary dictionaryWithObject:message forKey:@"message"];
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUpdateGameBattleMessage object:self userInfo:messageInfo];
  
  // Send parameter to Move Effect Controller
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"TrainerPokemon", @"MoveOwner",
                             move.baseDamage, @"damage",
                             nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNMoveEffect object:nil userInfo:userInfo];
  [userInfo release];
  
  [self unloadViewWithAnimation];
  [[GameStatus sharedInstance] trainerTurnEnd];
}

@end
