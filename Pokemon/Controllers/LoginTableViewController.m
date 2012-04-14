//
//  LoginTableViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "LoginTableViewController.h"

#import "GlobalConstants.h"
#import "GlobalNotificationConstants.h"
#import "GlobalRender.h"
#import "CustomNavigationBar.h"


@interface LoginTableViewController () {
 @private
  UIView  * authenticatingView_;
  UILabel * authenticatingLabel_;
}

@property (nonatomic, retain) UIView  * authenticatingView;
@property (nonatomic, retain) UILabel * authenticatingLabel;

- (NSString *)nameForProvider:(OAuthServiceProviderChoice)provider;
- (void)showAuthenticatingView:(NSNotification *)notification;
- (void)hideView:(NSNotification *)notification;

@end


@implementation LoginTableViewController

@synthesize authenticatingView  = authenticatingView_;
@synthesize authenticatingLabel = authenticatingLabel_;

- (void)dealloc
{
  self.authenticatingView = nil;
  self.authenticatingView = nil;
  
  // Remove observer
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNLoginSucceed object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNAuthenticating object:nil];
  [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Show navigation bar, but hide back button
  [self.navigationController setNavigationBarHidden:NO];
  CustomNavigationBar * navigationBar = (CustomNavigationBar *)self.navigationController.navigationBar;
  [navigationBar setBackToRootButtonToHidden:YES animated:NO];
  [navigationBar setTitleWithText:NSLocalizedString(@"PMSLoginChoice", nil) animated:NO];
  navigationBar = nil;
  
  // Add observer for notification from |GTMOAuth2ViewControllerTouch+Custom|
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(showAuthenticatingView:)
                                               name:kPMNAuthenticating
                                             object:nil];
  // Add observer for notification from |ServerAPIClient|
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(hideView:)
                                               name:kPMNLoginSucceed
                                             object:nil];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.authenticatingView  = nil;
  self.authenticatingLabel = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return kOAuthServiceProviderChoicesCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  [cell.textLabel setText:[self nameForProvider:[indexPath row]]];
  return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CustomNavigationBar * navigationBar = (CustomNavigationBar *)self.navigationController.navigationBar;
  [navigationBar setBackToRootButtonToHidden:NO animated:YES];
  [navigationBar setTitleWithText:[self nameForProvider:[indexPath row]] animated:YES];
  [self.navigationController pushViewController:[[OAuthManager sharedInstance] loginWith:[indexPath row]]
                                       animated:YES];
  navigationBar = nil;
}

#pragma mark - Private Methods

// Name for OAuth Service Provider
- (NSString *)nameForProvider:(OAuthServiceProviderChoice)provider {
  NSString * providerName;
  switch (provider) {
    //case kOAuthServiceProviderChoiceFacebook:
      //providerName = @"Facebook";
      //break;
      
    //case kOAuthServiceProviderChoiceGithub:
      //providerName = @"Github";
      //break;
      
    case kOAuthServiceProviderChoiceGoogle:
      providerName = @"Google";
      break;
      
    //case kOAuthServiceProviderChoiceTwitter:
      //providerName = @"Twitter";
      //break;
      
    //case kOAuthServiceProviderChoiceWeibo:
      //providerName = @"Weibo";
      //break;
      
    default:
      break;
  }
  return providerName;
}

// Show view for authenticating
- (void)showAuthenticatingView:(NSNotification *)notification {
  if (self.authenticatingView == nil) {
    UIView * authenticatingView = [[UIView alloc] initWithFrame:self.view.frame];
    self.authenticatingView = authenticatingView;
    [authenticatingView release];
    [self.authenticatingView setBackgroundColor:[UIColor blackColor]];
    [self.authenticatingView setAlpha:0.f];
  }
  if (self.authenticatingLabel == nil) {
    UILabel * authenticatingLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 180.f, 290.f, 32.f)];
    self.authenticatingLabel = authenticatingLabel;
    [authenticatingLabel release];
    [self.authenticatingLabel setBackgroundColor:[UIColor clearColor]];
    [self.authenticatingLabel setTextColor:[GlobalRender textColorTitleWhite]];
    [self.authenticatingLabel setFont:[GlobalRender textFontBoldInSizeOf:20.f]];
    [self.authenticatingLabel setTextAlignment:UITextAlignmentCenter];
    [self.authenticatingLabel setText:NSLocalizedString(@"PMSAuthenticating", nil)];
    [self.authenticatingLabel setAlpha:0.f];
  }
  
  [self.view addSubview:self.authenticatingView];
  [self.view addSubview:self.authenticatingLabel];
  [UIView animateWithDuration:.3f
                        delay:.3f
                      options:UIViewAnimationCurveEaseIn
                   animations:^{
                     [self.authenticatingView  setAlpha:.85f];
                     [self.authenticatingLabel setAlpha:1.f];
                   }
                   completion:nil];
}

// Hide self view
- (void)hideView:(NSNotification *)notification {
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     [self.view setFrame:CGRectMake(kViewWidth, 0.f, kViewWidth, kViewHeight)];
                     
                     // Slide up the Navigation bar to hide it
                     CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
                     navigationBarFrame.origin.y = - navigationBarFrame.size.height;
                     [self.navigationController.navigationBar setFrame:navigationBarFrame];
                   }
                   completion:^(BOOL finished) {
                     [self.navigationController setNavigationBarHidden:YES];
                     [self.authenticatingView  removeFromSuperview];
                     [self.authenticatingLabel removeFromSuperview];
                     [self.view setFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
                     [self.navigationController.view removeFromSuperview];
                   }];
}

@end
