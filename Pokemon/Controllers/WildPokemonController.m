//
//  WildPokemonController.m
//  Pokemon
//
//  Created by Kaijie Yu on 4/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "WildPokemonController.h"

#import "GlobalConstants.h"
#import "PokemonConstants.h"
#import "PokemonServerAPI.h"
#import "AppDelegate.h"
#import "WildPokemon.h"
#import "Pokemon+DataController.h"

#import "AFJSONRequestOperation.h"


@interface WildPokemonController () {
 @private
  
}

- (void)updateWildPokemon:(WildPokemon *)wildPokemon withData:(NSDictionary *)data;

@end


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
    // Update the data for |WildPokemon|
    for (NSDictionary * wildPokemonData in wildPokemons) {
      // Check the existence of the object
      [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"uid == %@", [wildPokemonData valueForKey:@"uid"]]];
      
      // If exist, execute fetching request, otherwise, insert new object
      WildPokemon * wildPokemon;
      if ([managedObjectContext countForFetchRequest:fetchRequest error:&error])
        wildPokemon = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
      else wildPokemon = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                                       inManagedObjectContext:managedObjectContext];
      // Update data for current |wildPokemon|
      [self updateWildPokemon:wildPokemon withData:wildPokemonData];
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
  NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[PokemonServerAPI APIGetWildPokemonsForCurrentRegion:1]];
  AFJSONRequestOperation * operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                       success:blockPopulateData
                                                                                       failure:blockError];
  [request release];
  [operation start];
}

#pragma mark - Private Methods

// Update data for WildPokemon entity
- (void)updateWildPokemon:(WildPokemon *)wildPokemon withData:(NSDictionary *)data {
  // Update basic data fetched from server
  wildPokemon.uid         = [data valueForKey:@"uid"];
  wildPokemon.sid         = [data valueForKey:@"sid"];
  wildPokemon.status      = kPokemonStatusNormal;
  wildPokemon.level       = [data valueForKey:@"level"];
  
  // Fetch Pokemon entity with |sid|
  Pokemon * pokemon = [Pokemon queryPokemonDataWithID:[[data valueForKey:@"sid"] intValue]];
  wildPokemon.pokemon = pokemon; // Relationship betweent Pokemon & WildPokemon
  
  // Gender: 0:Female 1:Male 2:Genderless
  PokemonGenderRate pokemonGenderRate = [pokemon.genderRate intValue];
  NSInteger gender;
  if      (pokemonGenderRate == kPokemonGenderRateAlwaysFemale) gender = 0;
  else if (pokemonGenderRate == kPokemonGenderRateAlwaysMale)   gender = 1;
  else if (pokemonGenderRate == kPokemonGenderRateGenderless)   gender = 2;
  else {
    float randomValue = arc4random() % 100 / 10; // Random value for calculating
    float genderRate = 25 * ((pokemonGenderRate == kPokemonGenderRateFemaleOneEighth) ? .5f : (pokemonGenderRate - 2));
    gender = randomValue < genderRate ? 0 : 1;
  }
  wildPokemon.gender = [NSNumber numberWithInt:gender];
  
  // Set data
  
  
  wildPokemon.fourMoves   = [data valueForKey:@"fourMoves"];
  wildPokemon.maxStats    = [data valueForKey:@"maxStats"];
  wildPokemon.hp          = [data valueForKey:@"currHP"];
  wildPokemon.exp         = [data valueForKey:@"currEXP"];
  wildPokemon.toNextLevel = [data valueForKey:@"toNextLevel"];
  
  pokemon = nil;
}

@end
