//
//  OAuthManager.h
//  iPokeMon
//
//  Created by Kaijie Yu on 3/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTMOAuth2ViewControllerTouch+Custom.h"

typedef enum {
//  kOAuthServiceProviderChoiceFacebook = 0,
//  kOAuthServiceProviderChoiceGithub,
  kOAuthServiceProviderChoiceGoogle,
//  kOAuthServiceProviderChoiceTwitter,
//  kOAuthServiceProviderChoiceWeibo,
  kOAuthServiceProviderChoicesCount
}OAuthServiceProviderChoice;


// OAuth Manager
@interface OAuthManager : NSObject {
  BOOL isNewworkAvailable_;
}

@property (nonatomic, assign) BOOL isNewworkAvailable;

+ (OAuthManager *)sharedInstance;

- (BOOL)isSessionValid;                        // Session status for User
- (NSString *)userEmailInMD5;                  // User Email in MD5
- (OAuthServiceProviderChoice)serviceProvider; // Current service provider user using

- (UIViewController *)loginWith:(OAuthServiceProviderChoice)serviceProvider;
- (void)revokeAuthorizedWith:(OAuthServiceProviderChoice)serviceProvider;
- (void)logout;

@end
