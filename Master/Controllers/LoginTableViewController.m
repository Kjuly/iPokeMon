//
//  LoginTableViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 3/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "LoginTableViewController.h"

#import "GlobalRender.h"
#import "CustomNavigationBar.h"
#import "LoginTableViewCell.h"


@interface LoginTableViewController () {
 @private
  UIView  * authenticatingView_;
  UILabel * authenticatingLabel_;
}

@property (nonatomic, strong) UIView  * authenticatingView;
@property (nonatomic, strong) UILabel * authenticatingLabel;

- (void)_setupNotificationObserver;
- (NSString *)_nameForProvider:(OAuthServiceProviderChoice)provider;
- (void)_showAuthenticatingView:(NSNotification *)notification;
- (void)_hideView:(NSNotification *)notification;

@end


@implementation LoginTableViewController

@synthesize authenticatingView  = authenticatingView_;
@synthesize authenticatingLabel = authenticatingLabel_;

- (void)dealloc
{
  // Remove observer
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithStyle:(UITableViewStyle)style
{
  if (self = [super initWithStyle:style]) {
    [self setTitle:NSLocalizedString(@"PMSLoginChoice", nil)];
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
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  CustomNavigationBar * navigationBar = (CustomNavigationBar *)self.navigationController.navigationBar;
  [navigationBar setBackToRootButtonToHidden:YES animated:NO];
  navigationBar = nil;
  
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINBackgroundBlack]]];
  
  // Setup notification observer
  [self _setupNotificationObserver];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.authenticatingView  = nil;
  self.authenticatingLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return kOAuthServiceProviderChoicesCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return kCellHeightOfLoginTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  LoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[LoginTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
  }
  
  // Get icon file name
  NSInteger row = indexPath.row;
  NSString * iconName;
  switch (row) {
    //case kOAuthServiceProviderChoiceFacebook:
      //iconName = kPMINIconSocialFacebook;
      //break;
      
    case kOAuthServiceProviderChoiceGoogle:
      iconName = kPMINIconSocialGoogle;
      break;
      
    //case kOAuthServiceProviderChoiceTwitter:
      //iconName = kPMINIconSocialTwitter;
      //break;
      
    default:
      iconName = kPMINIconSocialGoogle;
      break;
  }
  
  // Configure the cell...
  [cell.textLabel setBackgroundColor:[UIColor clearColor]];
  [cell configureCellWithTitle:[self _nameForProvider:[indexPath row]]
                          icon:[UIImage imageNamed:iconName]
                 accessoryType:UITableViewCellAccessoryNone];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  CustomNavigationBar * navigationBar = (CustomNavigationBar *)self.navigationController.navigationBar;
  [navigationBar setBackToRootButtonToHidden:NO animated:YES];
  id loginViewController = [[OAuthManager sharedInstance] loginWith:[indexPath row]];
  [loginViewController setTitle:[self _nameForProvider:[indexPath row]]];
  [self.navigationController pushViewController:loginViewController
                                       animated:YES];
  navigationBar       = nil;
  loginViewController = nil;
}

#pragma mark - Private Methods

// Setup notification observer
- (void)_setupNotificationObserver
{
  NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
  // Add observer for notification from |GTMOAuth2ViewControllerTouch+Custom|
  [notificationCenter addObserver:self
                         selector:@selector(_showAuthenticatingView:)
                             name:kPMNAuthenticating
                           object:nil];
  // Add observer for notification from |ServerAPIClient|
  [notificationCenter addObserver:self
                         selector:@selector(_hideView:)
                             name:kPMNLoginSucceed
                           object:nil];
}

// Name for OAuth Service Provider
- (NSString *)_nameForProvider:(OAuthServiceProviderChoice)provider
{
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
      providerName = @"";
      break;
  }
  return providerName;
}

// Show view for authenticating
- (void)_showAuthenticatingView:(NSNotification *)notification
{
  if (self.authenticatingView == nil) {
    UIView * authenticatingView = [[UIView alloc] initWithFrame:self.view.frame];
    self.authenticatingView = authenticatingView;
    [self.authenticatingView setBackgroundColor:[UIColor blackColor]];
  }
  if (self.authenticatingLabel == nil) {
    UILabel * authenticatingLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 160.f, 290.f, 32.f)];
    self.authenticatingLabel = authenticatingLabel;
    [self.authenticatingLabel setBackgroundColor:[UIColor clearColor]];
    [self.authenticatingLabel setTextColor:[GlobalRender textColorTitleWhite]];
    [self.authenticatingLabel setFont:[GlobalRender textFontBoldInSizeOf:20.f]];
    [self.authenticatingLabel setTextAlignment:NSTextAlignmentCenter];
    [self.authenticatingLabel setText:NSLocalizedString(@"PMSAuthenticating", nil)];
  }
  
  [self.authenticatingView  setAlpha:0.f];
  [self.authenticatingLabel setAlpha:0.f];
  [self.view addSubview:self.authenticatingView];
  [self.view addSubview:self.authenticatingLabel];
  [UIView animateWithDuration:.3f
                        delay:.3f
                      options:(UIViewAnimationOptions)UIViewAnimationCurveEaseIn
                   animations:^{
                     [self.authenticatingView  setAlpha:.85f];
                     [self.authenticatingLabel setAlpha:1.f];
                   }
                   completion:nil];
}

// Hide self view
- (void)_hideView:(NSNotification *)notification
{
  BOOL succeed = [[notification.userInfo valueForKey:@"succeed"] boolValue];
  void (^animations)() = ^{
    if (succeed) {
      [self.view setFrame:CGRectMake(kViewWidth, 0.f, kViewWidth, kViewHeight)];
      // Slide up the Navigation bar to hide it
      CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
      navigationBarFrame.origin.y = - navigationBarFrame.size.height;
      [self.navigationController.navigationBar setFrame:navigationBarFrame];
    }
    else {
      CGRect authenticatingViewFrame = self.authenticatingView.frame;
      authenticatingViewFrame.origin.x = kViewWidth;
      [self.authenticatingView setFrame:authenticatingViewFrame];
    }
  };
  void (^completion)(BOOL) = ^(BOOL finished) {
    if (succeed) {
      [self.navigationController setNavigationBarHidden:YES];
      [self.authenticatingView  removeFromSuperview];
      [self.authenticatingLabel removeFromSuperview];
      [self.view setFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
      [self.view removeFromSuperview];
      [self.navigationController.view removeFromSuperview];
    }
    else {
      [self.authenticatingView  removeFromSuperview];
      [self.authenticatingLabel removeFromSuperview];
    }
  };
  
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:animations
                   completion:completion];
}

@end
