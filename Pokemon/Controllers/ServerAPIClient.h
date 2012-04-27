//
//  ServerAPIClient.h
//  Pokemon
//
//  Created by Kaijie Yu on 4/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"


// Server API
@interface ServerAPI : NSObject
+ (NSURL *)getURLForUserID;
@end


typedef enum {
  kDataFetchTargetTrainer      = 1 << 0,
  kDataFetchTargetTamedPokemon = 1 << 1,
  kDataFetchTargetWildPokemon  = 1 << 2,
}DataFetchTarget;

@interface ServerAPIClient : AFHTTPClient

+ (ServerAPIClient *)sharedInstance;

// Connection checking
- (void)checkConnectionToServerSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
// Trainer
- (void)fetchUserIDSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)fetchDataFor:(DataFetchTarget)target
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)updateData:(NSDictionary *)data
         forTarget:(DataFetchTarget)target
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)checkUniquenessForName:(NSString *)name
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// WildPokemon
- (void)updateWildPokemonsForCurrentRegion:(NSDictionary *)regionInfo
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
