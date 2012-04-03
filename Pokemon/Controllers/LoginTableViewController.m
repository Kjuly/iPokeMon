//
//  LoginTableViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "LoginTableViewController.h"

#import "GlobalNotificationConstants.h"


@interface LoginTableViewController () {
 @private
  
}

- (void)hideView:(NSNotification *)notification;

@end


@implementation LoginTableViewController

- (void)dealloc
{
  [super dealloc];
  
  // Remove observer
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNLoginSucceed object:nil];
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
  
  // Add observer for notification from |ServerAPIClient|
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideView:) name:kPMNLoginSucceed object:nil];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
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
  NSString * loginProviderName;
  switch ([indexPath row]) {
    case kOAuthServiceProviderChoiceFacebook:
      loginProviderName = @"Facebook";
      break;
      
    case kOAuthServiceProviderChoiceGithub:
      loginProviderName = @"Github";
      break;
      
    case kOAuthServiceProviderChoiceGoogle:
      loginProviderName = @"Google";
      break;
      
    case kOAuthServiceProviderChoiceTwitter:
      loginProviderName = @"Twitter";
      break;
      
    case kOAuthServiceProviderChoiceWeibo:
      loginProviderName = @"Weibo";
      break;
      
    default:
      break;
  }
  [cell.textLabel setText:loginProviderName];
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
  [self.navigationController pushViewController:[[OAuthManager sharedInstance] loginWith:[indexPath row]]
                                       animated:YES];
}

#pragma mark - Private Methods

- (void)hideView:(NSNotification *)notification {
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveLinear
                   animations:^{ [self.view setAlpha:0.f]; }
                   completion:^(BOOL finished) {
                     [self.view removeFromSuperview];
                     [self.view setAlpha:1.f];
                   }];
}

@end
