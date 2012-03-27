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


@interface OAuthManager : NSObject

+ (OAuthManager *)sharedInstance;
- (UIViewController *)loginWith:(OAuthServiceProviderChoice)loginProvider;
- (BOOL)isSessionValid;

@end
