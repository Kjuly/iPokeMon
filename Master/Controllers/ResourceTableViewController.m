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
//#import "LoadingManager.h"

#import "AFJSONRequestOperation.h"
#import "SSZipArchive.h"


// The resource bundle is big,
//   so download it from local server is a better idea
//   when you're do testing jobs for the development
// Default: OFF
//#define KY_DOWNLOAD_RESOURCE_FROM_LOCAL_SERVER 1

#ifdef KY_LOCAL_SERVER_ON
  NSString * const kResourceListURL = @"https://raw.github.com/Kjuly/iPokeMon-Resource/dev/RESOURCES";
#else
  NSString * const kResourceListURL = @"https://raw.github.com/Kjuly/iPokeMon-Resource/master/RESOURCES";
#endif

#define kResourceServerPackageAPI_   @"Bundles/"
#define kResourceServerThumbnailAPI_ @"Thumbnails/"


@interface ResourceTableViewController () {
 @private
  NSArray         * resources_;       // resources array
  ResourceManager * resourceManager_; // resource manager
//  LoadingManager  * loadingManager_;  // loading manager
  MBProgressHUD   * progressView_;
}

@property (nonatomic, copy)   NSArray         * resources;
@property (nonatomic, strong) ResourceManager * resourceManager;
//@property (nonatomic, retain) LoadingManager  * loadingManager;
@property (nonatomic, strong) MBProgressHUD   * progressView;

- (void)_loadResourceForRow:(NSInteger)row;

@end


@implementation ResourceTableViewController

@synthesize managedObjectContext;
@synthesize resources       = resources_;
@synthesize resourceManager = resourceManager_;
//@synthesize loadingManager  = loadingManager_;
@synthesize progressView    = progressView_;


- (id)initWithStyle:(UITableViewStyle)style
{
  if (self = [super initWithStyle:style]) {
    [self setTitle:NSLocalizedString(@"PMSSettingMoreResources", nil)];
    self.resourceManager = [ResourceManager sharedInstance];
//    self.loadingManager  = [LoadingManager sharedInstance];
    
    // Populate |resources_|
    void (^success)(NSURLRequest *, NSHTTPURLResponse *, id);
    void (^failure)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id);
    success = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
      //
      // {"resources":[
      //   {
      //     "id"   : "PokeMon",
      //     "name" : "PokeMon Package",
      //     "url"  : "http://localhost:8888/"
      //   },
      //   ...
      //   ]}
      self.resources = [JSON valueForKey:@"resources"];
      [self.tableView reloadData];
    };
    failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
      if (error) NSLog(@"!!!ERROR: %@, RESPONESE: %@, JSON: %@", [error description], response, JSON);
    };
    
    NSURL * url = [[NSURL alloc] initWithString:kResourceListURL];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    //
    // !!!TODO
    //   When network is not available, timeout not works!!!
    //
    [request setTimeoutInterval:10.f];
    AFJSONRequestOperation * operation =
      [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                      success:success
                                                      failure:failure];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/plain"]];
    [operation start];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [self.view setBackgroundColor:
    [UIColor colorWithPatternImage:[UIImage imageNamed:kPMINBackgroundBlack]]];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// Return the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

// Return the number of rows in the section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.resources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString * cellIdentifier = @"Cell";
  UITableViewCell * cell =
    [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil)
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:cellIdentifier];
  
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
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self _loadResourceForRow:indexPath.row];
}

#pragma mark - Private Method

