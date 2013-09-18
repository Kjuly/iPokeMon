//
//  GameMenuBagViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuBagViewController.h"

#import "GlobalRender.h"
#import "GameStatusMachine.h"
#import "GameSystemProcess.h"
#import "BagItemTableViewController.h"


@interface GameMenuBagViewController () {
 @private
  UIButton * cancelButton_;
  UISwipeGestureRecognizer   * swipeRightGestureRecognizer_;
  BagItemTableViewController * bagItemTableViewController_;
}

@property (nonatomic, strong) UIButton * cancelButton;
@property (nonatomic, strong) UISwipeGestureRecognizer   * swipeRightGestureRecognizer;
@property (nonatomic, strong) BagItemTableViewController * bagItemTableViewController;

- (void)_loadSelcetedItemTalbeView:(id)sender;
- (void)_toggleTopCancelButton:(NSNotification *)notification;
- (void)_endUsingBagItem:(NSNotification *)notification;

@end


@implementation GameMenuBagViewController

@synthesize isSelectedItemViewOpening = isSelectedItemViewOpening_;

@synthesize cancelButton                = cancelButton_;
@synthesize swipeRightGestureRecognizer = swipeRightGestureRecognizer_;
@synthesize bagItemTableViewController  = bagItemTableViewController_;

- (void)dealloc
{
  // Remove observer
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView {
//  [super loadView];
//}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Base Setting
  isSelectedItemViewOpening_ = NO;
  
  CGRect tableAreaViewFrame  = self.tableAreaView.frame;
  tableAreaViewFrame.origin.x = kViewWidth - tableAreaViewFrame.size.width;
  [self.tableAreaView setFrame:tableAreaViewFrame];
  
  CGFloat buttonSize = 64.f;
  CGFloat marginTop  = (kViewHeight - 20.f - 64.f * 6);
  for (int i = 0; i < 6;) {
    CGRect buttonFrame = CGRectMake(12.f, marginTop + buttonSize * i, buttonSize, buttonSize);
    UIButton * button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button setTag:++i];
    [button setBackgroundImage:[UIImage imageNamed:kPMINGameBagIconBackground]
                      forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:kPMINGameBagIcon, i]]
            forState:UIControlStateNormal];
    [button addTarget:self action:@selector(_loadSelcetedItemTalbeView:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.tableAreaView addSubview:button];
  }
  
  // Create a fake |mapButton_| as the cancel button
  UIButton * cancelButton =
    [[UIButton alloc] initWithFrame:CGRectMake((kViewWidth - kMapButtonSize) / 2,
                                               - kMapButtonSize,
                                               kMapButtonSize,
                                               kMapButtonSize)];
  self.cancelButton = cancelButton;
  [self.cancelButton setContentMode:UIViewContentModeScaleAspectFit];
  [self.cancelButton setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal]
                               forState:UIControlStateNormal];
  [self.cancelButton setImage:[UIImage imageNamed:kPMINMapButtonHalfCancel]
                     forState:UIControlStateNormal];
  [self.cancelButton setOpaque:NO];
  [self.cancelButton addTarget:self
                        action:@selector(unloadSelcetedItemTalbeView:)
              forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.cancelButton];
  
  
  // Swipte to RIGHT, close bag view
  UISwipeGestureRecognizer * swipeRightGestureRecognizer
  = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
  self.swipeRightGestureRecognizer = swipeRightGestureRecognizer;
  [self.swipeRightGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
  [self.view addGestureRecognizer:self.swipeRightGestureRecognizer];
  
  // Add observer for notification from |BagItemInfoViewController|
  NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
  [notificationCenter addObserver:self
                         selector:@selector(_toggleTopCancelButton:)
                             name:kPMNToggleTopCancelButton
                           object:nil];
  // Add observer for notification from |BagItemViewController|
  [notificationCenter addObserver:self
                         selector:@selector(_endUsingBagItem:)
                             name:kPMNUseBagItemDone
                           object:self.bagItemTableViewController];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.cancelButton = nil;
}

#pragma mark - Public Methods

