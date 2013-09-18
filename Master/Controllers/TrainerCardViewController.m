//
//  TrainerInfoViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "TrainerCardViewController.h"

#import "GlobalRender.h"
#import "TrainerBadgeView.h"
#import "ServerAPIClient.h"
#import "TrainerController.h"

#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

typedef enum {
 kTrainerInfoSettingButtonTypeName   = 100,
 kTrainerInfoSettingButtonTypeAvatar 
}TrainerInfoSettingButtonType;


@interface TrainerCardViewController () {
 @private
  UIView            * mainView_;
  UIView            * avatarArea_;
  UIImageView       * imageView_;
  UIView            * IDView_;
  UILabel           * IDLabel_;
  UILabel           * nameLabel_;
  UIView            * dataView_;
  UILabel           * moneyLabel_;
  UILabel           * moneyValue_;
  UILabel           * pokedexLabel_;
  UILabel           * pokedexValue_;
  TrainerBadgeView  * badgeView_;
  UILabel           * adventureStartedTimeLabel_;
  UILabel           * adventureStartedTimeValue_;
  
  UIButton          * avatarSetttingButton_;
  UIButton          * nameSettingButton_;
  UIView            * settingView_;
  UITextField       * nameSettingField_;   // Name setting input field
  UILabel           * nameSettingMessage_; // Message for name setting problem
  UIView            * transparentView_;
  
  TrainerController      * trainer_;
  UITapGestureRecognizer * twoFingersTwoTapsGestureRecognizer_;
  BOOL                     isSetttingButtonsHidden_;
}

@property (nonatomic, strong) UIView            * mainView;
@property (nonatomic, strong) UIView            * avatarArea;
@property (nonatomic, strong) UIImageView       * imageView;
@property (nonatomic, strong) UIView            * IDView;
@property (nonatomic, strong) UILabel           * IDLabel;
@property (nonatomic, strong) UILabel           * nameLabel;
@property (nonatomic, strong) UIView            * dataView;
@property (nonatomic, strong) UILabel           * moneyLabel;
@property (nonatomic, strong) UILabel           * moneyValue;
@property (nonatomic, strong) UILabel           * pokedexLabel;
@property (nonatomic, strong) UILabel           * pokedexValue;
@property (nonatomic, strong) TrainerBadgeView  * badgeView;
@property (nonatomic, strong) UILabel           * adventureStartedTimeLabel;
@property (nonatomic, strong) UILabel           * adventureStartedTimeValue;

@property (nonatomic, strong) UIButton          * avatarSetttingButton;
@property (nonatomic, strong) UIButton          * nameSettingButton;
@property (nonatomic, strong) UIView            * settingView;
@property (nonatomic, strong) UITextField       * nameSettingField;
@property (nonatomic, strong) UILabel           * nameSettingMessage;
@property (nonatomic, strong) UIView            * transparentView;

@property (nonatomic, strong) TrainerController      * trainer;
@property (nonatomic, strong) UITapGestureRecognizer * twoFingersTwoTapsGestureRecognizer;

- (void)_tapViewAction:(UITapGestureRecognizer *)recognizer;
- (void)_setSettingButtonsHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)_showSettingView:(id)sender;
- (void)_commitSetting;
- (void)_cancelSettingViewAnimated:(BOOL)animated;

@end

@implementation TrainerCardViewController

@synthesize mainView     = mainView_;
@synthesize avatarArea   = avatarArea_;
@synthesize imageView    = imageView_;
@synthesize IDView       = IDView_;
@synthesize IDLabel      = IDLabel_;
@synthesize nameLabel    = nameLabel_;
@synthesize dataView     = dataView_;
@synthesize moneyLabel   = moneyLabel_;
@synthesize moneyValue   = moneyValue_;
@synthesize pokedexLabel = pokedexLabel_;
@synthesize pokedexValue = pokedexValue_;
@synthesize badgeView    = badgeView_;
@synthesize adventureStartedTimeLabel = adventureStartedTimeLabel_;
@synthesize adventureStartedTimeValue = adventureStartedTimeValue_;

