//
//  StoreItemQuantityChangeViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 5/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "StoreItemQuantityChangeViewController.h"

#import "GlobalRender.h"


#define kStoreMaxItemQuantity 99
#define kStoreMinItemQuantity 1


@interface StoreItemQuantityChangeViewController () {
 @private
  UIView   * backgroundView_;
  UILabel  * itemQuantityLabel_;
  UIButton * increaseButton_; // increase quantity
  UIButton * decreaseButton_; // decrease ...
  UIButton * confirmButton_;  // confirm
  UIButton * cancelButton_;   // cancel
  
  NSInteger itemQuantity_;
}

@property (nonatomic, strong) UIView   * backgroundView;
@property (nonatomic, strong) UILabel  * itemQuantityLabel;
@property (nonatomic, strong) UIButton * increaseButton;
@property (nonatomic, strong) UIButton * decreaseButton;
@property (nonatomic, strong) UIButton * confirmButton;
@property (nonatomic, strong) UIButton * cancelButton;

- (void)_unloadViewAnimated:(BOOL)animated;
- (void)_increase:(id)sender;
- (void)_decrease:(id)sender;
- (void)_confirm:(id)sender;
- (void)_cancel:(id)sender;
- (void)_updateItemQuantity:(NSInteger)quantity;

@end

@implementation StoreItemQuantityChangeViewController

@synthesize backgroundView    = backgroundView_;
@synthesize itemQuantityLabel = itemQuantityLabel_;
@synthesize increaseButton    = increaseButton_;
@synthesize decreaseButton    = decreaseButton_;
@synthesize confirmButton     = confirmButton_;
@synthesize cancelButton      = cancelButton_;

- (id)init
{
  return (self = [super init]);
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
  UIView * view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, {kViewWidth, 480.f}}];
  self.view = view;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  itemQuantity_ = 1;
  
  backgroundView_ = [[UIView alloc] initWithFrame:self.view.frame];
  [backgroundView_ setBackgroundColor:[UIColor blackColor]];
  [self.view addSubview:backgroundView_];
  
  // subviews
  // constants
  CGRect itemQuantityLabelFrame = CGRectMake(0.f, (self.view.frame.size.height - kCellHeightOfStoreItemTableView) / 2.f, kViewWidth, kCellHeightOfStoreItemTableView);
  CGRect increaseButtonFrame = CGRectMake((kViewWidth - kStoreItemQuantityI_DcreaseButtonWidth) / 2.f,
                                          itemQuantityLabelFrame.origin.y - kStoreItemQuantityI_DcreaseButtonHeight,
                                          kStoreItemQuantityI_DcreaseButtonWidth,
                                          kStoreItemQuantityI_DcreaseButtonHeight);
  CGRect decreaseButtonFrame = increaseButtonFrame;
  decreaseButtonFrame.origin.y = itemQuantityLabelFrame.origin.y + itemQuantityLabelFrame.size.height;
  CGRect confirmButtonFrame = CGRectMake((kViewWidth - kCenterMainButtonSize) / 2.f,
                                         self.view.frame.size.height - 120.f, kCenterMainButtonSize, kCenterMainButtonSize);
  CGRect cancelButtonFrame  = confirmButtonFrame;
  cancelButtonFrame.origin.y = 60.f;
  
  // item quantity label
  itemQuantityLabel_ = [[UILabel alloc] initWithFrame:itemQuantityLabelFrame];
  [itemQuantityLabel_ setBackgroundColor:[UIColor clearColor]];
  [itemQuantityLabel_ setTextAlignment:NSTextAlignmentCenter];
  [itemQuantityLabel_ setTextColor:[GlobalRender textColorOrange]];
  [itemQuantityLabel_ setFont:[GlobalRender textFontBoldInSizeOf:36.f]];
  [self.view addSubview:itemQuantityLabel_];
  [self _updateItemQuantity:itemQuantity_];
  
  // increase & decrease buttons
  increaseButton_ = [[UIButton alloc] initWithFrame:increaseButtonFrame];
  [increaseButton_ setImage:[UIImage imageNamed:kPMINStoreItemQuantityIcreaseButton]
                   forState:UIControlStateNormal];
  [increaseButton_ addTarget:self action:@selector(_increase:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:increaseButton_];
  decreaseButton_ = [[UIButton alloc] initWithFrame:decreaseButtonFrame];
  [decreaseButton_ setImage:[UIImage imageNamed:kPMINStoreItemQuantityDcreaseButton]
                   forState:UIControlStateNormal];
  [decreaseButton_ addTarget:self action:@selector(_decrease:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:decreaseButton_];
  
  // confirm button
  confirmButton_ = [[UIButton alloc] initWithFrame:confirmButtonFrame];
  [confirmButton_ setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal]
                            forState:UIControlStateNormal];
  [confirmButton_ setImage:[UIImage imageNamed:kPMINMainButtonConfirm]
                  forState:UIControlStateNormal];
  [confirmButton_ addTarget:self action:@selector(_confirm:)
           forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:confirmButton_];
  
  // cancel button
  cancelButton_ = [[UIButton alloc] initWithFrame:cancelButtonFrame];
  [cancelButton_ setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal]
                           forState:UIControlStateNormal];
  [cancelButton_ setImage:[UIImage imageNamed:kPMINMainButtonCancel]
                 forState:UIControlStateNormal];
  [cancelButton_ addTarget:self action:@selector(_cancel:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:cancelButton_];
   
  [backgroundView_    setAlpha:0.f];
  [itemQuantityLabel_ setAlpha:0.f];
  [increaseButton_    setAlpha:0.f];
  [decreaseButton_    setAlpha:0.f];
  [confirmButton_     setAlpha:0.f];
  [cancelButton_      setAlpha:0.f];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.backgroundView    = nil;
  self.itemQuantityLabel = nil;
  self.increaseButton    = nil;
  self.decreaseButton    = nil;
  self.confirmButton     = nil;
  self.cancelButton      = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

- (void)loadViewWithItemQuantity:(NSInteger)itemQuantity
                        animated:(BOOL)animated
{
  [self _updateItemQuantity:itemQuantity];
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     [self.backgroundView    setAlpha:.9f];
                     [self.itemQuantityLabel setAlpha:1.f];
                     [self.increaseButton    setAlpha:1.f];
                     [self.decreaseButton    setAlpha:1.f];
                     [self.confirmButton     setAlpha:1.f];
                     [self.cancelButton      setAlpha:1.f];
                   }
                   completion:nil];
}

