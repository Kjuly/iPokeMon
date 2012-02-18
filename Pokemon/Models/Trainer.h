//
//  Trainer.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/18/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TrainerBagBattleItem, TrainerBagBerry, TrainerBagItem, TrainerBagKeyItem, TrainerBagMail, TrainerBagMedicine, TrainerBagPokeball, TrainerBagTMHM, TrainerTamedPokemon;

@interface Trainer : NSManagedObject

@property (nonatomic, retain) NSDate * adventureStarted;
@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pokedex;
@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSSet *bagItems;
@property (nonatomic, retain) NSSet *tamedPokemons;
@property (nonatomic, retain) NSSet *bagMedicine;
@property (nonatomic, retain) NSSet *bagPokeballs;
@property (nonatomic, retain) NSSet *bagTMsHMs;
@property (nonatomic, retain) NSSet *bagBerries;
@property (nonatomic, retain) NSSet *bagMails;
@property (nonatomic, retain) NSSet *bagBattleItems;
@property (nonatomic, retain) NSSet *bagKeyItems;
@end

@interface Trainer (CoreDataGeneratedAccessors)

- (void)addBagItemsObject:(TrainerBagItem *)value;
- (void)removeBagItemsObject:(TrainerBagItem *)value;
- (void)addBagItems:(NSSet *)values;
- (void)removeBagItems:(NSSet *)values;

- (void)addTamedPokemonsObject:(TrainerTamedPokemon *)value;
- (void)removeTamedPokemonsObject:(TrainerTamedPokemon *)value;
- (void)addTamedPokemons:(NSSet *)values;
- (void)removeTamedPokemons:(NSSet *)values;

- (void)addBagMedicineObject:(TrainerBagMedicine *)value;
- (void)removeBagMedicineObject:(TrainerBagMedicine *)value;
- (void)addBagMedicine:(NSSet *)values;
- (void)removeBagMedicine:(NSSet *)values;

- (void)addBagPokeballsObject:(TrainerBagPokeball *)value;
- (void)removeBagPokeballsObject:(TrainerBagPokeball *)value;
- (void)addBagPokeballs:(NSSet *)values;
- (void)removeBagPokeballs:(NSSet *)values;

- (void)addBagTMsHMsObject:(TrainerBagTMHM *)value;
- (void)removeBagTMsHMsObject:(TrainerBagTMHM *)value;
- (void)addBagTMsHMs:(NSSet *)values;
- (void)removeBagTMsHMs:(NSSet *)values;

- (void)addBagBerriesObject:(TrainerBagBerry *)value;
- (void)removeBagBerriesObject:(TrainerBagBerry *)value;
- (void)addBagBerries:(NSSet *)values;
- (void)removeBagBerries:(NSSet *)values;

- (void)addBagMailsObject:(TrainerBagMail *)value;
- (void)removeBagMailsObject:(TrainerBagMail *)value;
- (void)addBagMails:(NSSet *)values;
- (void)removeBagMails:(NSSet *)values;

- (void)addBagBattleItemsObject:(TrainerBagBattleItem *)value;
- (void)removeBagBattleItemsObject:(TrainerBagBattleItem *)value;
- (void)addBagBattleItems:(NSSet *)values;
- (void)removeBagBattleItems:(NSSet *)values;

- (void)addBagKeyItemsObject:(TrainerBagKeyItem *)value;
- (void)removeBagKeyItemsObject:(TrainerBagKeyItem *)value;
- (void)addBagKeyItems:(NSSet *)values;
- (void)removeBagKeyItems:(NSSet *)values;

@end
