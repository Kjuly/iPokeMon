//
//  NewTrainerGuideViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 4/3/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "NewbieGuideViewController.h"

#import "GlobalRender.h"
#import "ServerAPIClient.h"
#import "TrainerController.h"
#import "PokemonSelectionViewController.h"


@interface NewbieGuideViewController () {
 @private
  UIView      * backgroundView_;
  UILabel     * title_;
  UILabel     * message_;
  UIButton    * confirmButton_;
  UITextField * nameInputView_;
  
  ServerAPIClient                * serverAPIClient_;
  TrainerController              * trainer_;
  PokemonSelectionViewController * pokemonSelectionViewController_;
  
  CGRect    titleFrame_;
  CGRect    messageFrame_;
  BOOL      isProcessing_;
  NSInteger guideStep_;
}

@property (nonatomic, strong) ServerAPIClient                * serverAPIClient;
@property (nonatomic, strong) TrainerController              * trainer;
@property (nonatomic, strong) PokemonSelectionViewController * pokemonSelectionViewController;

@property (nonatomic, strong) UIView      * backgroundView;
@property (nonatomic, strong) UILabel     * title;
@property (nonatomic, strong) UILabel     * message;
@property (nonatomic, strong) UIButton    * confirmButton;
@property (nonatomic, strong) UITextField * nameInputView;

- (void)_setupNotificationObserver;
- (void)_unloadViewAnimated:(BOOL)animated;
- (void)_moveConfirmButtonToBottom:(BOOL)toBottom animated:(BOOL)animated;
- (void)_showConfirmButton:(NSNotification *)notification;
- (void)_hideConfirmButton:(NSNotification *)notification;
- (void)_confirm:(id)sender;
- (void)setTextViewWithTitle:(NSString *)title message:(NSString *)message;

// username's checking
- (BOOL)_isValidOfName:(NSString *)name;
- (void)_checkUniquenessForName:(NSString *)name;

@end


@implementation NewbieGuideViewController

@synthesize serverAPIClient                = serverAPIClient_;
@synthesize trainer                        = trainer_;
@synthesize pokemonSelectionViewController = pokemonSelectionViewController_;

@synthesize backgroundView = backgroundView_;
@synthesize title          = title_;
@synthesize message        = message_;
@synthesize confirmButton  = confirmButton_;
@synthesize nameInputView  = nameInputView_;

