//
//  NewTrainerGuideViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 4/3/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "NewbieGuideViewController.h"

#import "GlobalConstants.h"
#import "GlobalRender.h"
#import "GlobalNotificationConstants.h"
#import "ServerAPIClient.h"
#import "TrainerController.h"
#import "PokemonSelectionViewController.h"


@interface NewbieGuideViewController () {
 @private
  ServerAPIClient   * serverAPIClient_;
  TrainerController * trainer_;
  
  UIView   * backgroundView_;
  UILabel  * textView1_;
  UILabel  * textView2_;
  CGRect     textView1Frame_;
  CGRect     textView2Frame_;
  UIButton * confirmButton_;
  
  BOOL          isProcessing_;
  NSInteger     guideStep_;
  UITextField * nameInputView_;
  PokemonSelectionViewController * pokemonSelectionViewController_;
}

@property (nonatomic, retain) ServerAPIClient   * serverAPIClient;
@property (nonatomic, retain) TrainerController * trainer;

@property (nonatomic, retain) UIView   * backgroundView;
@property (nonatomic, retain) UILabel  * textView1;
@property (nonatomic, retain) UILabel  * textView2;
@property (nonatomic, assign) CGRect     textView1Frame;
@property (nonatomic, assign) CGRect     textView2Frame;
@property (nonatomic, retain) UIButton * confirmButton;

@property (nonatomic, assign) BOOL          isProcessing;
@property (nonatomic, assign) NSInteger     guideStep;
@property (nonatomic, retain) UITextField * nameInputView;
@property (nonatomic, retain) PokemonSelectionViewController * pokemonSelectionViewController;

- (void)unloadViewAnimated:(BOOL)animated;
- (void)moveConfirmButtonToBottom:(BOOL)toBottom animated:(BOOL)animated;
- (void)showConfirmButton:(NSNotification *)notification;
- (void)hideConfirmButton:(NSNotification *)notification;
- (void)confirm:(id)sender;
- (void)setTextViewWithText1:(NSString *)text1 text2:(NSString *)text2;

@end


@implementation NewbieGuideViewController

@synthesize serverAPIClient = serverAPIClient_;
@synthesize trainer         = trainer_;

@synthesize backgroundView  = backgroundView_;
@synthesize textView1       = textView1_;
@synthesize textView2       = textView2_;
@synthesize textView1Frame  = textView1Frame_;
@synthesize textView2Frame  = textView2Frame_;
@synthesize confirmButton   = confirmButton_;

@synthesize isProcessing           = isProcessing_;
@synthesize guideStep              = guideStep_;
@synthesize nameInputView          = nameInputView_;
@synthesize pokemonSelectionViewController = pokemonSelectionViewController_;

