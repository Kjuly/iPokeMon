//
//  DeviceBlockingViewController.m
//  Master
//
//  Created by Kjuly on 3/1/13.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "DeviceBlockingViewController.h"

#import "GlobalRender.h"
#import "OAuthManager.h"


@interface DeviceBlockingViewController () {
 @private
  UILabel  * messageTitle_;
  UILabel  * messageBody_;
  UIButton * logoutButton_;
}

@property (nonatomic, strong) UILabel  * messageTitle;
@property (nonatomic, strong) UILabel  * messageBody;
@property (nonatomic, strong) UIButton * logoutButton;

- (void)_logout:(id)sender;

@end


@implementation DeviceBlockingViewController

@synthesize messageTitle = messageTitle_,
            messageBody  = messageBody_;
@synthesize logoutButton = logoutButton_;

- (id)init
{
  if (self = [super init]) {
    // Custom initialization
    messageTitle_ = [[UILabel alloc] init];
    messageBody_  = [[UILabel alloc] init];
  }
  return self;
}

- (void)loadView
{
  UIView * view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, {kKYViewWidth, kKYViewHeight}}];
  [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINLaunchViewBackground]]];
  self.view = view;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  
  // Constants
  CGRect titleFrame   = CGRectMake(30.f, 100.f, 260.f, 32.f);
  CGRect messageFrame = CGRectMake(30.f, 142.f, 260.f, 96.f);
  
  // Title
  [messageTitle_ setFrame:titleFrame];
  [messageTitle_ setBackgroundColor:[UIColor clearColor]];
  [messageTitle_ setTextColor:[GlobalRender textColorOrange]];
  [messageTitle_ setFont:[GlobalRender textFontBoldInSizeOf:20.f]];
  [self.view addSubview:messageTitle_];
  
  // Message
  [messageBody_ setFrame:messageFrame];
  [messageBody_ setBackgroundColor:[UIColor clearColor]];
  [messageBody_ setTextColor:[GlobalRender textColorNormal]];
  [messageBody_ setFont:[GlobalRender textFontBoldInSizeOf:14.f]];
  [messageBody_ setLineBreakMode:NSLineBreakByWordWrapping];
  [messageBody_ setNumberOfLines:0];
  [self.view addSubview:messageBody_];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

// Logout
- (void)_logout:(id)sender {
  // Logout account
  [[OAuthManager sharedInstance] logout];
  [self.view removeFromSuperview];
}

#pragma mark - Public Method

// Update view for type
- (void)updateViewForType:(PMDeviceBlockingType)type {
  NSString * title, * message;
  
  switch (type) {
    case kPMDeviceBlockingTypeOfInvitationOnly:
      title   = @"PMLS:DeviceBlocking:InvitationOnly:Title";
      message = @"PMLS:DeviceBlocking:InvitationOnly:Body";
      break;
      
    case kPMDeviceBlockingTypeOfUIDNotMatched: {
      title   = @"PMLS:DeviceBlocking:UIDNotMatched:Title";
      message = @"PMLS:DeviceBlocking:UIDNotMatched:Body";
      if (self.logoutButton == nil) {
        CGRect logoutButtonFrame =
          CGRectMake(kKYContentMarginLevel_2, kKYViewHeight / 2.f + kKYButtonInSmallSize,
                     kKYViewWidth - kKYContentMarginLevel_4, kKYButtonInSmallSize);
        UIButton * logoutButton = [[UIButton alloc] initWithFrame:logoutButtonFrame];
        [logoutButton setBackgroundColor:[UIColor colorWithWhite:0.f alpha:.5f]];
        [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [logoutButton setTitle:NSLocalizedString(@"PMSSettingMoreLogout", nil)
                      forState:UIControlStateNormal];
        [logoutButton addTarget:self
                         action:@selector(_logout:)
               forControlEvents:UIControlEventTouchUpInside];
        self.logoutButton = logoutButton;
        [self.view addSubview:self.logoutButton];
      }
      break;
    }
      
    case kPMDeviceBlockingTypeNone:
    default:
      title   = nil;
      message = nil;
      break;
  }
  [self.messageTitle setText:NSLocalizedString(title, nil)];
  [self.messageBody  setText:NSLocalizedString(message, nil)];
  [self.messageTitle sizeToFit];
  [self.messageBody  sizeToFit];
}

@end