- (void)dealloc
{
  // Remove notification observer
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.serverAPIClient = [ServerAPIClient sharedInstance];
    self.trainer         = [TrainerController sharedInstance];
    isProcessing_    = NO;
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
  [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINLaunchViewBackground]]];
  [view setOpaque:NO];
  [view setAlpha:0.f];  
  self.view = view;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  backgroundView_ = [[UIView alloc] initWithFrame:self.view.frame];
  [backgroundView_ setBackgroundColor:[UIColor clearColor]];
  [backgroundView_ setAlpha:.85f];
  [self.view addSubview:backgroundView_];
  
  // Constants  
  titleFrame_ = CGRectMake(30.f, 60.f, 260.f, 32.f);
  messageFrame_ = CGRectMake(30.f, 102.f, 260.f, 64.f);
  
  // Title
  title_ = [[UILabel alloc] initWithFrame:titleFrame_];
  [title_ setBackgroundColor:[UIColor clearColor]];
  [title_ setTextColor:[GlobalRender textColorOrange]];
  [title_ setFont:[GlobalRender textFontBoldInSizeOf:20.f]];
  [self.view addSubview:title_];
  
  // Message
  message_ = [[UILabel alloc] initWithFrame:messageFrame_];
  [message_ setBackgroundColor:[UIColor clearColor]];
  [message_ setTextColor:[GlobalRender textColorNormal]];
  [message_ setFont:[GlobalRender textFontBoldInSizeOf:14.f]];
  [message_ setLineBreakMode:NSLineBreakByWordWrapping];
  [message_ setNumberOfLines:0];
  [message_ sizeToFit];
  [self.view addSubview:message_];
  
  // confirm button
  confirmButton_ = [[UIButton alloc] init];
  [confirmButton_ setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal] forState:UIControlStateNormal];
  [confirmButton_ setImage:[UIImage imageNamed:kPMINMainButtonConfirm] forState:UIControlStateNormal];
  [confirmButton_ addTarget:self action:@selector(_confirm:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:confirmButton_];
  [self _moveConfirmButtonToBottom:YES animated:NO];
  
  // Layouts for different steps
  // Name setting input view
  CGRect nameInputViewFrame = CGRectMake(30.f, (kViewHeight - 32.f) / 2.f - 50.f, 260.f, 32.f);
  nameInputView_ = [[UITextField alloc] initWithFrame:nameInputViewFrame];
  [nameInputView_ setBackgroundColor:[UIColor whiteColor]];
  [nameInputView_ setTextColor:[UIColor blackColor]];
  [nameInputView_ setFont:[GlobalRender textFontBoldInSizeOf:16]];
  [nameInputView_ setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
  [nameInputView_ setKeyboardType:UIKeyboardTypeDefault];
  [nameInputView_ setDelegate:self];
  
  // Pokemon Selection view
  pokemonSelectionViewController_ = [[PokemonSelectionViewController alloc] init];
  NSArray * pokemonSIDs = [[NSArray alloc] initWithObjects:
                           [NSNumber numberWithInt:1],
                           [NSNumber numberWithInt:4],
                           [NSNumber numberWithInt:7], nil];
  [pokemonSelectionViewController_ initWithPokemonsWithSIDs:pokemonSIDs];
  
  
  [self setTextViewWithTitle:@"PMSNewbiewGuide1Title" message:@"PMSNewbiewGuide1Message"];
  [self.nameInputView setText:[self.trainer name]]; // Default name
  [self.view addSubview:self.nameInputView];
  guideStep_ = 1;
  
  // Setup notification observer
  [self _setupNotificationObserver];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.backgroundView = nil;
  self.title          = nil;
  self.message        = nil;
  self.confirmButton  = nil;
  self.nameInputView.delegate = nil;
  self.nameInputView  = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

// Load view
- (void)loadViewAnimated:(BOOL)animated
{
  void (^animations)() = ^(){[self.view setAlpha:1.f];};
  if (animated) [UIView animateWithDuration:.3f
                                      delay:0.f
                                    options:UIViewAnimationOptionCurveEaseIn
                                 animations:animations
                                 completion:nil];
  else animations();
}

#pragma mark - Private Methods

// Setup notification observer
- (void)_setupNotificationObserver
{
  NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
  // Add observer for notification from |PokemonSelectionViewController|
  [notificationCenter addObserver:self
                         selector:@selector(_showConfirmButton:)
                             name:kPMNShowConfirmButtonInNebbieGuide
                           object:self.pokemonSelectionViewController];
  [notificationCenter addObserver:self
                         selector:@selector(_hideConfirmButton:)
                             name:kPMNHideConfirmButtonInNebbieGuide
                           object:self.pokemonSelectionViewController];
}

// Unload view
- (void)_unloadViewAnimated:(BOOL)animated
{
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
- (void)_moveConfirmButtonToBottom:(BOOL)toBottom
                          animated:(BOOL)animated
{
  CGRect confirmButtonFrame =
    CGRectMake((kViewWidth - kCenterMainButtonSize) / 2,
               toBottom ? kViewHeight - 160.f : (kViewHeight - kCenterMainButtonSize) / 2,
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
- (void)_showConfirmButton:(NSNotification *)notification
{
  [self.confirmButton setImage:[UIImage imageNamed:kPMINMainButtonConfirm]
                      forState:UIControlStateNormal];
  [self _moveConfirmButtonToBottom:YES animated:YES];
}

// Hide |confirmButton_|
- (void)_hideConfirmButton:(NSNotification *)notification
{
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     CGRect confirmButtonFrame = self.confirmButton.frame;
                     confirmButtonFrame.origin.y = kViewHeight - kCenterMainButtonSize / 2;
                     [self.confirmButton setFrame:confirmButtonFrame];
                   }
                   completion:^(BOOL finished) {
                     [self.confirmButton setImage:[UIImage imageNamed:kPMINMainButtonHalfCancel]
                                         forState:UIControlStateNormal];
                   }];
}

// Action for |confirmButton_|
- (void)_confirm:(id)sender
{
  // If is processing, do nothing until processing done
  if (isProcessing_)
    return;
  
  switch (guideStep_) {
    case 1: {
      NSString * name = self.nameInputView.text;
      NSLog(@"New Name:%@", name);
      // check validity for |name|.
      //   if valid, do |_checkUniquenessForName:|
      //   otherwise, show error message to user
      if ([self _isValidOfName:name])
        [self _checkUniquenessForName:name];
      else {
        [UIView animateWithDuration:.3f
                              delay:0.f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                           [self.title   setAlpha:0.f];
                           [self.message setAlpha:0.f];
                         }
                         completion:^(BOOL finished) {
                           [self setTextViewWithTitle:@"PMSNewbiewGuideErrorTitle"
                                              message:@"PMSNewbiewGuideErrorTextNameInvalid"];
                           [UIView animateWithDuration:.3f
                                                 delay:0.f
                                               options:UIViewAnimationOptionCurveLinear
                                            animations:^{
                                              [self.title   setAlpha:1.f];
                                              [self.message setAlpha:1.f];
                                            }
                                            completion:nil];
                         }];
      }
      break;
    }
      
    case 2: {
      // If Pokemon datail info view is opening, unload it
      if (self.pokemonSelectionViewController.isSelectedPokemonInfoViewOpening) {
        [self.pokemonSelectionViewController unloadSelcetedPokemonInfoView];
        return;
      }
      // If |PokemonSelectionViewController|'s view showing (|confirmButton_| in bottom), unload view
      if (self.confirmButton.frame.origin.y == kViewHeight - kCenterMainButtonSize / 2) {
        [self.pokemonSelectionViewController unloadPokemonSelectionViewAnimated:YES];
        return;
      }
      // If no Pokemon selected, do nothing
      if (self.pokemonSelectionViewController.selectedPokemonSID == 0)
        return;
      
      // Go next step & save Pokemon 
      [UIView animateWithDuration:.3f
                            delay:0.f
                          options:UIViewAnimationOptionCurveLinear
                       animations:^{
                         [self.title   setAlpha:0.f];
                         [self.message setAlpha:0.f];
                         [self.pokemonSelectionViewController.view setAlpha:0.f];
                         [self _moveConfirmButtonToBottom:NO animated:NO];
                       }
                       completion:^(BOOL finished) {
                         [self.pokemonSelectionViewController.view removeFromSuperview];
                         [self setTextViewWithTitle:@"PMSNewbiewGuide3Title" message:@"PMSNewbiewGuide3Message"];
                         [UIView animateWithDuration:.3f
                                               delay:0.f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                            [self.title   setAlpha:1.f];
                                            [self.message setAlpha:1.f];
                                          }
                                          completion:nil];
                       }];
      // Add Selected Wild Pokemon as one of Tamed Pokemon
      NSInteger pokemonSID = self.pokemonSelectionViewController.selectedPokemonSID;
      [self.trainer caughtNewWildPokemon:[WildPokemon queryPokemonDataWithSID:pokemonSID]
                                    memo:@"PMSMemo001"];
      ++guideStep_;
      break;
    }
      
    case 3:
      [self.trainer sync];
      [self _unloadViewAnimated:YES];
      break;
      
    default:
      break;
  }
}

// Set text for |textView1_| & |textView2_|
- (void)setTextViewWithTitle:(NSString *)title
                     message:(NSString *)message
{
  [self.title setFrame:titleFrame_];
  [self.title setText:NSLocalizedString(title, nil)];
  [self.title sizeToFit];
  
  [self.message setFrame:messageFrame_];
  [self.message setText:NSLocalizedString(message, nil)];
  [self.message sizeToFit];
}

// username's validity & uniqueness checking
- (BOOL)_isValidOfName:(NSString *)name
{
  // At least 3 characters, max 20
  if ([name length] < 3 || [name length] > 20)
    return NO;
  NSString * unWantedCharacterSet = @" ~!@#$%%^&*()={}[]|;’:\"<>,?/`";
  return ([name rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedCharacterSet]].location
          == NSNotFound);
}

