//
//  FullScreenLoadingViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 4/19/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "FullScreenLoadingViewController.h"

#import "GlobalConstants.h"
#import "GlobalRender.h"
#import "LoadingManager.h"
#import "ServerAPIClient.h"


@interface FullScreenLoadingViewController () {
@private
  UILabel  * title_;
  UILabel  * message_;
  UIButton * refreshButton_;
  
  BOOL isCheckingConnection_;
}

@property (nonatomic, retain) UILabel  * title;
@property (nonatomic, retain) UILabel  * message;
@property (nonatomic, retain) UIButton * refreshButton;

- (void)releaseSubviews;
- (void)refresh;

@end


@implementation FullScreenLoadingViewController

@synthesize title         = title_;
@synthesize message       = message_;
@synthesize refreshButton = refreshButton_;

- (void)dealloc {
  [self releaseSubviews];
  [super dealloc];
}

- (void)releaseSubviews {
  self.title         = nil;
  self.message       = nil;
  self.refreshButton = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    isCheckingConnection_ = NO;
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
  [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainViewBackgroundBlackWithFog.png"]]];
  [self.view setOpaque:NO];
  [self.view setAlpha:0.f];
//  [self.view setBackgroundColor:[UIColor colorWithRed:(30.f / 255.f)
//                                                green:(33.f / 255.f)
//                                                 blue:(32.f / 255.f)
//                                                alpha:1.f]];
  
  CGRect titleFrame = CGRectMake(30.f, 100.f, 260.f, 32.f);
  CGRect messageFrame = CGRectMake(30.f, 142.f, 260.f, 96.f);
  CGRect refreshButtonFrame = CGRectMake((kViewWidth - 64.f) / 2.f, 280.f, 64.f, 64.f);
  
  // Title
  title_ = [[UILabel alloc] initWithFrame:titleFrame];
  [title_ setBackgroundColor:[UIColor clearColor]];
  [title_ setTextColor:[GlobalRender textColorOrange]];
  [title_ setFont:[GlobalRender textFontBoldInSizeOf:20.f]];
  [title_ setText:NSLocalizedString(@"PMSConnectErrorTitle", nil)];
  [self.view addSubview:title_];
  
  // Message
  message_ = [[UILabel alloc] initWithFrame:messageFrame];
  [message_ setBackgroundColor:[UIColor clearColor]];
  [message_ setTextColor:[GlobalRender textColorNormal]];
  [message_ setFont:[GlobalRender textFontBoldInSizeOf:14.f]];
  [message_ setLineBreakMode:UILineBreakModeWordWrap];
  [message_ setNumberOfLines:0];
  [message_ setText:NSLocalizedString(@"PMSConnectErrorMessage", nil)];
  [message_ sizeToFit];
  [self.view addSubview:message_];
  
  refreshButton_ = [[UIButton alloc] initWithFrame:refreshButtonFrame];
  [refreshButton_ setImage:[UIImage imageNamed:@"IconRefresh.png"] forState:UIControlStateNormal];
  [refreshButton_ addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:refreshButton_];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  [self releaseSubviews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

// Load view animated
- (void)loadViewAnimated:(BOOL)animated {
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationCurveEaseIn
                   animations:^{
                     [self.view setAlpha:1.f];
                   }
                   completion:nil];
}

// Unload view animated
- (void)unloadViewAnimated:(BOOL)animated {
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationCurveEaseOut
                   animations:^{
                     [self.view setAlpha:0.f];
                   }
                   completion:^(BOOL finished) {
                     [self.view removeFromSuperview];
                   }];
}

#pragma mark - Private Methods

- (void)refresh {
  if (isCheckingConnection_)
    return;
  
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
  };
  void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"!!! CONNECTION to SERVER failed, ERROR: %@", error);
    // Hide loading
    [[LoadingManager sharedInstance] hideOverBar];
    isCheckingConnection_ = NO;
  };
  
  [[ServerAPIClient sharedInstance] checkConnectionToServerSuccess:success failure:failure];
  isCheckingConnection_ = YES;
}

@end