@synthesize avatarSetttingButton               = avatarSetttingButton_;
@synthesize nameSettingButton                  = nameSettingButton_;
@synthesize settingView                        = settingView_;
@synthesize nameSettingField                   = nameSettingField_;
@synthesize nameSettingMessage                 = nameSettingMessage_;
@synthesize transparentView                    = transparentView_;

@synthesize trainer                            = trainer_;
@synthesize twoFingersTwoTapsGestureRecognizer = twoFingersTwoTapsGestureRecognizer_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    // Custom initialization
    [self setTitle:NSLocalizedString(@"Trainer Card", nil)];
    self.trainer = [TrainerController sharedInstance];
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
  
  // Constants
  CGFloat const avatarAreaSize    = 112.f;
  CGFloat const imageSize         = 100.f;
  CGFloat const labelHeight       = 30.f;
  CGFloat const labelWidth        = 105.f;
  CGFloat const valueHeight       = 30.f;
  CGFloat const valueWidth        = 290.f - labelWidth;
  CGFloat const nameLabelWidth    = 290.f - imageSize;
  CGFloat const nameLabelHeight   = imageSize / 2 - labelHeight;
  
  CGRect  const mainViewFrame  = CGRectMake(0.f, 0.f, kViewWidth, kViewHeight - kTopBarHeight);
  CGRect  const IDViewFrame    = CGRectMake(avatarAreaSize + 20.f, 30.f, 290.f - avatarAreaSize, avatarAreaSize - 50.f);
  CGRect  const dataViewFrame  = CGRectMake(15.f, avatarAreaSize + 35.f, 290.f, 195.f);
  CGRect  const IDLabelFrame   = CGRectMake(0.f, 0.f, IDViewFrame.size.width, labelHeight);
  CGRect  const nameLabelFrame = CGRectMake(10.f, labelHeight, nameLabelWidth, nameLabelHeight);
  CGRect  const badgeViewFrame = CGRectMake(0.f, labelHeight * 2, 290.f, labelHeight);
  CGRect  const adventureStartedTimeLabelFrame =
    CGRectMake(0.f, dataViewFrame.size.height - 50.f, 150.f, labelHeight);
  CGRect  const adventureStartedTimeValueFrame =
    CGRectMake(150.f, dataViewFrame.size.height - 50.f, 140.f, valueHeight);
  
  
  // Main View
  mainView_ = [[UIView alloc] initWithFrame:mainViewFrame];
  [view addSubview:mainView_];
  
  ///Left avatar area
  avatarArea_ = [[UIView alloc] initWithFrame:CGRectMake(15.f, 20.f, avatarAreaSize, avatarAreaSize)];
  [avatarArea_ setBackgroundColor:[UIColor whiteColor]];
  [avatarArea_.layer setCornerRadius:(avatarAreaSize / 2.f)];
  [self.mainView addSubview:avatarArea_];
  
  // Image View
  imageView_ = [[UIImageView alloc] initWithFrame:
                  CGRectMake((avatarAreaSize - imageSize) / 2.f, (avatarAreaSize - imageSize) / 2.f, imageSize, imageSize)];
  [imageView_ setUserInteractionEnabled:YES];
  [imageView_ setContentMode:UIViewContentModeScaleAspectFit];
  [imageView_ setBackgroundColor:[UIColor clearColor]];
  [imageView_.layer setMasksToBounds:YES];
  [imageView_.layer setCornerRadius:(imageSize / 2.f)];
  [self.avatarArea addSubview:imageView_];
  
  
  ///Right ID View
  IDView_ = [[UIView alloc] initWithFrame:IDViewFrame];
  
  // ID
  IDLabel_ = [[UILabel alloc] initWithFrame:IDLabelFrame];
  [IDLabel_ setBackgroundColor:[UIColor clearColor]];
  [IDLabel_ setTextColor:[GlobalRender textColorTitleWhite]];
  [IDLabel_ setFont:[GlobalRender textFontBoldInSizeOf:14.f]];
  [IDLabel_.layer setShadowColor:[UIColor blackColor].CGColor];
  [IDLabel_.layer setShadowOpacity:1.f];
  [IDLabel_.layer setShadowOffset:CGSizeMake(-1.f, -1.f)];
  [IDLabel_.layer setShadowRadius:0.f];
  [IDView_ addSubview:IDLabel_];
  
  // Name
  nameLabel_ = [[UILabel alloc] initWithFrame:nameLabelFrame];
  [nameLabel_ setBackgroundColor:[UIColor clearColor]];
  [nameLabel_ setLineBreakMode:NSLineBreakByWordWrapping];
  [nameLabel_ setTextColor:[GlobalRender textColorOrange]];
  [nameLabel_ setFont:[GlobalRender textFontBoldInSizeOf:20.f]];
  [nameLabel_ setNumberOfLines:0];
  [nameLabel_.layer setShadowColor:[UIColor blackColor].CGColor];
  [nameLabel_.layer setShadowOpacity:1.f];
  [nameLabel_.layer setShadowOffset:CGSizeMake(-1.f, -1.f)];
  [nameLabel_.layer setShadowRadius:0.f];
  [IDView_ addSubview:nameLabel_];
  
  [self.mainView addSubview:IDView_];
  
  
  ///Data View in Center
  dataView_ = [[UIView alloc] initWithFrame:dataViewFrame];
  
  // Money
  moneyLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, labelWidth, labelHeight)];
  moneyValue_ = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, 0.f, valueWidth, valueHeight)];
  [moneyLabel_ setBackgroundColor:[UIColor clearColor]];
  [moneyValue_ setBackgroundColor:[UIColor clearColor]];
  [moneyLabel_ setTextColor:[GlobalRender textColorTitleWhite]];
  [moneyValue_ setTextColor:[GlobalRender textColorNormal]];
  [moneyLabel_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  [moneyValue_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  [moneyLabel_ setTextAlignment:NSTextAlignmentRight];
  [moneyValue_ setTextAlignment:NSTextAlignmentLeft];
  [dataView_ addSubview:moneyLabel_];
  [dataView_ addSubview:moneyValue_];
  
  // Pokedex
  pokedexLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0.f, labelHeight, labelWidth, labelHeight)];
  pokedexValue_ = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, labelHeight, valueWidth, valueHeight)];
  [pokedexLabel_ setBackgroundColor:[UIColor clearColor]];
  [pokedexValue_ setBackgroundColor:[UIColor clearColor]];
  [pokedexLabel_ setTextColor:[GlobalRender textColorTitleWhite]];
  [pokedexValue_ setTextColor:[GlobalRender textColorNormal]];
  [pokedexLabel_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  [pokedexValue_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  [pokedexLabel_ setTextAlignment:NSTextAlignmentRight];
  [pokedexValue_ setTextAlignment:NSTextAlignmentLeft];
  [dataView_ addSubview:pokedexLabel_];
  [dataView_ addSubview:pokedexValue_];
  
  // Badges
  badgeView_ = [[TrainerBadgeView alloc] initWithFrame:badgeViewFrame];
  [self.dataView addSubview:badgeView_];
  
  // Adventure Started
  adventureStartedTimeLabel_ = [[UILabel alloc] initWithFrame:adventureStartedTimeLabelFrame];
  adventureStartedTimeValue_ = [[UILabel alloc] initWithFrame:adventureStartedTimeValueFrame];
  [adventureStartedTimeLabel_ setBackgroundColor:[UIColor clearColor]];
  [adventureStartedTimeValue_ setBackgroundColor:[UIColor clearColor]];
  [adventureStartedTimeLabel_ setTextColor:[GlobalRender textColorTitleWhite]];
  [adventureStartedTimeValue_ setTextColor:[GlobalRender textColorNormal]];
  [adventureStartedTimeLabel_ setFont:[GlobalRender textFontBoldInSizeOf:13.f]];
  [adventureStartedTimeValue_ setFont:[GlobalRender textFontBoldInSizeOf:13.f]];
  [adventureStartedTimeLabel_ setTextAlignment:NSTextAlignmentRight];
  [adventureStartedTimeValue_ setTextAlignment:NSTextAlignmentLeft];
  [dataView_ addSubview:adventureStartedTimeLabel_];
  [dataView_ addSubview:adventureStartedTimeValue_];
  
  [self.mainView addSubview:dataView_];
  
  self.view = view;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Basic Setting
  isSetttingButtonsHidden_ = YES;
  
  [self.imageView setImageWithURL:[self.trainer avatarURL]
                 placeholderImage:[UIImage imageNamed:kPMINTrainerAvatarDefault]];
  [self.IDLabel setText:[NSString stringWithFormat:@"ID: #%.8d", [self.trainer UID]]];
  [self.moneyLabel   setText:NSLocalizedString(@"PMSLabelMoney", nil)];
  [self.pokedexLabel setText:NSLocalizedString(@"PMSLabelPokedex", nil)];
  [self.adventureStartedTimeLabel setText:NSLocalizedString(@"PMSLabelAdventureStarted", nil)];
  NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm"];
  [self.adventureStartedTimeValue setText:[dateFormat stringFromDate:[self.trainer timeStarted]]];
  
  // Add Gesture
  // Two fingers with two taps to show setting buttons for Trainer Info View
  UITapGestureRecognizer * twoFingersTwoTapsGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapViewAction:)];
  self.twoFingersTwoTapsGestureRecognizer = twoFingersTwoTapsGestureRecognizer;
  [self.twoFingersTwoTapsGestureRecognizer setNumberOfTapsRequired:2];
  [self.twoFingersTwoTapsGestureRecognizer setNumberOfTouchesRequired:2];
  [self.view addGestureRecognizer:self.twoFingersTwoTapsGestureRecognizer];
  
  // Implement the completion block
  // iOS4 will not call |viewWillAppear:| when the VC is a child of another VC
  if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
    [self viewWillAppear:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // Set new data
  [self.nameLabel setText:[self.trainer name]];
  [self.nameLabel sizeToFit];
  [self.moneyValue   setText:[NSString stringWithFormat:@"§ %d", [self.trainer money]]];
  [self.pokedexValue setText:[NSString stringWithFormat:@"%d",   [self.trainer numberOfPokemonsForPokedex]]];
  [self.badgeView updateBadges:[self.trainer badges]];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.mainView                  = nil;
  self.avatarArea                = nil;
  self.imageView                 = nil;
  self.IDView                    = nil;
  self.IDLabel                   = nil;
  self.nameLabel                 = nil;
  self.dataView                  = nil;
  self.moneyLabel                = nil;
  self.moneyValue                = nil;
  self.pokedexLabel              = nil;
  self.pokedexValue              = nil;
  self.badgeView                 = nil;
  self.adventureStartedTimeLabel = nil;
  self.adventureStartedTimeValue = nil;
  
  self.avatarSetttingButton = nil;
  self.nameSettingButton    = nil;
  self.settingView          = nil;
  self.nameSettingField     = nil;
  self.nameSettingMessage   = nil;
  self.transparentView      = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Method

// Action for tap gesture recognizer
- (void)_tapViewAction:(UITapGestureRecognizer *)recognizer
{
  // Two fingers with two taps to show setting buttons for Trainer Info View
  if (recognizer.numberOfTouchesRequired == 2 && recognizer.numberOfTapsRequired == 2) {
    NSLog(@"Two Fingers Two Taps");
    [self _setSettingButtonsHidden:!isSetttingButtonsHidden_ animated:YES];
  }
}

- (void)_setSettingButtonsHidden:(BOOL)hidden
                        animated:(BOOL)animated
{
  isSetttingButtonsHidden_ = hidden;
  
  /*if (self.avatarSetttingButton == nil) {
    CGRect avatarSetttingButtonFrame = self.imageView.frame;
    avatarSetttingButtonFrame.origin.x = 0;
    avatarSetttingButtonFrame.origin.y = 0;
    UIButton * avatarSetttingButton = [[UIButton alloc] initWithFrame:avatarSetttingButtonFrame];
    self.avatarSetttingButton = avatarSetttingButton;
    [avatarSetttingButton release];
    [self.avatarSetttingButton setAlpha:0.f];
    [self.avatarSetttingButton setTag:kTrainerInfoSettingButtonTypeAvatar];
    [self.avatarSetttingButton addTarget:self action:@selector(_showSettingView:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:self.avatarSetttingButton];
    
    UIImageView * setableMarkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconSettingModify"]];
    [self.avatarSetttingButton addSubview:setableMarkView];
    [setableMarkView release];
  }*/
  
  if (self.nameSettingButton == nil) {
    CGRect nameSettingButtonFrame = self.nameLabel.frame;
    nameSettingButtonFrame.origin.x = 0;
    nameSettingButtonFrame.origin.y = 0;
    UIButton * nameSettingButton = [[UIButton alloc] initWithFrame:nameSettingButtonFrame];
    self.nameSettingButton = nameSettingButton;
    [self.nameSettingButton setAlpha:0.f];
    [self.nameSettingButton setTag:kTrainerInfoSettingButtonTypeName];
    [self.nameSettingButton addTarget:self action:@selector(_showSettingView:)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.nameLabel addSubview:self.nameSettingButton];
    [self.nameLabel setUserInteractionEnabled:YES];
    
    UIImageView * setableMarkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconSettingModify"]];
    [setableMarkView setFrame:CGRectMake(0.f, 0.f, 22.f, 22.f)];
    [self.nameSettingButton addSubview:setableMarkView];
  }
  
  CGFloat alpha = hidden ? 0.f : 1.f;
  void (^animations)() = ^{
//    [self.avatarSetttingButton setAlpha:alpha];
    [self.nameSettingButton    setAlpha:alpha];
  };
  if (animated) [UIView animateWithDuration:.3f
                                      delay:0.f
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:animations
                                 completion:nil];
  else animations();
}

- (void)_showSettingView:(id)sender
{
  if (self.transparentView == nil) {
    UIView * transparentView = [[UIView alloc] initWithFrame:self.view.frame];
    self.transparentView = transparentView;
    [self.transparentView setBackgroundColor:[UIColor blackColor]];
    [self.transparentView setAlpha:0.f];
    [self.mainView addSubview:self.transparentView];
  }
  if (self.settingView == nil) {
    CGFloat buttonSize        = 45.f;
    CGFloat settingViewHeight = 120.f;
    CGRect settingViewFrame = CGRectMake(0.f, -settingViewHeight, kViewWidth, settingViewHeight);
    CGRect settingViewBackgroundFrame =
      CGRectMake(0.f, -kNavigationBarBottomAlphaHegiht, kViewWidth, settingViewHeight - buttonSize / 2);
    CGRect doneButtonFrame   = CGRectMake(80.f, settingViewHeight - buttonSize, buttonSize, buttonSize);
    CGRect cancelButtonFrame = CGRectMake(kViewWidth - 80.f - buttonSize, settingViewHeight - buttonSize, buttonSize, buttonSize);
    
    
    UIView * settingView = [[UIView alloc] initWithFrame:settingViewFrame];
    self.settingView = settingView;
    [self.mainView addSubview:self.settingView];
    
    UIView * settingViewBackground = [[UIView alloc] initWithFrame:settingViewBackgroundFrame];
    [settingViewBackground setBackgroundColor:[GlobalRender colorBlue]];
    [self.settingView addSubview:settingViewBackground];
    
    UIButton * doneButton = [[UIButton alloc] initWithFrame:doneButtonFrame];
    [doneButton setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal] forState:UIControlStateNormal];
    [doneButton setImage:[UIImage imageNamed:kPMINMainButtonConfirmOpposite] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(_commitSetting) forControlEvents:UIControlEventTouchUpInside];
    [self.settingView addSubview:doneButton];
    
    UIButton * cancelButton = [[UIButton alloc] initWithFrame:cancelButtonFrame];
    [cancelButton setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:kPMINMainButtonCancelOpposite] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(_cancelSettingViewAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [self.settingView addSubview:cancelButton];
  }
  
  switch (((UIButton *)sender).tag) {
    case kTrainerInfoSettingButtonTypeName: {
      NSLog(@"Commit Setting -> Name");
      if (self.nameSettingField == nil) {
        CGRect nameSettingFieldFrame   = CGRectMake(10.f, 15.f, 300.f, 32.f);
        CGRect nameSettingMessageFrame = CGRectMake(10.f, 47.f, 300.f, 32.f);
        
        UITextField * nameSettingField = [[UITextField alloc] initWithFrame:nameSettingFieldFrame];
        self.nameSettingField = nameSettingField;
        [self.nameSettingField setBackgroundColor:[UIColor whiteColor]];
        [self.nameSettingField setKeyboardType:UIKeyboardTypeDefault];
        
        UILabel * nameSettingMessage = [[UILabel alloc] initWithFrame:nameSettingMessageFrame];
        self.nameSettingMessage = nameSettingMessage;
        [self.nameSettingMessage setBackgroundColor:[UIColor clearColor]];
        [self.nameSettingMessage setTextColor:[GlobalRender textColorTitleWhite]];
        [self.nameSettingMessage setFont:[GlobalRender textFontNormalInSizeOf:14.f]];
        [self.nameSettingMessage setTextAlignment:NSTextAlignmentLeft];
      }
      [self.settingView addSubview:self.nameSettingField];
      [self.settingView addSubview:self.nameSettingMessage];
      // Set |nameLabel_.text| as the default text for |nameSettingField_|,
      //   and show Keyboard
      [self.nameSettingField   setText:self.nameLabel.text];
      [self.nameSettingMessage setText:NSLocalizedString(@"PMSLabelNameSettingMessage1", nil)];
      [self.nameSettingField becomeFirstResponder];
      break;
    }
      
    case kTrainerInfoSettingButtonTypeAvatar:
      NSLog(@"Commit Setting -> Avatar");
      break;
      
    default:
      break;
  }
  
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     [self.transparentView setAlpha:.6f];
                     CGRect settingViewFrame = self.settingView.frame;
                     settingViewFrame.origin.y = 0.f;
                     [self.settingView setFrame:settingViewFrame];
                   }
                   completion:nil];
}

