//
//  GTMOAuth2ViewControllerTouch+Custom.m
//  iPokeMon
//
//  Created by Kaijie Yu on 4/3/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GTMOAuth2ViewControllerTouch+Custom.h"

#import "CustomNavigationBar.h"

@implementation GTMOAuth2ViewControllerTouch (Custom)

// Overwrite method:|viewDidLoad|
- (void)viewDidLoad
{
  // the app may prefer some html other than blank white to be displayed
  // before the sign-in web page loads
  self.initialHTMLString =
    [NSString stringWithFormat:@"<html><style type=\"text/css\">\
     body{ background:#000 url('%@'); font-size:20px; color:#fff; font-family:Arial, Helvetica, sans-serif; text-align:center; }\
     div.main{ margin:160px auto; font-size:20px; font-weight:bold; }</style>\
     <body><div class=\"main\">%@</div></body></html>",
     kPMINBackgroundBlack, NSLocalizedString(@"PMSLoginSigninPage", nil)];
  NSString * basePath = [[NSBundle mainBundle] bundlePath];
  CGRect webViewFrame = self.webView.frame;
  webViewFrame.origin.y = -kNavigationBarBottomAlphaHegiht;
  webViewFrame.size.height += kNavigationBarBottomAlphaHegiht;
  [self.webView setFrame:webViewFrame];
  [self.webView loadHTMLString:self.initialHTMLString
                       baseURL:[NSURL fileURLWithPath:basePath]];
  
  // Implement the completion block
  // iOS4 will not call |viewWillAppear:| when the VC is a child of another VC
  if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
    [self viewWillAppear:YES];
}

// Overwrite method:|popView|
- (void)popView
{
  if (self.navigationController.topViewController == self) {
    if (! self.view.isHidden) {
      // Set the flag to our viewWillDisappear method so it knows
      // this is a disappearance initiated by the sign-in object,
      // not the user cancelling via the navigation controller
      didDismissSelf_ = YES;
      
      [(CustomNavigationBar *)self.navigationController.navigationBar backToRoot:nil];
      self.view.hidden = YES;
      
      // Post notification to |LoginTableViewController| to show the view for authenticating
      [[NSNotificationCenter defaultCenter] postNotificationName:kPMNAuthenticating object:self userInfo:nil];
    }
  }
}

@end
