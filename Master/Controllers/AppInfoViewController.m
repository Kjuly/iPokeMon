//
//  AppInfoViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 1/29/13.
//  Copyright (c) 2013 Kjuly. All rights reserved.
//

#import "AppInfoViewController.h"

#import "UIFont+Custom.h"


//#warning Please confirm these links' URL
NSString * const kKYFollowMeURLTwitter   = @"https://twitter.com/kJulYu";
NSString * const kKYFollowMeURLSinaWeibo = @"http://weibo.cn/Kjuly";


@interface AppInfoViewController ()

- (void)_followMe:(id)sender;

@end


@implementation AppInfoViewController

- (id)init
{
  if (self = [super init]) {
    [self setTitle:KYLocalizedString(@"PMSSettingAboutAppInfo", nil)];
  }
  return self;
}

- (void)loadView
{
  CGRect viewFrame = (CGRect){CGPointZero, {kKYViewWidth, kKYViewHeight - kKYNavigationBarBackButtonHeight}};
  UIView * view = [[UIView alloc] initWithFrame:viewFrame];
  [view setBackgroundColor:[UIColor whiteColor]];
  self.view = view;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // constants
  CGFloat contentWidth = kKYViewWidth - kKYAppInfoContentMargin * 2.f;
  CGFloat normalLabelHeight = 16.f;
  
  CGRect appTitleLabelFrame = CGRectMake(kKYAppInfoContentMargin, kKYAppInfoContentMargin, contentWidth, 64.f);
  CGRect appVersionLabelFrame =
    CGRectMake(kKYAppInfoContentMargin,
               kKYAppInfoContentMargin + appTitleLabelFrame.size.height,
               contentWidth,
               normalLabelHeight);
  CGRect appBuildDateLabelFrame =
    CGRectMake(kKYAppInfoContentMargin,
               appVersionLabelFrame.origin.y + appVersionLabelFrame.size.height + kKYContentMargin * 2.f,
               contentWidth,
               normalLabelHeight);
  CGRect horizontalLineFrame =
    CGRectMake(kKYAppInfoContentMargin,
               appBuildDateLabelFrame.origin.y + kKYAppInfoContentMargin,
               contentWidth,
               2.f);
  CGRect copyrightLabelFrame =
    CGRectMake(kKYAppInfoContentMargin,
               self.view.frame.size.height - kKYAppInfoContentMargin - normalLabelHeight - kCenterMainButtonSize / 2.f,
               contentWidth,
               normalLabelHeight);
  
  // subviews
  // app title label
  UILabel * appTitleLabel = [[UILabel alloc] initWithFrame:appTitleLabelFrame];
  [appTitleLabel setBackgroundColor:[UIColor clearColor]];
  [appTitleLabel setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
  [appTitleLabel setFont:[UIFont customBoldFontOfSize:kKYFontInSuperLargeSize]];
  [appTitleLabel setText:kKYAppBundleDisplayName];
  [appTitleLabel setAdjustsFontSizeToFitWidth:YES];
  [self.view addSubview:appTitleLabel];
  
  // app version label
  UILabel * appVersionLabel = [[UILabel alloc] initWithFrame:appVersionLabelFrame];
  [appVersionLabel setBackgroundColor:[UIColor clearColor]];
  [appVersionLabel setFont:[UIFont customBoldFontOfSize:kKYFontInSmallSize]];
  [appVersionLabel setText:[NSString stringWithFormat:@"%@ %@",
                            KYLocalizedString(@"PMSSettingAboutAppVersion", nil),
                            [[NSUserDefaults standardUserDefaults] stringForKey:kUDKeyAboutVersion]]];
  [self.view addSubview:appVersionLabel];
  
  // app build date label
  UILabel * appBuildDateLabel = [[UILabel alloc] initWithFrame:appBuildDateLabelFrame];
  [appBuildDateLabel setBackgroundColor:[UIColor clearColor]];
  [appBuildDateLabel setFont:[UIFont customBoldFontOfSize:kKYFontInSmallSize]];
  [appBuildDateLabel setText:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBuildDate"]];
  [self.view addSubview:appBuildDateLabel];
  
  // horizontal line
  UIView * horizontalLine = [[UIView alloc] initWithFrame:horizontalLineFrame];
  [horizontalLine setBackgroundColor:[UIColor blackColor]];
  [self.view addSubview:horizontalLine];
  
  
  // buttons
  CGRect buttonFrame =
    CGRectMake(kKYAppInfoContentMargin + (contentWidth / 2.f - kKYButtonInNormalSize) / 2.f,
               CGRectGetMaxY(horizontalLineFrame) + kKYAppInfoContentMargin * 2.f,
               kKYButtonInNormalSize,
               kKYButtonInNormalSize);
  // twitter
  UIButton * twitterButton = [[UIButton alloc] initWithFrame:buttonFrame];
  [twitterButton setImage:[UIImage imageNamed:kKYILogoTwitter] forState:UIControlStateNormal];
  [twitterButton setTag:kKYLogoTwitter];
  [twitterButton addTarget:self
                    action:@selector(_followMe:)
          forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:twitterButton];
  
  // sina weibo
  buttonFrame.origin.x += (contentWidth / 2.f);
  UIButton * sinaWeiboButton = [[UIButton alloc] initWithFrame:buttonFrame];
  [sinaWeiboButton setImage:[UIImage imageNamed:kKYILogoSinaWeibo] forState:UIControlStateNormal];
  [sinaWeiboButton setTag:kKYLogoSinaWeibo];
  [sinaWeiboButton addTarget:self
                      action:@selector(_followMe:)
            forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:sinaWeiboButton];
  
  
  // copyright
  UILabel * copyrightLabel = [[UILabel alloc] initWithFrame:copyrightLabelFrame];
  [copyrightLabel setBackgroundColor:[UIColor clearColor]];
  [copyrightLabel setFont:[UIFont customNormalFontOfSize:kKYFontInMiniSize]];
  [copyrightLabel setText:@"© 2012 - 2013 Kjuly"];
  [self.view addSubview:copyrightLabel];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Method

// follow me
- (void)_followMe:(id)sender
{
  KYLogoType logoType = [sender tag];
  
  NSString * urlInString = nil;
  if (logoType == kKYLogoTwitter)        urlInString = kKYFollowMeURLTwitter;
  else if (logoType == kKYLogoSinaWeibo) urlInString = kKYFollowMeURLSinaWeibo;
  else return;
  
  if (! [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlInString]])
    NSLog(@"Failed to open url: %@", urlInString);
}

@end
