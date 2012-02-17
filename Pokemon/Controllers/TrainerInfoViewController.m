//
//  TrainerInfoViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "TrainerInfoViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "GlobalColor.h"
#import "Trainer+DataController.h"
#import "AppDelegate.h"


@implementation TrainerInfoViewController

@synthesize fetchedResultsController = fetchedResultsController_;

- (void)dealloc
{
  [fetchedResultsController_ release];
  
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
//    [Trainer updateData];
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
  [self.view setBackgroundColor:[UIColor whiteColor]];
  
  // Constants
  CGFloat const imageHeight       = 100.0f;
  CGFloat const imageWidth        = 100.0f;
  
  CGFloat const labelHeight       = 30.0f;
  CGFloat const labelWidth        = 105.0f;
  CGFloat const valueHeight       = 30.0f;
  CGFloat const valueWidth        = 300.0f - labelWidth;
  
  CGFloat const nameLabelWidth    = 300.0f - imageWidth;
  CGFloat const nameLabelHeight   = imageHeight / 2 - labelHeight;
  
  CGRect  const IDViewFrame       = CGRectMake(imageWidth + 25.0f, 30.0f, 300.0f - imageWidth, imageHeight - 50.0f);
  CGRect  const dataViewFrame     = CGRectMake(10.0f, imageHeight + 35.0f, 300.0f, 195.0f);
  
  
  ///Left Image View
  UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 20.0f, imageWidth, imageHeight)];
  [imageView setUserInteractionEnabled:YES];
  [imageView setContentMode:UIViewContentModeCenter];
  [imageView setBackgroundColor:[UIColor clearColor]];
  [imageView.layer setMasksToBounds:YES];
  [imageView.layer setCornerRadius:5.0f];
  [imageView setImage:[UIImage imageNamed:@"UserAvatar.png"]];
  
  [self.view addSubview:imageView];
  [imageView release];
  
  
  ///Right ID View
  UIView * IDView = [[UIView alloc] initWithFrame:IDViewFrame];
  
  // ID
  UILabel * IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, IDView.frame.size.width, labelHeight)];
  [IDLabel setBackgroundColor:[UIColor clearColor]];
  [IDLabel setTextColor:[GlobalColor textColorBlue]];
  [IDLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:20.0f]];
  [IDLabel setText:[NSString stringWithFormat:@"ID: #%.8d", 1]];
  [IDView addSubview:IDLabel];
  [IDLabel release];
  
  // Name
  UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, labelHeight, nameLabelWidth, nameLabelHeight)];
  [nameLabel setBackgroundColor:[UIColor clearColor]];
  [nameLabel setLineBreakMode:UILineBreakModeWordWrap];
  [nameLabel setTextColor:[GlobalColor textColorOrange]];
  [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:26.0f]];
  [nameLabel setNumberOfLines:0];
  [nameLabel setText:@"Trainer Name"];
  [nameLabel sizeToFit];
  [nameLabel.layer setShadowColor:[nameLabel.textColor CGColor]];
  [nameLabel.layer setShadowOpacity:1.0f];
  [nameLabel.layer setShadowOffset:CGSizeMake(0.0f, 1.0f)];
  [nameLabel.layer setShadowRadius:1.0f];
  [IDView addSubview:nameLabel];
  [nameLabel release];
  
  // Add Right ID View to |self.view| & Release it
  [self.view addSubview:IDView];
  [IDView release];
  
  
  ///Data View in Center
  UIView * dataView = [[UIView alloc] initWithFrame:dataViewFrame];
  
  // Money
  UILabel * moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, labelWidth, labelHeight)];
  UILabel * moneyValue = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, 0.0f, valueWidth, valueHeight)];
  [moneyLabel setBackgroundColor:[UIColor clearColor]];
  [moneyValue setBackgroundColor:[UIColor clearColor]];
  [moneyLabel setTextColor:[GlobalColor textColorBlue]];
  [moneyLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18.0f]];
  [moneyLabel setTextAlignment:UITextAlignmentRight];
  [moneyValue setTextAlignment:UITextAlignmentLeft];
  [moneyLabel setText:@"Money: "];
  [moneyValue setText:[NSString stringWithFormat:@"$ %d", 999999]];
  [dataView addSubview:moneyLabel];
  [dataView addSubview:moneyValue];
  [moneyLabel release];
  [moneyValue release];
  
  // Pokedex
  UILabel * pokedexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, labelHeight, labelWidth, labelHeight)];
  UILabel * pokedexValue = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, labelHeight, valueWidth, valueHeight)];
  [pokedexLabel setBackgroundColor:[UIColor clearColor]];
  [pokedexValue setBackgroundColor:[UIColor clearColor]];
  [pokedexLabel setTextColor:[GlobalColor textColorBlue]];
  [pokedexLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18.0f]];
  [pokedexLabel setTextAlignment:UITextAlignmentRight];
  [pokedexValue setTextAlignment:UITextAlignmentLeft];
  [pokedexLabel setText:@"Pokedex: "];
  [pokedexValue setText:@"151"];
  [dataView addSubview:pokedexLabel];
  [dataView addSubview:pokedexValue];
  [pokedexLabel release];
  [pokedexValue release];
  
  // Badges
  UILabel * badgesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, labelHeight * 2, labelWidth, labelHeight)];
  UILabel * badgesValue = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, labelHeight * 2, valueWidth, valueHeight)];
  [badgesLabel setBackgroundColor:[UIColor clearColor]];
  [badgesValue setBackgroundColor:[UIColor clearColor]];
  [badgesLabel setTextColor:[GlobalColor textColorBlue]];
  [badgesLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18.0f]];
  [badgesLabel setTextAlignment:UITextAlignmentRight];
  [badgesValue setTextAlignment:UITextAlignmentLeft];
  [badgesLabel setText:@"Badges: "];
  [badgesValue setText:@"123"];
  [dataView addSubview:badgesLabel];
  [dataView addSubview:badgesValue];
  [badgesLabel release];
  [badgesValue release];
  
  // Adventure Started
  UILabel * adventureStartedTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,
                                                                                  dataView.frame.size.height - labelHeight,
                                                                                  170.0f,
                                                                                  labelHeight)];
  UILabel * adventureStartedTimeValue = [[UILabel alloc] initWithFrame:CGRectMake(170.0f,
                                                                                  dataView.frame.size.height - labelHeight,
                                                                                  130.0f,
                                                                                  valueHeight)];
  [adventureStartedTimeLabel setBackgroundColor:[UIColor clearColor]];
  [adventureStartedTimeValue setBackgroundColor:[UIColor clearColor]];
  [adventureStartedTimeLabel setTextColor:[GlobalColor textColorBlue]];
  [adventureStartedTimeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:16.0f]];
  [adventureStartedTimeValue setFont:[UIFont systemFontOfSize:16.0f]];
  [adventureStartedTimeLabel setTextAlignment:UITextAlignmentRight];
  [adventureStartedTimeValue setTextAlignment:UITextAlignmentLeft];
  [adventureStartedTimeLabel setText:@"Adventure Started: "];
  [adventureStartedTimeValue setText:@"2012-01-22"];
  [dataView addSubview:adventureStartedTimeLabel];
  [dataView addSubview:adventureStartedTimeValue];
  [adventureStartedTimeLabel release];
  [adventureStartedTimeValue release];
  
  // Add Data View to |self.view| & Release it
  [self.view addSubview:dataView];
  [dataView release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Show Data
  NSArray * fetchedObjects = [Trainer queryAllData];
  NSLog(@"+++ %@", [[fetchedObjects lastObject] valueForKey:@"name"]);
  
//  // Get a handle to our fetchedResultsController (which implicitly creates it as well)
//  // and call |performFetch:| to retrieve the first batch of data
//  NSError *error;
//	if (! [[self fetchedResultsController] performFetch:&error]) {
//		// Update to handle the error appropriately.
//		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//		exit(-1);  // Fail
//	}
//  
//  // It can be put at |numberOfRowsInSection:| in TableView
//  id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController_ sections] objectAtIndex:0];
//  NSLog(@"~~~ %@", sectionInfo); //[sectionInfo numberOfObjects]);
//  
//  // It can be put at |cellForRowAtIndexPath:| in TableView
//  NSLog(@"~~~ %@", [fetchedResultsController_ objectAtIndexPath:0]);
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.fetchedResultsController.delegate = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
  if (fetchedResultsController_ != nil) {
    return fetchedResultsController_;
  }
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSManagedObjectContext * context = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
  NSEntityDescription *entity = [NSEntityDescription 
                                 entityForName:@"Trainer" inManagedObjectContext:context];
  [fetchRequest setEntity:entity];
  
  // Set Sort Descriptors
  NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                            initWithKey:@"trainerID" ascending:NO];
  [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
  
  // Set Batch Size
  // The fetched results controller will only retrieve a subset of objects at a time from the underlying database,
  // and automatically fetch mroe as we scroll
  [fetchRequest setFetchBatchSize:20];
  
  // Create the |NSFetchedRequestController| instance
  NSFetchedResultsController *theFetchedResultsController = 
  [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                      managedObjectContext:context
                                        sectionNameKeyPath:nil       // sort the data into sections in table view
                                                 cacheName:@"Root"]; // the name of the file the fetched results controller should use to cache any repeat work such as setting up sections and ordering contents
  self.fetchedResultsController = theFetchedResultsController;
  fetchedResultsController_.delegate = self;
  
  [sort release];
  [fetchRequest release];
  [theFetchedResultsController release];
  
  return fetchedResultsController_;  
}


/*/ NSFetchedResultsControllerDelegate for TableView
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
  [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
  
  UITableView *tableView = self.tableView;
  
  switch(type) {
      
    case NSFetchedResultsChangeInsert:
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeUpdate:
      [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
      break;
      
    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:[NSArray
                                         arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:[NSArray
                                         arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
  
  switch(type) {
      
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
  [self.tableView endUpdates];
}*/

@end