// Load resource for the selected row
- (void)_loadResourceForRow:(NSInteger)row
{
  // Resource name
  NSString * resourceName = [[self.resources objectAtIndex:row] objectForKey:@"id"];
  // Resource package name
  NSString * resourcePackageName = [resourceName stringByAppendingString:@".bundle.zip"];
  // Request URL path tail: e.g. Bundle/PokeMon.zip
  NSString * pathComponent =
    [(NSString *)kResourceServerPackageAPI_ stringByAppendingString:resourcePackageName];
  // Path to the folder where the downloaded resource package will be unzipped
  NSString * pathToUnzip =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  // Path (with the package name) to save the downloaded resource package
  NSString * pathToSave =
    [pathToUnzip stringByAppendingPathComponent:resourcePackageName];
  
  // If the target file exists, do nothing
  if ([[NSFileManager defaultManager] fileExistsAtPath:pathToSave]) {
    NSLog(@"!!!Target .bundle.zip Already Exists"); return;
  }
  
  // Progress View
  UIWindow * window = self.view.window;
  self.progressView = [[MBProgressHUD alloc] initWithWindow:window];
  self.progressView.delegate = self;
  self.progressView.mode = MBProgressHUDModeAnnularDeterminate;
  self.progressView.labelText = NSLocalizedString(@"PMSSettingMoreLoadResourceDownloading", nil);
  self.progressView.progress = 0.f;
  [window addSubview:self.progressView];
  
  // Blocks for AFHTTPRequestOperation object
  void (^downloadProgress)(NSUInteger, long long, long long);
  void (^success)(AFHTTPRequestOperation *, id);
  void (^failure)(AFHTTPRequestOperation *, NSError *);
  
  // Download Progress Block
  downloadProgress = ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
    float progress = ((float)totalBytesRead) / totalBytesExpectedToRead;
    NSLog(@"Progress: %f => %u %llu %llu", progress, bytesRead, totalBytesRead, totalBytesExpectedToRead);
    self.progressView.progress = progress;
  };
  // Success Block
  success = ^(AFHTTPRequestOperation *operation, id response) {
    NSLog(@"RESOURCE in ZIP is successfully saved to disk");
    BOOL succeed = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
      self.progressView.mode = MBProgressHUDModeIndeterminate;
      self.progressView.labelText = NSLocalizedString(@"PMSSettingMoreLoadResourceUpdating", nil);

    });
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
      if ([OriginalDataManager updateDataWithMOC:self.managedObjectContext
                                  resourceBundle:self.resourceManager.bundle
                                          isInit:NO])
        succeed = YES;
      
      // Save resource bundle path to user defaults
      NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
      [userDefaults setValue:pathToResourceBundle forKey:kUDKeyResourceBundlePath];
      [userDefaults synchronize];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      // Hide loading indicator and show a succeed/faild message
      self.progressView.customView =
        [[UIImageView alloc] initWithImage:
          [UIImage imageNamed:(succeed ? kPMINMainButtonConfirm : kPMINMainButtonCancel)]];
      self.progressView.mode = MBProgressHUDModeCustomView;
      self.progressView.labelText = NSLocalizedString(@"PMSSettingMoreLoadResourceCompleted", nil);
      [self.progressView hide:YES afterDelay:1.f];
    });
  };
  // Failure Block
  failure = ^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"!!!ERROR: RESOURCE in ZIP CANNOT be saved to disk: %@", [error description]);
    dispatch_async(dispatch_get_main_queue(), ^{
      // Hide loading indicator and show a faild message
      self.progressView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kPMINMainButtonCancel]];
      self.progressView.mode = MBProgressHUDModeCustomView;
      self.progressView.labelText = NSLocalizedString(@"PMSSettingMoreLoadResourceFailed", nil);
      [self.progressView hide:YES afterDelay:1.f];
    });
  };
  
  // Root URL
  NSString * urlRoot;
#ifdef KY_DOWNLOAD_RESOURCE_FROM_LOCAL_SERVER
  urlRoot = @"http://localhost:8888/";
#else
  urlRoot = [[self.resources objectAtIndex:row] objectForKey:@"url"];
#endif
  // The final URL to get the resource package in .zip format
  NSURL * url = [NSURL URLWithString:[urlRoot stringByAppendingString:pathComponent]];
  // Setup request
  NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
  [request setHTTPMethod:@"GET"];
  // Setup operation
  AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  operation.outputStream = [NSOutputStream outputStreamToFileAtPath:pathToSave append:NO];
  [operation setCompletionBlockWithSuccess:success failure:failure];
  [operation setDownloadProgressBlock:downloadProgress];
  // Show loading indicator
  [self.progressView show:YES];
  // Start operation
  [operation start];
}

#pragma mark MBProgressHUDDelegate methods

// Remove HUD from screen when the HUD was hidded
- (void)hudWasHidden:(MBProgressHUD *)hud
{
	[hud removeFromSuperview];
	hud = nil;
}

@end