// check uniqueness for name
- (void)_checkUniquenessForName:(NSString *)name
{
  // Block: |success| & |failure|
  void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
    // Response:-1:ERROR: 0:Name Exist 1:OK
    NSInteger uniqueness = [[responseObject valueForKey:@"u"] intValue];
    NSString * newTitle;
    NSString * newMessage;
    NSLog(@"...|checkUniquenessForName| data success...response value of |uniqueness|:%d", uniqueness);
    if (uniqueness == 1) {
      [self.trainer setName:name];
      newTitle   = @"PMSNewbiewGuide2Title";
      newMessage = @"PMSNewbiewGuide2Message";
      ++guideStep_;
      // Add view for Pokemon Selection
      [self.view insertSubview:self.pokemonSelectionViewController.view belowSubview:self.confirmButton];
      [self.pokemonSelectionViewController.view setAlpha:0.f];
    } else {
      [self.confirmButton setImage:[UIImage imageNamed:kPMINMainButtonCancel] forState:UIControlStateNormal];
      newTitle = @"PMSNewbiewGuideErrorTitle";
      if (uniqueness == 0) newMessage = @"PMSNewbiewGuideErrorTextNameExist";
      else newMessage = @"PMSNewbiewGuideErrorUnknow";
    }
    
    void (^animations)() = ^() {
      if (uniqueness == 1) {
        [self.nameInputView                       setAlpha:0.f];
        [self.pokemonSelectionViewController.view setAlpha:1.f];
      }
      [self.title   setAlpha:0.f];
      [self.message setAlpha:0.f];
    };
    void (^completion)(BOOL) = ^(BOOL finished) {
      [self setTextViewWithTitle:newTitle message:newMessage];
      if (uniqueness == 1)
        [self.nameInputView removeFromSuperview];
      [UIView animateWithDuration:.3f
                            delay:0.f
                          options:UIViewAnimationOptionCurveLinear
                       animations:^{
                         [self.title   setAlpha:1.f];
                         [self.message setAlpha:1.f];
                       }
                       completion:nil];
    };
    [UIView animateWithDuration:.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:animations
                     completion:completion];
    isProcessing_ = NO;
  };
  void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"!!! |checkUniquenessForName| data failed ERROR: %@", error);
    isProcessing_ = NO;
    return;
  };
  
  isProcessing_ = YES;
  [self.serverAPIClient checkUniquenessForName:name success:success failure:failure];
}

#pragma mark - UITextView Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [self.confirmButton setImage:[UIImage imageNamed:kPMINMainButtonConfirm] forState:UIControlStateNormal];
  [self.nameInputView resignFirstResponder];
  return YES;
}

@end
