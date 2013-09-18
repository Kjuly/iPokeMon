//
//  HelpViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 4/3/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController () {
 @private
  UIButton      * cancelButton_;
  UIScrollView  * scrollView_;
  UIPageControl * pageControl_;
}

@property (nonatomic, strong) UIButton      * cancelButton;
@property (nonatomic, strong) UIScrollView  * scrollView;
@property (nonatomic, strong) UIPageControl * pageControl;

- (void)_changePage:(id)sender;
- (void)_unloadViewAnimated:(BOOL)animated;

@end

@implementation HelpViewController

@synthesize cancelButton = cancelButton_;
@synthesize scrollView   = scrollView_;
@synthesize pageControl  = pageControl_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
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
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
  [view setBackgroundColor:[UIColor blackColor]];
  [view setAlpha:0.f];
  
  // |scrollView_|
  scrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kViewWidth, kViewHeight)];
  [scrollView_ setBounds:CGRectMake(0.0f, 0.0f, kViewWidth, kViewHeight)];
  [scrollView_ setFrame:CGRectMake(0.0f, 0.0f, kViewWidth, kViewHeight)];
  [scrollView_ setBackgroundColor:[UIColor clearColor]];
  [scrollView_ setShowsHorizontalScrollIndicator:NO];
  [scrollView_ setShowsVerticalScrollIndicator:NO];
  [scrollView_ setAutoresizesSubviews:NO];
  [scrollView_ setDelegate:self];
  [scrollView_ setContentMode:UIViewContentModeTop];
  [scrollView_ setPagingEnabled:YES];
  [view addSubview:scrollView_];
  
  ///Add subviews
  CGRect viewFrame = CGRectMake(0.f, 0.f, kViewWidth, kViewHeight);
  UIView * viewFirst = [[UIView alloc] initWithFrame:viewFrame];
  [viewFirst setBackgroundColor:[UIColor grayColor]];
  [scrollView_ addSubview:viewFirst];
  
  viewFrame.origin.x += kViewWidth;
  UIView * viewSecond = [[UIView alloc] initWithFrame:viewFrame];
  [viewSecond setBackgroundColor:[UIColor blueColor]];
  [scrollView_ addSubview:viewSecond];
  
  viewFrame.origin.x += kViewWidth;
  UIView * viewThird = [[UIView alloc] initWithFrame:viewFrame];
  [viewThird setBackgroundColor:[UIColor whiteColor]];
  [scrollView_ addSubview:viewThird];
  
  // Set |contentSize| for |scrollview_|
  self.scrollView.contentSize = CGSizeMake(kViewWidth * 3, kViewHeight);
  
  // setup page control
  pageControl_ = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, kViewHeight - 50.0f, kViewWidth, 20.0f)];
  [pageControl_ setNumberOfPages:3];
  [pageControl_ setCurrentPage:0];
  [pageControl_ addTarget:self action:@selector(_changePage:) forControlEvents:UIControlEventValueChanged];
  [view addSubview:pageControl_];
  
  // Create a fake |mapButton_| as the cancel button
  cancelButton_ = [[UIButton alloc] initWithFrame:CGRectMake((kViewWidth - kMapButtonSize) / 2,
                                                             - kMapButtonSize,
                                                             kMapButtonSize,
                                                             kMapButtonSize)];
  [cancelButton_ setContentMode:UIViewContentModeScaleAspectFit];
  [cancelButton_ setBackgroundImage:[UIImage imageNamed:kPMINBackgroundBlack]
                           forState:UIControlStateNormal];
  [cancelButton_ setImage:[UIImage imageNamed:kPMINMapButtonHalfCancel] forState:UIControlStateNormal];
  [cancelButton_ setOpaque:NO];
  [cancelButton_ addTarget:self action:@selector(_unloadViewAnimated:) forControlEvents:UIControlEventTouchUpInside];
  [view addSubview:cancelButton_];
  
  self.view = view;
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
  self.scrollView   = nil;
  self.pageControl  = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
  // Update the page number
  CGFloat pageWidth = self.scrollView.frame.size.width;
  self.pageControl.currentPage = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

#pragma mark - Public Methods

- (void)loadViewAnimated:(BOOL)animated
{
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:(UIViewAnimationOptions)UIViewAnimationCurveEaseInOut
                   animations:^{
                     [self.view setAlpha:1.f];
                     CGRect cancelButtonFrame = self.cancelButton.frame;
                     cancelButtonFrame.origin.y = - (kMapButtonSize / 2.f);
                     [self.cancelButton setFrame:cancelButtonFrame];
                   }
                   completion:nil];
}

#pragma mark - Private Methods

// Change page vir |pageControl_|
- (void)_changePage:(id)sender
{
  // update the scroll view to the appropriate page
  CGRect frame;
  frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
  frame.origin.y = 0;
  frame.size     = self.scrollView.frame.size;
  [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (void)_unloadViewAnimated:(BOOL)animated
{
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:(UIViewAnimationOptions)UIViewAnimationCurveLinear
                   animations:^{
                     CGRect cancelButtonFrame = self.cancelButton.frame;
                     cancelButtonFrame.origin.y = - kMapButtonSize;
                     [self.cancelButton setFrame:cancelButtonFrame];
                     [self.view setAlpha:0.f];
                   }
                   completion:^(BOOL finished) {
                     [self.view removeFromSuperview];
                   }];
}

@end
