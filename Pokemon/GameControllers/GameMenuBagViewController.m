//
//  GameMenuBagViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuBagViewController.h"

#import "GlobalConstants.h"
#import "GlobalRender.h"
#import "GlobalNotificationConstants.h"
#import "BagItemTableViewController.h"


@interface GameMenuBagViewController () {
 @private
  UIButton * cancelButton_;
}

@property (nonatomic, retain) UIButton * cancelButton;

- (void)loadSelcetedItemTalbeView:(id)sender;

@end


@implementation GameMenuBagViewController

@synthesize cancelButton              = cancelButton_;
@synthesize isSelectedItemViewOpening = isSelectedItemViewOpening_;

- (void)dealloc {
  [cancelButton_ release]; 
  
  [super dealloc];
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
  
  // Base Setting
  isSelectedItemViewOpening_ = NO;
  
  for (int i = 0; i < 4;) {
    CGRect buttonFrame = CGRectMake(10.f, 20.f + 45 * i, 280.f, 45.f);
    UIButton * button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button setTitleColor:[GlobalRender textColorTitleWhite] forState:UIControlStateNormal];
    [button setTag:++i];
    [button setTitle:NSLocalizedString(([NSString stringWithFormat:@"PMSGameMenuBagItem%d", i]), nil)
            forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loadSelcetedItemTalbeView:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableAreaView addSubview:button];
    [button release];
  }
  
  // Create a fake |mapButton_| as the cancel button
  UIButton * cancelButton = [[UIButton alloc] initWithFrame:CGRectMake((320.0f - kMapButtonSize) / 2,
                                                                       - kMapButtonSize,
                                                                       kMapButtonSize,
                                                                       kMapButtonSize)];
  self.cancelButton = cancelButton;
  [cancelButton release];
  [self.cancelButton setContentMode:UIViewContentModeScaleAspectFit];
  [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"MainViewMapButtonBackground.png"]
                               forState:UIControlStateNormal];
  [self.cancelButton setImage:[UIImage imageNamed:@"MainViewMapButtonImageHalfCancel.png"] forState:UIControlStateNormal];
  [self.cancelButton setOpaque:NO];
  [self.cancelButton addTarget:self
                        action:@selector(unloadSelcetedItemTalbeView:)
              forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.cancelButton];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.cancelButton = nil;
}

#pragma mark - Public Methods

- (void)unloadSelcetedItemTalbeView:(id)sender
{
  UIView * bagItemTableView = [self.view viewWithTag:999];
  [UIView animateWithDuration:0.3f
                        delay:0.0f
                      options:UIViewAnimationOptionTransitionCurlUp
                   animations:^{
                     [bagItemTableView setFrame:CGRectMake(0.0f, 480.0f, 320.0f, 480.0f)];
                     [self.cancelButton setFrame:CGRectMake((320.0f - kMapButtonSize) / 2,
                                                            - kMapButtonSize,
                                                            kMapButtonSize,
                                                            kMapButtonSize)];
                   }
                   completion:^(BOOL finished) {[bagItemTableView removeFromSuperview];}];
  bagItemTableView = nil;
  self.isSelectedItemViewOpening = NO;
}

#pragma mark - Private Methods

- (void)loadSelcetedItemTalbeView:(id)sender
{
  NSInteger itemTag = ((UIButton *)sender).tag;
  
  BagItemTableViewController * bagItemTableViewController = [[BagItemTableViewController alloc] initWithBagItem:itemTag];
  [bagItemTableViewController.view setTag:999];
  __block CGRect bagItemTableViewFrame = CGRectMake(0.f, kViewHeight, kViewWidth, kViewHeight);
  [bagItemTableViewController.view setFrame:bagItemTableViewFrame];
  [self.view insertSubview:bagItemTableViewController.view belowSubview:self.cancelButton];
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionTransitionCurlUp
                   animations:^{
                     bagItemTableViewFrame.origin.y = 0.f;
                     [bagItemTableViewController.view setFrame:bagItemTableViewFrame];
                     [self.cancelButton setFrame:CGRectMake((kViewWidth - kMapButtonSize) / 2,
                                                            - (kMapButtonSize / 2),
                                                            kMapButtonSize,
                                                            kMapButtonSize)];
                   }
                   completion:nil];
  [bagItemTableViewController release];
  self.isSelectedItemViewOpening = YES;
}

@end
