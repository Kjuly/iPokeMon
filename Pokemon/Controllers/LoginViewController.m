//
//  LoginViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/23/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "LoginViewController.h"

#import "GlobalConstants.h"


@interface LoginViewController () {
 @private
  UIWebView * webView_;
  UIButton  * cancelButton_;
}

@property (nonatomic, retain) UIWebView * webView;
@property (nonatomic, retain) UIButton  * cancelButton;

- (void)loadWebView;
- (void)unloadWebView;

@end


@implementation LoginViewController

@synthesize webView      = webView_;
@synthesize cancelButton = cancelButton_;

- (void)dealloc
{
  [webView_      release];
  [cancelButton_ release];
  
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
  [loginWithGoogle addTarget:self action:@selector(loadWebView) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:loginWithGoogle];
  [loginWithGoogle release];
  
  // Web view
  CGRect webViewFrame = self.view.frame;
  webViewFrame.origin.y = kViewHeight;
  webView_ = [[UIWebView alloc] initWithFrame:webViewFrame];
  [webView_ setBackgroundColor:[UIColor whiteColor]];
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

- (void)loadWebView {
  CGRect webViewFrame = self.view.frame;
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