#pragma mark - Private Methods

- (void)_unloadViewAnimated:(BOOL)animated
{
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     [self.view setAlpha:0.f];
                   }
                   completion:^(BOOL finished) {
                     [self.view removeFromSuperview];
                     [self.view setAlpha:1.f];
                     [self.backgroundView    setAlpha:0.f];
                     [self.itemQuantityLabel setAlpha:0.f];
                     [self.increaseButton    setAlpha:0.f];
                     [self.decreaseButton    setAlpha:0.f];
                     [self.confirmButton     setAlpha:0.f];
                     [self.cancelButton      setAlpha:0.f];
                   }];
}

// increase item quantity
- (void)_increase:(id)sender
{
  [self _updateItemQuantity:++itemQuantity_];
}

// decrease item quantity
- (void)_decrease:(id)sender
{
  [self _updateItemQuantity:--itemQuantity_];
}

// confirm
- (void)_confirm:(id)sender
{
  // post notification to |StoreItemTableViewController| to update item quantity
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUpdateStoreItemQuantity
                                                      object:[NSNumber numberWithInt:itemQuantity_]];
  [self _unloadViewAnimated:YES];
}

// cancel
- (void)_cancel:(id)sender
{
  [self _unloadViewAnimated:YES];
}

// update item quantity
- (void)_updateItemQuantity:(NSInteger)quantity
{
  if (quantity < kStoreMinItemQuantity) quantity = kStoreMinItemQuantity;
  if (quantity > kStoreMaxItemQuantity) quantity = kStoreMaxItemQuantity;
  itemQuantity_ = quantity;
  [self.itemQuantityLabel setText:[NSString stringWithFormat:@"%d", quantity]];
}

@end
