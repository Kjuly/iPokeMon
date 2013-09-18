//
//  LoadingManager.m
//  iPokeMon
//
//  Created by Kaijie Yu on 4/13/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "LoadingManager.h"

#import "GlobalRender.h"


#pragma mark - LoadingBar

@interface LoadingBar () {
 @private
  UIProgressView * progressBar_;
}

@property (nonatomic, strong) UIProgressView * progressBar;

@end


@implementation LoadingBar

@synthesize progressBar = progressBar_;

// Singleton
static LoadingBar * loadingBar_ = nil;
+ (LoadingBar *)sharedInstance
{
  if (loadingBar_ != nil)
    return loadingBar_;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    loadingBar_ = [[LoadingBar alloc] init];
  });
  return loadingBar_;
}


- (id)init
{
  if (self = [super initWithFrame:CGRectMake(0.f, kViewHeight - 20.f, kViewWidth, 20.f)]) {
    self.windowLevel = UIWindowLevelStatusBar;
    [self setBackgroundColor:[UIColor whiteColor]];
    
    progressBar_ = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [progressBar_ setFrame:CGRectMake(0.f, 5.f, 320.f, 20.f)];
    [self addSubview:progressBar_];
    
    /*UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
    label.text = @"testing";
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    [self addSubview:label];
    NSLog(@"label %@", label);
    [label release];*/
    
    [self makeKeyAndVisible];
  }
  return self;
}

// Set value for progress bar
- (void)setProgress:(float)progress
{
  if (progress < self.progressBar.progress || progress < 0)
    return;
  [self.progressBar setProgress:progress animated:YES];
}

// Done prgressing
- (void)done
{
  [self.progressBar setProgress:0 animated:NO];
  [[[[UIApplication sharedApplication] windows] objectAtIndex:0] makeKeyWindow];
}

@end


#pragma mark -
#pragma mark - LoadingManager

@interface LoadingManager () {
 @private
  NSInteger    overViewLoadingCounter_;
  NSInteger    overBarLoadingCounter_;
  LoadingBar * loadingBar_;
  NSInteger    resourceCounter_;
}

@property (nonatomic, strong) LoadingBar * loadingBar;

@end


@implementation LoadingManager

@synthesize loadingBar = loadingBar_;

// Singleton
static LoadingManager * loadingManager_ = nil;
+ (LoadingManager *)sharedInstance
{
  if (loadingManager_ != nil)
    return loadingManager_;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    loadingManager_ = [[LoadingManager alloc] init];
  });
  return loadingManager_;
}


- (id)init
{
  if (self = [super init]) {
    overViewLoadingCounter_ = 0;
    overBarLoadingCounter_  = 0;
//    self.loadingBar         = [LoadingBar sharedInstance];
    resourceCounter_        = 0;
  }
  return self;
}

#pragma mark - Public Methods

#pragma mark - Loading over View

// Show loading over view
- (void)showOverView
{
  if (++overViewLoadingCounter_ == 1)
    [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
  NSLog(@"LOADING OVER VIEW SHOW: %d", overViewLoadingCounter_);
}

// Hide loading over view
- (void)hideOverView
{
  --overViewLoadingCounter_;
  if (overViewLoadingCounter_ < 0)
    overViewLoadingCounter_ = 0;
  if (overViewLoadingCounter_ == 0) {
    [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
    // Post notification that loading done
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNLoadingDone object:self userInfo:nil];
  }
  NSLog(@"LOADING OVER VIEW HIDE: %d", overViewLoadingCounter_);
}

// Clean all loading over view
- (void)cleanOverView
{
  if (overViewLoadingCounter_ > 0) {
    [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
    overViewLoadingCounter_ = 0;
  }
}

#pragma mark - Loading over Bar

// Show loading over bar
- (void)showOverBar
{
  if (++overBarLoadingCounter_ == 1)
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  NSLog(@"LOADING OVER BAR SHOW: %d", overBarLoadingCounter_);
}

// Hide loading over bar
- (void)hideOverBar
{
  --overBarLoadingCounter_;
  if (overBarLoadingCounter_ < 0)
    overBarLoadingCounter_ = 0;
  if (overBarLoadingCounter_ == 0)
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  NSLog(@"LOADING OVER BAR HIDE: %d", overBarLoadingCounter_);
}

// Clean all loading over bar
- (void)cleanOverBar
{
  if (overBarLoadingCounter_ > 0) {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    overBarLoadingCounter_ = 0;
  }
}

#pragma mark - Show Message

- (void)showMessage:(NSString *)message
               type:(ProgressMessageType)type
       withDuration:(NSTimeInterval)duration
{
  MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:
                          [[[UIApplication sharedApplication] delegate] window]];
	[[[[UIApplication sharedApplication] delegate] window] addSubview:HUD];
	
  NSString * iconName;
  switch (type) {
    case kProgressMessageTypeSucceed:
      iconName = kPMINMainButtonConfirm;
      break;
      
    case kProgressMessageTypeInfo:
      iconName = kPMINMainButtonInfo;
      break;
      
    case kProgressMessageTypeWarn:
      iconName = kPMINMainButtonWarning;
      break;
      
    case kProgressMessageTypeError:
      iconName = kPMINMainButtonCancel;
      break;
      
    case kProgressMessageTypeNone:
    default:
      iconName = nil;
      break;
  }
	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
	// Set custom view mode
	HUD.mode = MBProgressHUDModeCustomView;
	
	HUD.delegate = self;
	HUD.labelText = message;
	
	[HUD show:YES];
	[HUD hide:YES afterDelay:duration];
}

#pragma mark - Progress Bar's resource unit Management

// New resource wait to be loaded
- (void)addResourceToLoadingQueue
{
  ++resourceCounter_;
  NSLog(@"+++ LOADING RESOURCES COUNT:%d", resourceCounter_);
}

// Done loading for a resource unit
- (void)popResourceFromLoadingQueue
{
  if (resourceCounter_ == 0) {
    NSLog(@"!!!|popResourceFromLoadingQueue| but |resourceCounter_| is 0 already!!!");
    return;
  }
  
  [self.loadingBar setProgress:(100.f / resourceCounter_)];
  --resourceCounter_;
  if (resourceCounter_ == 0) {
    NSLog(@"--- LOADING RESOURCES DONE!");
    [loadingBar_ done];
    return;
  }
  NSLog(@"--- LOADING RESOURCES COUNT:%d", resourceCounter_);
}

@end
