//
//  FullScreenLoadingViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 4/19/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "FullScreenLoadingViewController.h"

#import "GlobalRender.h"
#import "LoadingManager.h"
#import "ServerAPIClient.h"
#import "OAuthManager.h"


@interface FullScreenLoadingViewController () {
@private
  UILabel  * title_;
  UILabel  * message_;
  UIButton * refreshButton_;
  
  PMError error_;                // error type
  BOOL    isCheckingConnection_; // prevent press fresh button continuously
}

@property (nonatomic, retain) UILabel  * title;
@property (nonatomic, retain) UILabel  * message;
@property (nonatomic, retain) UIButton * refreshButton;

- (void)_releaseSubviews;
- (void)_refresh;

@end


@implementation FullScreenLoadingViewController

@synthesize title         = title_;
@synthesize message       = message_;
@synthesize refreshButton = refreshButton_;

- (void)dealloc {
  [self _releaseSubviews];
  [super dealloc];
}

- (void)_releaseSubviews {
  self.title         = nil;
  self.message       = nil;
  self.refreshButton = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    error_                = kPMErrorUnknow;
    isCheckingConnection_ = NO;
  }
  return self;
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
  UIView * view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, {kViewWidth, kViewHeight}}];
  [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINLaunchViewBackground]]];
  [view setOpaque:NO];
  [view setAlpha:0.f];
  
  CGRect titleFrame = CGRectMake(30.f, 100.f, 260.f, 32.f);
  CGRect refreshButtonFrame = CGRectMake((kViewWidth - 64.f) / 2.f, 280.f, 64.f, 64.f);
  
  // Title
  title_ = [[UILabel alloc] initWithFrame:titleFrame];
  [title_ setBackgroundColor:[UIColor clearColor]];
  [title_ setTextColor:[GlobalRender textColorOrange]];
  [title_ setFont:[GlobalRender textFontBoldInSizeOf:20.f]];
  [view addSubview:title_];
  
  // Message
  message_ = [[UILabel alloc] init];
  [message_ setBackgroundColor:[UIColor clearColor]];
  [message_ setTextColor:[GlobalRender textColorNormal]];
  [message_ setFont:[GlobalRender textFontBoldInSizeOf:14.f]];
  [message_ setLineBreakMode:UILineBreakModeWordWrap];
  [message_ setNumberOfLines:0];
  
  [view addSubview:message_];
  
  refreshButton_ = [[UIButton alloc] initWithFrame:refreshButtonFrame];
  [refreshButton_ setImage:[UIImage imageNamed:kPMINIconRefresh] forState:UIControlStateNormal];
  [refreshButton_ addTarget:self action:@selector(_refresh) forControlEvents:UIControlEventTouchUpInside];
  [view addSubview:refreshButton_];
  
  self.view = view;
  [view release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  [self _releaseSubviews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

// Load view animated
- (void)loadViewForError:(PMError)error
                animated:(BOOL)animated {
  NSLog(@"!!!ERROR: %d", error);
  error_ = error;
  // set text for |title_| & |message_|
  [self.title   setText:NSLocalizedString(([NSString stringWithFormat:@"PMSError%.2dT", error]), nil)];
  [self.message setFrame:CGRectMake(30.f, 142.f, 260.f, 96.f)];
  [self.message setText:NSLocalizedString(([NSString stringWithFormat:@"PMSError%.2dM", error]), nil)];
  [self.message sizeToFit];
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:(UIViewAnimationOptions)UIViewAnimationCurveEaseIn
                   animations:^{ [self.view setAlpha:1.f]; }
                   completion:nil];
}

// Unload view animated
- (void)unloadViewAnimated:(BOOL)animated {
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:(UIViewAnimationOptions)UIViewAnimationCurveEaseOut
                   animations:^{
                     [self.view setAlpha:0.f];
                   }
                   completion:^(BOOL finished) {
                     if (! [[OAuthManager sharedInstance] isSessionValid])
                       NSLog(@"!!!ERROR: session invalid");
                     [self.view removeFromSuperview];
                   }];
}

#pragma mark - Private Methods

- (void)_refresh {
  if (isCheckingConnection_)
    return;
  isCheckingConnection_ = YES;
  
  // if the error is 'network not available', check connection to server
  if (error_ & kPMErrorNetworkNotAvailable) {
    // Show loading
    [[LoadingManager sharedInstance] showOverBar];
    
    // Block: |success| & |failure|
    void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
      NSLog(@"...Checking CONNECTION to SERVER...");
      // If connection to server succeed, unload view
      if ([responseObject valueForKey:@"v"])
        [self unloadViewAnimated:YES];
      
      // Hide loading
      [[LoadingManager sharedInstance] hideOverBar];
      isCheckingConnection_ = NO;
      
      // set |isNewworkAvailable_| to YES for |OAuthManager|, so it can check session again
      [OAuthManager sharedInstance].isNewworkAvailable = YES;
    };
    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"!!! CONNECTION to SERVER failed, ERROR: %@", error);
      // Hide loading
      [[LoadingManager sharedInstance] hideOverBar];
      isCheckingConnection_ = NO;
    };
    
    [[ServerAPIClient sharedInstance] checkConnectionToServerSuccess:success failure:failure];
  }
  // if the error is 'authentication failed',
  //   post notification with 'loagin faild' info to |LoginTableViewController| to hide authentication view
  else if (error_ & kPMErrorAuthenticationFailed) {
    NSDictionary * userInfo =
      [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"succeed", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNLoginSucceed object:self userInfo:userInfo];
    [userInfo release];
    isCheckingConnection_ = NO;
    [self unloadViewAnimated:YES];
  }
  // if unknow error occurred, go back to main view
  else {
    isCheckingConnection_ = NO;
    [self unloadViewAnimated:YES];
  }
}

@end
