//
//  GameWildPokemon.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GameWildPokemon.h"

#import "GameStatus.h"
#import "GlobalNotificationConstants.h"
#import "WildPokemon+DataController.h"
#import "Pokemon.h"
#import "Move.h"


@interface GameWildPokemon () {
 @private
  WildPokemon * wildPokemon_;
}

@property (nonatomic, retain) WildPokemon * wildPokemon;

@end

@implementation GameWildPokemon

static int attackDelayTime = 150;

@synthesize wildPokemon = wildPokemon_;

- (void)dealloc
{
  [super dealloc];
}

- (id)initWithPokemonID:(NSInteger)pokemonID keyName:(NSString *)keyName
{
  if (self = [super init]) {
    // Base Setting
    self.pokemonBattleStatus = kPokemonBattleStatusNormal;
    
    // Data Setting
    self.wildPokemon   = [WildPokemon queryPokemonDataWithID:pokemonID];
    self.pokemonID     = [self.wildPokemon.sid intValue];
    self.pokemonSprite = [CCSprite spriteWithCGImage:((UIImage *)self.wildPokemon.pokemon.image).CGImage
                                                 key:keyName];
    [self.pokemonSprite setPosition:ccp(-90, 350)];
    [self addChild:self.pokemonSprite];
    
    // Set HP
    //
    // TODO:
    //   Data Transform NSString -> NSArray
    //
//    NSLog(@"TODO: %@, %@", self.wildPokemon.maxStats, [self.wildPokemon.maxStats class]);
//    NSArray * maxStats;
//    if ([self.wildPokemon.maxStats isKindOfClass:[NSString class]]) {
//      NSLog(@"!!! WARNING: self.wildPokemon.maxStats isKindOfClass:[NSString class]");
//      NSMutableArray * maxStatsArray = [NSMutableArray arrayWithCapacity:8];
//      for (id stat in [self.wildPokemon.maxStats componentsSeparatedByString:@","])
//        [maxStatsArray addObject:[NSNumber numberWithInt:[stat intValue]]];
//      maxStats = [[NSArray alloc] initWithArray:maxStatsArray];
//      maxStatsArray = nil;
//    }
//    else maxStats = [[NSArray alloc] initWithArray:self.wildPokemon.maxStats];
    
//    self.hpMax = [[maxStats objectAtIndex:0] intValue];
    self.hpMax = [[self.wildPokemon.maxStats objectAtIndex:0] intValue];
    self.hp    = self.hpMax;
//    maxStats = nil;
    
    // Create Hp Bar
//    hpBar_ = [[GamePokemonHPBar alloc] initWithHP:self.hp hpMax:self.hpMax];
//    [hpBar_ setPosition:ccp(10, 330)];
//    [self addChild:hpBar_];
  }
  return self;
}

- (void)update:(ccTime)dt
{
  [super update:dt];
  
  // Acation
  // If it's Wild Pokemon's Turn, it'll use Move to Attack
  [self attack:dt];
}

#pragma mark - Wild Pokemon's Move Attack

- (void)attack:(ccTime)dt
{
  if ([[GameStatus sharedInstance] isWildPokemonTurn]) {
    attackDelayTime -= 100 * dt;
    if (attackDelayTime > 0)
      return;
    
    // Do Move Attack
    //
    // TODO:
    //   Need an algorithm to choose the MOVE
    //
    Move * move = [[self.wildPokemon.fourMoves allObjects] objectAtIndex:0];
    
    // Set data for message in |GameMenuViewController|
    NSInteger pokemonID = [self.wildPokemon.sid intValue];
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
                               @"WildPokemon", @"MoveOwner",
                               self.wildPokemon.sid, @"pokemonID",
                               move.sid, @"moveID",
                               move.baseDamage, @"damage", nil];
    // Notification target: |GameMoveEffect|
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNMoveEffect object:nil userInfo:userInfo];
    [userInfo release];
    
    [[GameStatus sharedInstance] wildPokemonTurnEnd];
    attackDelayTime = 150;
  }
}

@end