// Commit settings done by user
- (void)_commitSetting
{
  NSLog(@"|_commitSetting| - InputText:%@", self.nameSettingField.text);
  // If user changed name, reset |trainer_.name| & |nameLabel_.text|
  NSString * name = self.nameSettingField.text;
  if (! [name isEqualToString:self.nameLabel.text]) {
    NSLog(@"|_commitSetting| - User name changed, checking uniqueness...");
    // Block: |success| & |failure|
    void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
      // Response:-1:ERROR: 0:Name Exist 1:OK
      NSInteger uniqueness = [[responseObject valueForKey:@"u"] intValue];
      NSLog(@"|_commitSetting| - web server response value of |uniqueness|:%d", uniqueness);
      // Name is uniqueness, do sync work
      if (uniqueness == 1) {
        NSLog(@"|_commitSetting| - Name is uniqueness, do sync work...");
        [self.trainer setName:name];
        
        CGFloat const imageSize       = 100.f;
        CGFloat const labelHeight     = 30.f;
        CGFloat const nameLabelWidth  = 290.f - imageSize;
        CGFloat const nameLabelHeight = imageSize / 2 - labelHeight;
        CGRect  const nameLabelFrame  = CGRectMake(0.0f, labelHeight, nameLabelWidth, nameLabelHeight);
        [self.nameLabel setFrame:nameLabelFrame];
        [self.nameLabel setText:[self.trainer name]];
        [self.nameLabel sizeToFit];
      }
      // Name already exists
      else if (uniqueness == 0) {
        NSLog(@"!!! |_commitSetting| - Name is already exists...");
        [self.nameSettingMessage setText:NSLocalizedString(@"PMSLabelNameSettingMessage2", nil)];
        return;
      }
      else {
        [self.nameSettingMessage setText:NSLocalizedString(@"PMSLabelNameSettingMessage3", nil)];
        return;
      }
    };
    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"!!! |_commitSetting| data fetching failed ERROR: %@", error);
      [self.nameSettingMessage setText:NSLocalizedString(@"PMSLabelNameSettingMessage3", nil)];
      return;
    };
    
    // Check UNIQUENESS for user name
    [[ServerAPIClient sharedInstance] checkUniquenessForName:name success:success failure:failure];
  }
  [self _cancelSettingViewAnimated:YES];
}

// Cancel |settingView_|
- (void)_cancelSettingViewAnimated:(BOOL)animated
{
  [self.nameSettingField resignFirstResponder];
  
  void (^animations)() = ^{
    CGRect settingViewFrame = self.settingView.frame;
    settingViewFrame.origin.y = -settingViewFrame.size.height - kNavigationBarBottomAlphaHegiht;
    [self.settingView setFrame:settingViewFrame];
    [self.transparentView setAlpha:0.f];
  };
  
  if (animated) [UIView animateWithDuration:.3f
                                      delay:0.f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:animations
                                 completion:nil];
  else animations();
}

@end
