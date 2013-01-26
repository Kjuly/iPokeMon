//
//  ResourceTableViewController.m
//  iPokeMon
//
//  Created by Kjuly on 1/25/13.
//  Copyright (c) 2013 Kjuly. All rights reserved.
//

#import "ResourceTableViewController.h"

#import "ResourceManager.h"
#import "OriginalDataManager.h"
#import "LoadingManager.h"

#import "AFJSONRequestOperation.h"
#import "SSZipArchive.h"

#ifdef KY_LOCAL_SERVER_ON
  NSString * const kResourceBaseURL = @"http://localhost:8888/";
#else
  NSString * const kResourceBaseURL = @"http://184.169.146.32:8888/";
#endif

#define kResourceServerPackageAPI   @"package/"
#define kResourceServerThumbnailAPI @"thumbnail/"


@interface ResourceTableViewController () {
 @private
  NSArray         * resources_;      // resources array
  ResourceManager * resourceManager_;
  LoadingManager  * loadingManager_; // loading manager
}

@property (nonatomic, copy)   NSArray         * resources;
@property (nonatomic, retain) ResourceManager * resourceManager;
@property (nonatomic, retain) LoadingManager  * loadingManager;

- (void)_loadResourceForRow:(NSInteger)row;

@end


@implementation ResourceTableViewController

@synthesize resources       = resources_;
@synthesize resourceManager = resourceManager_;
@synthesize loadingManager  = loadingManager_;

- (void)dealloc {
  self.resources       = nil;
  self.resourceManager = nil;
  self.loadingManager  = nil;
  [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    [self setTitle:NSLocalizedString(@"PMSSettingMoreResources", nil)];
    // Populate |resources_|
    self.resources = @[@{@"name" : @"PokeMon Package", @"id" : @"PokeMon"}];
    self.resourceManager = [ResourceManager sharedInstance];
    self.loadingManager  = [LoadingManager sharedInstance];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINBackgroundBlack]]];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// Return the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

// Return the number of rows in the section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.resources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString * cellIdentifier = @"Cell";
  UITableViewCell * cell =
    [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil)
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:cellIdentifier] autorelease];
  
  // Configure the cell...
  [cell.textLabel setTextColor:[UIColor whiteColor]];
  [cell.textLabel setText:[[self.resources objectAtIndex:indexPath.row] objectForKey:@"name"]];
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
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self _loadResourceForRow:indexPath.row];
}

#pragma mark - Private Method

// Load resource for the selected row
- (void)_loadResourceForRow:(NSInteger)row {
  // Resource name
  NSString * resourceName = [[self.resources objectAtIndex:row] objectForKey:@"id"];
  // Resource package name
  NSString * resourcePackageName = [resourceName stringByAppendingString:@".bundle.zip"];
  // Request URL path tail: e.g. package/PokeMon.zip
  NSString * pathComponent =
    [(NSString *)kResourceServerPackageAPI stringByAppendingString:resourcePackageName];
  // Path to the folder where the downloaded resource package will be unzipped
  NSString * pathToUnzip =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  // Path (with the package name) to save the downloaded resource package
  NSString * pathToSave =
    [pathToUnzip stringByAppendingPathComponent:resourcePackageName];
  
  // Blocks for AFHTTPRequestOperation object
  void (^success)(AFHTTPRequestOperation *, id);
  void (^failure)(AFHTTPRequestOperation *, NSError *);
  success = ^(AFHTTPRequestOperation *operation, id response) {
    NSLog(@"RESOURCE in ZIP is successfully saved to disk");
    BOOL succeed = NO;
    // Unzip resource package
    //
    // TODO:
    //   Rm .zip file after unzipped successfully
    //
    // Unzip succeed
    if ([SSZipArchive unzipFileAtPath:pathToSave toDestination:pathToUnzip]) {
      NSLog(@"RESOURCE is UNZIPPed successfully to \"%@\"", pathToUnzip);
      // Update original data with the unzipped resource bundle
      NSString * pathToResourceBundle =
        [pathToSave substringToIndex:(pathToSave.length - @".zip".length)];
      self.resourceManager.bundle = [NSBundle bundleWithPath:pathToResourceBundle];
      if ([OriginalDataManager updateDataWithResourceBundle:self.resourceManager.bundle])
        succeed = YES;
      
      // Save resource bundle path to user defaults
      NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
      [userDefaults setValue:pathToResourceBundle forKey:kUDKeyResourceBundlePath];
      [userDefaults synchronize];
    }
    // Hide loading indicator and show a succeed/faild message
    [self.loadingManager hideOverView];
    [self.loadingManager showMessage:nil
                                type:(succeed ? kProgressMessageTypeSucceed : kProgressMessageTypeError)
                        withDuration:2.f];
  };
  failure = ^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"!!!ERROR: RESOURCE in ZIP CANNOT be saved to disk: %@", [error description]);
    // Hide loading indicator and show a faild message
    [self.loadingManager hideOverView];
    [self.loadingManager showMessage:nil
                                type:kProgressMessageTypeError
                        withDuration:2.f];
  };
  
  // The final URL to get the resource package in .zip format
  NSURL * url = [NSURL URLWithString:[kResourceBaseURL stringByAppendingString:pathComponent]];
  // Setup request
  NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
  [request setHTTPMethod:@"GET"];
  NSLog(@"Request URL:%@, HTTP Header:%@", @"", [request allHTTPHeaderFields]);
  // Setup operation
  AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  operation.outputStream = [NSOutputStream outputStreamToFileAtPath:pathToSave append:NO];
  [operation setCompletionBlockWithSuccess:success failure:failure];
  // Show loading indicator
  [self.loadingManager showOverView];
  // Start operation
  [operation start];
}

@end
