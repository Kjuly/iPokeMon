//
//  OAuthManager.h
//  Pokemon
//
//  Created by Kaijie Yu on 3/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTMOAuth2ViewControllerTouch.h"

typedef enum {
  kOAuthServiceProviderChoiceFacebook  = 0,
  kOAuthServiceProviderChoiceGithub,
  kOAuthServiceProviderChoiceGoogle,
  kOAuthServiceProviderChoiceTwitter,
  kOAuthServiceProviderChoiceWeibo,
  kOAuthServiceProviderChoicesCount
}OAuthServiceProviderChoice;

typedef enum {
  kDataFetchTargetTrainer      = 1 << 0,
  kDataFetchTargetTamedPokemon = 1 << 1,
  kDataFetchTargetWildPokemon  = 1 << 2,
}DataFetchTarget;


// Server API
@interface ServerAPI : NSObject
@end

// OAuth Manager
@interface OAuthManager : NSObject

+ (OAuthManager *)sharedInstance;
- (UIViewController *)loginWith:(OAuthServiceProviderChoice)serviceProvider;
- (void)revokeAuthorizedWith:(OAuthServiceProviderChoice)serviceProvider;
- (void)logout;
- (BOOL)isSessionValid;
- (OAuthServiceProviderChoice)serviceProvider;

- (void)fetchDataFor:(DataFetchTarget)target
             success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
             failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;
- (void)updateDataFor:(DataFetchTarget)target
              success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
              failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

@end