- (void)dealloc
{
  self.serverAPIClient = nil;
  self.trainer         = nil;
  
  [backgroundView_ release];
  [textView1_      release];
  [textView2_      release];
  [confirmButton_  release];
  
  nameInputView_.delegate = nil;
  [nameInputView_                  release];
  [pokemonSelectionViewController_ release];
  
  // Remove notification observer
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kPMNShowConfirmButtonInNebbieGuide
                                                object:self.pokemonSelectionViewController];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kPMNHideConfirmButtonInNebbieGuide
                                                object:self.pokemonSelectionViewController];
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.serverAPIClient = [ServerAPIClient sharedInstance];
    self.trainer         = [TrainerController sharedInstance];
    self.isProcessing    = NO;
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
  self.view = view;
  [view release];
  [self.view setAlpha:0.f];

  backgroundView_ = [[UIView alloc] initWithFrame:self.view.frame];
  [backgroundView_ setBackgroundColor:[UIColor blackColor]];
  [backgroundView_ setAlpha:.85f];
  [self.view addSubview:backgroundView_];
  
  // Constants
  textView1Frame_ = CGRectMake(30.f, 60.f, 260.f, 40.f);
  textView2Frame_ = CGRectMake(30.f, 100.f, 260.f, 40.f);
  
  textView1_ = [[UILabel alloc] initWithFrame:textView1Frame_];
  [textView1_ setBackgroundColor:[UIColor clearColor]];
  [textView1_ setTextColor:[GlobalRender textColorTitleWhite]];
  [textView1_ setFont:[GlobalRender textFontNormalInSizeOf:18.f]];
  [textView1_ setLineBreakMode:UILineBreakModeWordWrap];
  [textView1_ setNumberOfLines:0];
  [self.view addSubview:textView1_];
  
  textView2_ = [[UILabel alloc] initWithFrame:textView2Frame_];
  [textView2_ setBackgroundColor:[UIColor clearColor]];
  [textView2_ setTextColor:[GlobalRender textColorTitleWhite]];
  [textView2_ setFont:[GlobalRender textFontNormalInSizeOf:18.f]];
  [textView2_ setLineBreakMode:UILineBreakModeWordWrap];
  [textView2_ setNumberOfLines:0];
  [self.view addSubview:textView2_];
  
  confirmButton_ = [[UIButton alloc] init];
  [confirmButton_ setImage:[UIImage imageNamed:@"MainViewMapButtonImageNormal.png"] forState:UIControlStateNormal];
  [confirmButton_ addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:confirmButton_];
  [self moveConfirmButtonToBottom:YES animated:NO];
  
  // Layouts for different steps
  // Constants
  CGRect nameInputViewFrame = CGRectMake(30.f, (kViewHeight - 32.f) / 2.f, 260.f, 32.f);
  
  // Name setting input view
  nameInputView_ = [[UITextField alloc] initWithFrame:nameInputViewFrame];
  [nameInputView_ setBackgroundColor:[UIColor whiteColor]];
  [nameInputView_ setTextColor:[UIColor blackColor]];
  [nameInputView_ setFont:[GlobalRender textFontBoldInSizeOf:16]];
  [nameInputView_ setKeyboardType:UIKeyboardTypeDefault];
  nameInputView_.delegate = self;
  
  // Pokemon Selection view
  pokemonSelectionViewController_ = [[PokemonSelectionViewController alloc] init];
  NSArray * pokemonsUID = [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:4], [NSNumber numberWithInt:7], nil];
  [pokemonSelectionViewController_ initWithPokemonsWithUID:pokemonsUID];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self setTextViewWithText1:@"PMSNewbiewGuide1Text1" text2:@"PMSNewbiewGuide1Text2"];
  [self.nameInputView setText:[self.trainer name]]; // Default name
  [self.view addSubview:self.nameInputView];
  self.guideStep = 1;
  
  // Add observer for notification from |PokemonSelectionViewController|
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(showConfirmButton:)
                                               name:kPMNShowConfirmButtonInNebbieGuide
                                             object:self.pokemonSelectionViewController];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(hideConfirmButton:)
                                               name:kPMNHideConfirmButtonInNebbieGuide
                                             object:self.pokemonSelectionViewController];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.backgroundView = nil;
  self.textView1      = nil;
  self.textView2      = nil;
  self.confirmButton  = nil;
  
  self.nameInputView                  = nil;
  self.pokemonSelectionViewController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

// Load view
-(void)loadViewAnimated:(BOOL)animated {
  void (^animations)() = ^(){[self.view setAlpha:1.f];};
  if (animated) [UIView animateWithDuration:.3f
                                      delay:0.f
                                    options:UIViewAnimationOptionCurveEaseIn
                                 animations:animations
                                 completion:nil];
  else animations();
}

#pragma mark - Private Methods

// Unload view
- (void)unloadViewAnimated:(BOOL)animated {
  void (^animations)() = ^(){[self.view setAlpha:0.f];};
  void (^completion)(BOOL) = ^(BOOL finished){[self.view removeFromSuperview];};
  if (animated) [UIView animateWithDuration:.3f
                                      delay:0.f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:animations
                                 completion:completion];
  else {animations(); completion(YES);}
}

// Move |confirmButton_|
- (void)moveConfirmButtonToBottom:(BOOL)toBottom animated:(BOOL)animated {
  CGRect confirmButtonFrame =
    CGRectMake((kViewWidth - kCenterMainButtonSize) / 2,
               toBottom ? kViewHeight - 100.f : (kViewHeight - kCenterMainButtonSize) / 2,
               kCenterMainButtonSize,
               kCenterMainButtonSize);
  void (^animations)() = ^(){[self.confirmButton setFrame:confirmButtonFrame];};
  if (animated) [UIView animateWithDuration:.3f
                                      delay:0.f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:animations
                                 completion:nil];
  else animations();
}

// Show |confirmButton_|
- (void)showConfirmButton:(NSNotification *)notification {
  [self moveConfirmButtonToBottom:YES animated:YES];
}