- (void)unloadSelcetedItemTalbeView:(id)sender
{
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionTransitionCurlUp
                   animations:^{
                     [self.bagItemTableViewController.view setFrame:
                        CGRectMake(0.f, kViewHeight, kViewWidth, kViewHeight)];
                     [self.cancelButton setFrame:CGRectMake((kViewWidth - kMapButtonSize) / 2,
                                                            - kMapButtonSize,
                                                            kMapButtonSize,
                                                            kMapButtonSize)];
                   }
                   completion:^(BOOL finished) {
                     [self.bagItemTableViewController.view removeFromSuperview];
                     [self.bagItemTableViewController reset];
                   }];
  self.isSelectedItemViewOpening = NO;
}

#pragma mark - Private Methods

- (void)_loadSelcetedItemTalbeView:(id)sender
{
  BagQueryTargetType targetType;
  switch (((UIButton *)sender).tag) {
    case 1: targetType = kBagQueryTargetTypeMedicine | kBagQueryTargetTypeMedicineStatus; break;
    case 2: targetType = kBagQueryTargetTypeMedicine | kBagQueryTargetTypeMedicineHP;     break;
    case 3: targetType = kBagQueryTargetTypeMedicine | kBagQueryTargetTypeMedicinePP;     break;
    case 4: targetType = kBagQueryTargetTypeBerry;                                        break;
    case 5: targetType = kBagQueryTargetTypePokeball;                                     break;
    case 6: targetType = kBagQueryTargetTypeBattleItem;                                   break;
    default: targetType = 0; break;
  }
  
  if (self.bagItemTableViewController == nil) {
    BagItemTableViewController * bagItemTableViewController =
      [[BagItemTableViewController alloc] init];
    self.bagItemTableViewController = bagItemTableViewController;
    self.bagItemTableViewController.isDuringBattle = YES;
  }
  
  // Only if current |targetType| is not the same as new one, reset it & reload data for tableview
  if (self.bagItemTableViewController.targetType ^ targetType)
    [self.bagItemTableViewController setBagItem:targetType];
  
  CGRect bagItemTableViewFrame = CGRectMake(0.f, kViewHeight, kViewWidth, kViewHeight);
  [self.bagItemTableViewController.view setFrame:bagItemTableViewFrame];
  [self.view insertSubview:self.bagItemTableViewController.view
              belowSubview:self.cancelButton];
  bagItemTableViewFrame.origin.y = 0.f;
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionTransitionCurlUp
                   animations:^{
                     [self.bagItemTableViewController.view setFrame:bagItemTableViewFrame];
                     [self.cancelButton setFrame:CGRectMake((kViewWidth - kMapButtonSize) / 2,
                                                            - (kMapButtonSize / 2),
                                                            kMapButtonSize,
                                                            kMapButtonSize)];
                   }
                   completion:nil];
  self.isSelectedItemViewOpening = YES;
}

- (void)_toggleTopCancelButton:(NSNotification *)notification
{
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionTransitionCurlUp
                   animations:^{
                     CGRect cancelButtonFrame = self.cancelButton.frame;
                     cancelButtonFrame.origin.y = (cancelButtonFrame.origin.y == - kMapButtonSize)
                       ? -(kMapButtonSize / 2) : -kMapButtonSize;
                     [self.cancelButton setFrame:cancelButtonFrame];
                   }
                   completion:nil];
}

- (void)_endUsingBagItem:(NSNotification *)notification
{
  // Set data for Game System Process & start it
  NSInteger selectedItemID =
    [[self.bagItemTableViewController.items objectAtIndex:
        (self.bagItemTableViewController.selectedCellIndex * 2)] intValue];
  GameSystemProcess * gameSystemProcess = [GameSystemProcess sharedInstance];
  [gameSystemProcess setSystemProcessOfUseBagItemWithUser:kGameSystemProcessUserPlayer
                                               targetType:self.bagItemTableViewController.targetType
                                     selectedPokemonIndex:self.bagItemTableViewController.selectedPokemonIndex
                                                itemIndex:selectedItemID];
  [[GameStatusMachine sharedInstance] endStatus:kGameStatusPlayerTurn];
  
  // Unload bag menu
  [UIView animateWithDuration:.6f
                        delay:0.f
                      options:(UIViewAnimationOptions)UIViewAnimationCurveLinear
                   animations:^{ [self.view setAlpha:0.f]; }
                   completion:^(BOOL finished) {
                     [self unloadViewWithAnimationToLeft:NO animated:NO];
                     [self unloadSelcetedItemTalbeView:nil];
                     [self.view setAlpha:1.f];
                   }];
}

@end
