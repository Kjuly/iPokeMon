//
//  AccountSettingViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/23/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "AccountSettingViewController.h"

#import "AccountSettingTableViewController.h"


@interface AccountSettingViewController ()

- (void)cancelAccountSettingTableView;

@end

@implementation AccountSettingViewController

@synthesize delegate = delegate_;
@synthesize topBar   = topBar_;
@synthesize accountSettingTableViewController = accountSettingTableViewController_;

- (void)dealloc
{
  [topBar_ release];
  [accountSettingTableViewController_ release];
  
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
  [super loadView];
  
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
  self.view = view;
  [view release];
  
  // Cteate Table View
  accountSettingTableViewController_ = [[AccountSettingTableViewController alloc] initWithStyle:UITableViewStylePlain];
  [accountSettingTableViewController_.view setFrame:CGRectMake(0.0f, 55.0f, 320.0f, 425.0f)];
  [self.view addSubview:accountSettingTableViewController_.view];
  
  // Create Top Bar
  UIImage * topBarBackgroundImage = [UIImage imageNamed:@"NavigationBarBackgroundBlue.png"];
  CGFloat topBarHeight = topBarBackgroundImage.size.height;
  topBar_ = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, topBarHeight)];
  [topBar_ setBackgroundColor:[UIColor colorWithPatternImage:topBarBackgroundImage]];
  [topBar_ setOpaque:NO];
  
  // Create Button to Cancel View
  UIImage * cancelButtonImage = [UIImage imageNamed:@"AccountSettingTableView_CancelButton.png"];
  UIButton * cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(14.0f, 8.0f, cancelButtonImage.size.width, cancelButtonImage.size.height)];
  [cancelButton setImage:cancelButtonImage forState:UIControlStateNormal];
  [cancelButton addTarget:self action:@selector(cancelAccountSettingTableView) forControlEvents:UIControlEventTouchUpInside];
  [topBar_ addSubview:cancelButton];
  [cancelButton release];
  
  [self.view addSubview:topBar_];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.topBar = nil;
  self.accountSettingTableViewController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

- (void)cancelAccountSettingTableView {
  [delegate_ cancelAccountSettingTableView];
}

@end
