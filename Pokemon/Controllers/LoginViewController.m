//
//  LoginViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/23/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "LoginViewController.h"

#import "GlobalConstants.h"
#import "GTMOAuth2ViewControllerTouch.h"
//#import "AFHTTPRequestOperation.h"


static NSString * const kKeychainItemName = @"OAuth2 Sample: Google+";

typedef enum {
  kLoginTypeNormal = 0,
  kLoginTypeGoogle = 1,
  kLoginTypeGithub = 2
}LoginType;


@interface LoginViewController () {
 @private
  UIWebView * webView_;
  UIButton  * cancelButton_;
  NSString  * domain_;
}

@property (nonatomic, retain) UIWebView * webView;
@property (nonatomic, retain) UIButton  * cancelButton;
@property (nonatomic, copy)   NSString  * domain;

- (NSString *)getTokenFromCookie;
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error;
- (void)loadWebView:(id)sender;
- (void)unloadWebView;

@end


@implementation LoginViewController

@synthesize webView      = webView_;
@synthesize cancelButton = cancelButton_;
@synthesize domain       = domain_;

- (void)dealloc
{
  [webView_      release];
  [cancelButton_ release];
  [domain_       release];
  
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
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
  self.view = view;
  [view release];
  [self.view setBackgroundColor:[UIColor blackColor]];
  
  // Login buttons
  // Google
  UIButton * loginWithGoogle = [[UIButton alloc] initWithFrame:CGRectMake(10.f, 30.f, 300.f, 30.f)];
  [loginWithGoogle setBackgroundColor:[UIColor whiteColor]];
  [loginWithGoogle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [loginWithGoogle setTitle:@"Login with Google" forState:UIControlStateNormal];
  [loginWithGoogle addTarget:self action:@selector(loadWebView:) forControlEvents:UIControlEventTouchUpInside];
  [loginWithGoogle setTag:kLoginTypeGoogle];
  [self.view addSubview:loginWithGoogle];
  [loginWithGoogle release];
  
  // Github
  UIButton * loginWithGithub = [[UIButton alloc] initWithFrame:CGRectMake(10.f, 70.f, 300.f, 30.f)];
  [loginWithGithub setBackgroundColor:[UIColor whiteColor]];
  [loginWithGithub setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [loginWithGithub setTitle:@"Login with Github" forState:UIControlStateNormal];
  [loginWithGithub addTarget:self action:@selector(loadWebView:) forControlEvents:UIControlEventTouchUpInside];
  [loginWithGithub setTag:kLoginTypeGithub];
  [self.view addSubview:loginWithGithub];
  [loginWithGithub release];
  
  
  // Web view
  CGRect webViewFrame = self.view.frame;
  webViewFrame.origin.y = kViewHeight;
  webView_ = [[UIWebView alloc] initWithFrame:webViewFrame];
  [webView_ setBackgroundColor:[UIColor whiteColor]];
  [webView_ setDelegate:self];
  [self.view addSubview:webView_];
  
  // Create a fake |mapButton_| as the cancel button
  UIButton * cancelButton = [[UIButton alloc] initWithFrame:CGRectMake((kViewWidth - kMapButtonSize) / 2,
                                                                       - kMapButtonSize,
                                                                       kMapButtonSize,
                                                                       kMapButtonSize)];
  self.cancelButton = cancelButton;
  [cancelButton release];
  [self.cancelButton setContentMode:UIViewContentModeScaleAspectFit];
  [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"MainViewMapButtonBackground.png"]
                               forState:UIControlStateNormal];
  [self.cancelButton setImage:[UIImage imageNamed:@"MainViewMapButtonImageHalfCancel.png"] forState:UIControlStateNormal];
  [self.cancelButton setOpaque:NO];
  [self.cancelButton addTarget:self
                        action:@selector(unloadWebView)
              forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.cancelButton];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.webView      = nil;
  self.cancelButton = nil;
  self.domain       = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // If, after initiating a network-based load request, you must release your 
  //  web view for any reason, you must cancel the pending request before releasing
  //  the web view. You can cancel a load request using the web view’s stopLoading
  //  method.
  // A typical place to include this code would be in the |viewWillDisappear:|
  //  method of the owning view controller. To determine if a request is still
  //  pending, you can check the value in the web view’s loading property.
//  if (self.webView.loading) [self.webView stopLoading];
//  // disconnect the delegate as the webview is hidden
//  self.webView.delegate = nil;
//  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIWebView Delegate

- (BOOL)           webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
            navigationType:(UIWebViewNavigationType)navigationType {
  NSLog(@"- Request URL: %@", request.URL);
  if ([request.URL.scheme isEqualToString:@"pm-ios-auth-github"]) {
    [self.webView stopLoading];
    
    NSString * URLString = [request.URL absoluteString];
    NSString * code = [[URLString componentsSeparatedByString:@"="] lastObject];
    NSLog(@"-- Code: %@", code);
    NSLog(@"-- URL.Query: %@", request.URL.query);
    NSString * authenticateURLString = [NSString stringWithFormat:
                                        @"https://github.com/login/oauth/access_token?client_id=%@&client_secret=%@&code=%@",
                                        @"f8f903e2a3e2dab5d32b",//CLIENT_ID,
                                        @"57d5d921e1a08114d286cba415712ea8182436dc",//CLIENT_SECRET
                                        code];
//    NSString * authenticateURLString = @"https://github.com/login/oauth/access_token";
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:authenticateURLString]];
    NSString * body = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@",
                       @"f8f903e2a3e2dab5d32b",//CLIENT_ID,
                       @"57d5d921e1a08114d286cba415712ea8182436dc",//CLIENT_SECRET
                       code];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [self.webView loadRequest:request];
    [request release];
//    [self.webView stopLoading];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:authenticateURLString]]];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authenticateURLString]];
//    [[UIApplication sharedApplication] openURL:request.URL];
    return NO;
  }
  return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  NSLog(@"WebView Did Start Load");
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  NSLog(@"WebView Did Finish Load");
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  
  NSString * URLString = [[self.webView.request URL] absoluteString];
  NSLog(@"- URL: %@", URLString);
  if ([URLString rangeOfString:@"access_token="].location != NSNotFound) {
    NSString * accessToken = [[URLString componentsSeparatedByString:@"="] lastObject];
    NSLog(@"-- AccessToken: %@", accessToken);
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:accessToken forKey:@"access_token"];
//    [defaults synchronize];
//    [self dismissModalViewControllerAnimated:YES];
    [self unloadWebView];
  }
  
  
