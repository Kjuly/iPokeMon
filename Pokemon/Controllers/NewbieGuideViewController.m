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

@property (nonatomic, retain) ServerAPIClient                * serverAPIClient;
@property (nonatomic, retain) TrainerController              * trainer;
@property (nonatomic, retain) PokemonSelectionViewController * pokemonSelectionViewController;

@property (nonatomic, retain) UIView      * backgroundView;
@property (nonatomic, retain) UILabel     * title;
@property (nonatomic, retain) UILabel     * message;
@property (nonatomic, retain) UIButton    * confirmButton;
@property (nonatomic, retain) UITextField * nameInputView;

- (void)releaseSubviews;
- (void)unloadViewAnimated:(BOOL)animated;
- (void)moveConfirmButtonToBottom:(BOOL)toBottom animated:(BOOL)animated;
- (void)showConfirmButton:(NSNotification *)notification;
- (void)hideConfirmButton:(NSNotification *)notification;
- (void)confirm:(id)sender;
- (void)setTextViewWithTitle:(NSString *)title message:(NSString *)message;

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

- (void)dealloc {
  self.serverAPIClient                = nil;
  self.trainer                        = nil;
  self.pokemonSelectionViewController = nil;
  [self releaseSubviews];
  
  // Remove notification observer
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kPMNShowConfirmButtonInNebbieGuide
                                                object:self.pokemonSelectionViewController];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kPMNHideConfirmButtonInNebbieGuide
                                                object:self.pokemonSelectionViewController];
  [super dealloc];
}

- (void)releaseSubviews {
  self.backgroundView = nil;
  self.title          = nil;
  self.message        = nil;
  self.confirmButton  = nil;
  self.nameInputView.delegate = nil;
  self.nameInputView  = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
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
  self.view = view;
  [view release];
  [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINLaunchViewBackground]]];
  [self.view setOpaque:NO];
  [self.view setAlpha:0.f];

  backgroundView_ = [[UIView alloc] initWithFrame:self.view.frame];
  [backgroundView_ setBackgroundColor:[UIColor clearColor]];
  [backgroundView_ setAlpha:.85f];
  [self.view addSubview:backgroundView_];
  
  // Constants
//  textView1Frame_ = CGRectMake(30.f, 60.f, 260.f, 40.f);
//  textView2Frame_ = CGRectMake(30.f, 100.f, 260.f, 40.f);
  
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
  [message_ setLineBreakMode:UILineBreakModeWordWrap];
  [message_ setNumberOfLines:0];
  [message_ sizeToFit];
  [self.view addSubview:message_];
  
  // confirm button
  confirmButton_ = [[UIButton alloc] init];
  [confirmButton_ setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal] forState:UIControlStateNormal];
  [confirmButton_ setImage:[UIImage imageNamed:kPMINMainButtonNormal] forState:UIControlStateNormal];
  [confirmButton_ addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:confirmButton_];
  [self moveConfirmButtonToBottom:YES animated:NO];
  
  // Layouts for different steps
  // Name setting input view
  CGRect nameInputViewFrame = CGRectMake(30.f, (kViewHeight - 32.f) / 2.f - 50.f, 260.f, 32.f);
  nameInputView_ = [[UITextField alloc] initWithFrame:nameInputViewFrame];
  [nameInputView_ setBackgroundColor:[UIColor whiteColor]];
  [nameInputView_ setTextColor:[UIColor blackColor]];
  [nameInputView_ setFont:[GlobalRender textFontBoldInSizeOf:16]];
  [nameInputView_ setKeyboardType:UIKeyboardTypeDefault];
  [nameInputView_ setDelegate:self];
  
  // Pokemon Selection view
  pokemonSelectionViewController_ = [[PokemonSelectionViewController alloc] init];
  NSArray * pokemonSIDs = [[NSArray alloc] initWithObjects:
                           [NSNumber numberWithInt:1],
                           [NSNumber numberWithInt:4],
                           [NSNumber numberWithInt:7], nil];
  [pokemonSelectionViewController_ initWithPokemonsWithSIDs:pokemonSIDs];
  [pokemonSIDs release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setTextViewWithTitle:@"PMSNewbiewGuide1Title" message:@"PMSNewbiewGuide1Message"];
  [self.nameInputView setText:[self.trainer name]]; // Default name
  [self.view addSubview:self.nameInputView];
  guideStep_ = 1;
  
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

- (void)viewDidUnload {
  [super viewDidUnload];
  [self releaseSubviews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
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
- (void)showConfirmButton:(NSNotification *)notification {
  [self.confirmButton setImage:[UIImage imageNamed:kPMINMainButtonConfirm]
                      forState:UIControlStateNormal];
  [self moveConfirmButtonToBottom:YES animated:YES];
}

// Hide |confirmButton_|
- (void)hideConfirmButton:(NSNotification *)notification {
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
- (void)confirm:(id)sender {
  // If is processing, do nothing until processing done
  if (isProcessing_)
    return;
  
  switch (guideStep_) {
    case 1: {
      NSString * name = self.nameInputView.text;
      NSLog(@"New Name:%@", name);
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
      };
      
      [self.serverAPIClient checkUniquenessForName:name success:success failure:failure];
      isProcessing_ = YES;
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
      if (self.pokemonSelectionViewController.selectedPokemonUID == 0)
        return;
      
      // Go next step & save Pokemon 
      [UIView animateWithDuration:.3f
                            delay:0.f
                          options:UIViewAnimationOptionCurveLinear
                       animations:^{
                         [self.title   setAlpha:0.f];
                         [self.message setAlpha:0.f];
                         [self.pokemonSelectionViewController.view setAlpha:0.f];
                         [self moveConfirmButtonToBottom:NO animated:NO];
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
      WildPokemon * wildPokemon =
        [WildPokemon queryPokemonDataWithUID:self.pokemonSelectionViewController.selectedPokemonUID];
      [self.trainer caughtNewWildPokemon:wildPokemon memo:@"PMSMemo001"];
      wildPokemon = nil;
      
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
- (void)setTextViewWithTitle:(NSString *)title message:(NSString *)message {
  [self.title setFrame:titleFrame_];
  [self.title setText:NSLocalizedString(title, nil)];
  [self.title sizeToFit];
  
  [self.message setFrame:messageFrame_];
  [self.message setText:NSLocalizedString(message, nil)];
  [self.message sizeToFit];
}

#pragma mark - UITextView Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self.confirmButton setImage:[UIImage imageNamed:kPMINMainButtonConfirm] forState:UIControlStateNormal];
  [self.nameInputView resignFirstResponder];
  return YES;
}

@end