// Hide |confirmButton_|
- (void)hideConfirmButton:(NSNotification *)notification {
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     CGRect confirmButtonFrame = self.confirmButton.frame;
                     confirmButtonFrame.origin.y = kViewHeight;
                     [self.confirmButton setFrame:confirmButtonFrame];
                   }
                   completion:nil];
}

// Action for |confirmButton_|
- (void)confirm:(id)sender {
  // If is processing, do nothing until processing done
  if (self.isProcessing) return;
  
  switch (self.guideStep) {
    case 1: {
      NSString * name = self.nameInputView.text;
      NSLog(@"New Name:%@", name);
      if (! [name isEqualToString:[self.trainer name]]) {
        // Block: |success| & |failure|
        void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
          // Response:-1:ERROR: 0:Name Exist 1:OK
          NSInteger uniqueness = [[responseObject valueForKey:@"u"] intValue];
          NSString * newText;
          NSLog(@"...|checkUniquenessForName| data success...response value of |uniqueness|:%d", uniqueness);
          if (uniqueness == 1) {
            [self.trainer setName:name];
            newText = @"PMSNewbiewGuide2Text1";
            ++guideStep_;
            [self.view insertSubview:self.pokemonSelectionViewController.view belowSubview:self.confirmButton];
            [self.pokemonSelectionViewController.view setAlpha:0.f];
          }
          else if (uniqueness == 0) newText = @"PMSNewbiewGuide1TextNameExist";
          else newText = @"PMSNewbiewGuide1TextNameERROR";
          
          void (^animations)() = ^() {
            if (uniqueness == 1) {
              [self.nameInputView                       setAlpha:0.f];
              [self.pokemonSelectionViewController.view setAlpha:1.f];
            }
            [self.textView1 setAlpha:0.f];
            [self.textView2 setAlpha:0.f];
          };
          void (^completion)(BOOL) = ^(BOOL finished) {
            [self setTextViewWithText1:newText text2:nil];
            if (uniqueness == 1) [self.nameInputView removeFromSuperview];
            [UIView animateWithDuration:.3f
                                  delay:0.f
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                               [self.textView1 setAlpha:1.f];
                               [self.textView2 setAlpha:1.f];
                             }
                             completion:nil];
          };
          [UIView animateWithDuration:.3f
                                delay:0.f
                              options:UIViewAnimationOptionCurveLinear
                           animations:animations
                           completion:completion];
          self.isProcessing = NO;
        };
        void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"!!! |checkUniquenessForName| data failed ERROR: %@", error);
        };
        
        [self.serverAPIClient checkUniquenessForName:name success:success failure:failure];
        self.isProcessing = YES;
      }
      break;
    }
      
    case 2: {
      [UIView animateWithDuration:.3f
                            delay:0.f
                          options:UIViewAnimationOptionCurveLinear
                       animations:^{
                         [self.textView1 setAlpha:0.f];
                         [self.textView2 setAlpha:0.f];
                         [self.pokemonSelectionViewController.view setAlpha:0.f];
                         [self moveConfirmButtonToBottom:NO animated:NO];
                       }
                       completion:^(BOOL finished) {
                         [self.pokemonSelectionViewController.view removeFromSuperview];
                         [self setTextViewWithText1:@"PMSNewbiewGuide3Text1" text2:nil];
                         [UIView animateWithDuration:.3f
                                               delay:0.f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                            [self.textView1 setAlpha:1.f];
                                            [self.textView2 setAlpha:1.f];
                                          }
                                          completion:nil];
                       }];
      ++guideStep_;
      break;
    }
      
    case 3:
      [self unloadViewAnimated:YES];
      break;
      
    default:
      break;
  }
}

// Set text for |textView1_| & |textView2_|
- (void)setTextViewWithText1:(NSString *)text1 text2:(NSString *)text2 {
  [self.textView1 setFrame:self.textView1Frame];
  [self.textView1 setText:NSLocalizedString(text1, nil)];
  [self.textView1 sizeToFit];
  
  [self.textView2 setFrame:self.textView2Frame];
  [self.textView2 setText:NSLocalizedString(text2, nil)];
  [self.textView2 sizeToFit];
}

#pragma mark - UITextView Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self.nameInputView resignFirstResponder];
  return YES;
}

@end