//  NSString * token = [self getTokenFromCookie];
//  if (token != nil) {
//    NSLog(@"TOKEN: %@", token);
//    [self.delegate gotToken:token];
//    [self.navigationController popViewControllerAnimated:YES];
//  }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  NSString * errorString =
  [NSString stringWithFormat:@"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
   error.localizedDescription];
  [self.webView loadHTMLString:errorString baseURL:nil];
}

#pragma mark - Private Methods

- (NSString *)getTokenFromCookie {
  NSHTTPCookie * cookie;
  NSHTTPCookieStorage * cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  NSLog(@"Domain: %@", self.domain);
  for (cookie in [cookieJar cookies]) {
    NSLog(@"Cookie_Name:   %@", [cookie name]);
    NSLog(@"Cookie_Value:  %@", [cookie value]);
    NSLog(@"Cookie_Domain: %@", [cookie domain]);
    NSLog(@"Cookie_Path:   %@", [cookie path]);
    NSLog(@"- - -");
    if ([[cookie domain] isEqualToString:self.domain]) {
      if([[cookie name] isEqualToString:@"s_ppv"]) return [cookie value];
//      if ([[cookie name] isEqualToString:@"oauth_token"]) return [cookie value];
    }
  }
  return nil;
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
  if (error != nil) {
    // Authentication failed
  } else {
    // Authentication succeeded
  }
}

- (void)loadWebView:(id)sender {
//  CGRect webViewFrame = self.view.frame;
  
  NSString * authenticateURLString;
  switch (((UIButton *)sender).tag) {
    case kLoginTypeGoogle:
//      authenticateURLString = @"https://www.google.com/accounts/o8/id\
//      ?openid.ns=http://specs.openid.net/auth/2.0\
//      &openid.claimed_id=http://specs.openid.net/auth/2.0/identifier_select\
//      &openid.identity=http://specs.openid.net/auth/2.0/identifier_select";
      authenticateURLString = @"https://developer.apple.com";
      break;
      
    case kLoginTypeGithub:
      authenticateURLString = [NSString stringWithFormat:
                               @"https://github.com/login/oauth/authorize?client_id=%@&scope=%@",
                               @"f8f903e2a3e2dab5d32b",//CLIENT_ID,
                               @"user"];
      break;
      
    default:
      break;
  }
  
  NSString * kMyClientID     = @"890704274988.apps.googleusercontent.com"; // pre-assigned by service
  NSString * kMyClientSecret = @"skqxc_5MysvtBsFFhIXqADr2"; // pre-assigned by service
  
  NSString *scope = @"https://www.googleapis.com/auth/plus.me"; // scope for Google+ API
  
  GTMOAuth2ViewControllerTouch * viewController;
  viewController = [[[GTMOAuth2ViewControllerTouch alloc] initWithScope:scope
                                                              clientID:kMyClientID
                                                          clientSecret:kMyClientSecret
                                                      keychainItemName:kKeychainItemName
                                                              delegate:self
                                                      finishedSelector:@selector(viewController:finishedWithAuth:error:)] autorelease];
  // Optional: display some html briefly before the sign-in page loads
  NSString *html = @"<html><body bgcolor=silver><div align=center>Loading sign-in page...</div></body></html>";
  viewController.initialHTMLString = html;
  
  [self.view addSubview:viewController.view];
  
  
//  [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:authenticateURLString]]];
//  self.domain = [[NSURL URLWithString:authenticateURLString] host];
//  
//  [UIView animateWithDuration:.3f
//                        delay:0.f
//                      options:UIViewAnimationOptionTransitionCurlUp
//                   animations:^{
//                     [self.webView setFrame:webViewFrame];
//                     [self.cancelButton setFrame:CGRectMake((kViewWidth - kMapButtonSize) / 2,
//                                                            - (kMapButtonSize / 2),
//                                                            kMapButtonSize,
//                                                            kMapButtonSize)];
//                   }
//                   completion:nil];
}

- (void)unloadWebView {
  CGRect webViewFrame = self.view.frame;
  webViewFrame.origin.y = kViewHeight;
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionTransitionCurlUp
                   animations:^{
                     [self.webView setFrame:webViewFrame];
                     [self.cancelButton setFrame:CGRectMake((kViewWidth - kMapButtonSize) / 2,
                                                            - kMapButtonSize,
                                                            kMapButtonSize,
                                                            kMapButtonSize)];
                   }
                   completion:nil];
}

@end
