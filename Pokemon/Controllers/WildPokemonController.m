//
//  WildPokemonController.m
//  Pokemon
//
//  Created by Kaijie Yu on 4/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "WildPokemonController.h"

#import "PokemonServerAPI.h"
#import "AppDelegate.h"
#import "WildPokemon.h"
#import "Pokemon+DataController.h"

#import "AFJSONRequestOperation.h"


@implementation WildPokemonController

// Singleton
static WildPokemonController * wildPokemonController_ = nil;
+ (WildPokemonController *)sharedInstance {
  if (wildPokemonController_ != nil)
    return wildPokemonController_;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    wildPokemonController_ = [[WildPokemonController alloc] init];
  });
  return wildPokemonController_;
}

- (id)init {
  if (self = [super init]) {
  }
  return self;
}

#pragma mark - Public Methods

- (void)updateForCurrentRegion:(NSInteger)regionID {
  // Success Block Method
  void (^blockPopulateData)(NSURLRequest *, NSHTTPURLResponse *, id) =
  ^(NSURLRequest * request, NSHTTPURLResponse * response, id JSON) {
    NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    // Get JSON Data Array from HTTP Response
    NSArray * wildPokemons = [JSON valueForKey:@"wildpokemons"];
    
    NSError * error;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class])
                                        inManagedObjectContext:managedObjectContext]];
    [fetchRequest setFetchLimit:1];
    
    // Update the data for |tamedPokemmon|
    for (NSDictionary * wildPokemonData in wildPokemons) {
      // Check the existence of the object
      [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"uid == %@", [wildPokemonData valueForKey:@"uid"]]];
      
      // If exist, execute fetching request, otherwise, insert new object
      WildPokemon * wildPokemon;
      if ([managedObjectContext countForFetchRequest:fetchRequest error:&error])
        wildPokemon = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
      else {
        wildPokemon = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                                    inManagedObjectContext:managedObjectContext];
        // Set relationships
        Pokemon * pokemon = [Pokemon queryPokemonDataWithID:[[wildPokemonData valueForKey:@"sid"] intValue]];
        wildPokemon.pokemon = pokemon;
        pokemon = nil;
        
//        NSArray * moveIDs = [[wildPokemonData valueForKey:@"fourMovesID"] componentsSeparatedByString:@","];
//        NSArray * moves = [Move queryFourMovesDataWithIDs:moveIDs];
//        [wildPokemon addFourMoves:[NSSet setWithArray:moves]];
//        moves = nil;
//        moveIDs = nil;
      }
      
      // Set data
      wildPokemon.uid         = [wildPokemonData valueForKey:@"uid"];
      wildPokemon.sid         = [wildPokemonData valueForKey:@"sid"];
      wildPokemon.status      = [wildPokemonData valueForKey:@"status"];
      wildPokemon.gender      = [wildPokemonData valueForKey:@"gender"];
      wildPokemon.level       = [wildPokemonData valueForKey:@"level"];
      wildPokemon.fourMoves   = [wildPokemonData valueForKey:@"fourMoves"];
      wildPokemon.maxStats    = [wildPokemonData valueForKey:@"maxStats"];
      wildPokemon.currHP      = [wildPokemonData valueForKey:@"currHP"];
      wildPokemon.currEXP     = [wildPokemonData valueForKey:@"currEXP"];
      wildPokemon.toNextLevel = [wildPokemonData valueForKey:@"toNextLevel"];
    }
    
    [fetchRequest release];
    
    if (! [managedObjectContext save:&error])
      NSLog(@"!!! Couldn't save data to %@", NSStringFromClass([self class]));
    NSLog(@"...Update |%@| data done...", [self class]);
  };
  
  // Failure Block Method
  void (^blockError)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id) =
  ^(NSURLRequest *request, NSHTTPURLResponse * response, NSError * error, id JSON) {
    NSLog(@"!!! ERROR: %@", error);
  };
  
  
  // Fetch data from server & populate the |teamedPokemon|
  NSURLRequest * request =
  [[NSURLRequest alloc] initWithURL:[PokemonServerAPI APIGetWildPokemonsForCurrentRegion:1]];
  
  AFJSONRequestOperation * operation =
  [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                  success:blockPopulateData
                                                  failure:blockError];
  [request release];
  [operation start];
}

@end
