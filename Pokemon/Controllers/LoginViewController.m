//
//  LoginViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/23/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "LoginViewController.h"

#import "GlobalConstants.h"

typedef enum {
  kLoginTypeNormal = 0,
  kLoginTypeGoogle = 1
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
  UIButton * loginWithGoogle = [[UIButton alloc] initWithFrame:CGRectMake(10.f, 30.f, 300.f, 30.f)];
  [loginWithGoogle setBackgroundColor:[UIColor whiteColor]];
  [loginWithGoogle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [loginWithGoogle setTitle:@"Login with Google" forState:UIControlStateNormal];
  [loginWithGoogle addTarget:self action:@selector(loadWebView:) forControlEvents:UIControlEventTouchUpInside];
  [loginWithGoogle setTag:kLoginTypeGoogle];
  [self.view addSubview:loginWithGoogle];
  [loginWithGoogle release];
  
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

- (void)webViewDidStartLoad:(UIWebView *)webView {
  NSLog(@"WebView Did Start Load");
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  NSLog(@"WebView Did Finish Load");
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  
  NSString * token = [self getTokenFromCookie];
  if (token != nil) {
    NSLog(@"TOKEN: %@", token);
//    [self.delegate gotToken:token];
//    [self.navigationController popViewControllerAnimated:YES];
  }
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

- (void)loadWebView:(id)sender {
  CGRect webViewFrame = self.view.frame;
  
  NSString * authenticateUrl;
  switch (((UIButton *)sender).tag) {
    case kLoginTypeGoogle:
//      authenticateUrl = @"https://www.google.com/accounts/o8/id\
//      ?openid.ns=http://specs.openid.net/auth/2.0\
//      &openid.claimed_id=http://specs.openid.net/auth/2.0/identifier_select\
//      &openid.identity=http://specs.openid.net/auth/2.0/identifier_select";
      authenticateUrl = @"https://developer.apple.com";
      break;
      
    default:
      break;
  }
  
  [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:authenticateUrl]]];
  self.domain = [[NSURL URLWithString:authenticateUrl] host];
  
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionTransitionCurlUp
                   animations:^{
                     [self.webView setFrame:webViewFrame];
                     [self.cancelButton setFrame:CGRectMake((kViewWidth - kMapButtonSize) / 2,
                                                            - (kMapButtonSize / 2),
                                                            kMapButtonSize,
                                                            kMapButtonSize)];
                   }
                   completion:nil];
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
